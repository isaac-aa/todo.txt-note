#!/bin/bash

GIT_DIR=$(dirname $(realpath $0))/../

test_description='notes add-on funcionality
'
. ./test-lib.sh

# For testing use the folder of the add-on source to include todo.txt-note
export TODO_ACTIONS_DIR=$GIT_DIR

test_todo_session 'note show usage' <<EOF
>>> todo.sh note show
usage: todo.sh note show|s ITEM#|(archive|a [TAG|@context|+project|yyyy-mm-dd])
=== 1
EOF

TEST_TASK_1="Buy tools @hammer +shovel"
TEST_TASK_2="Fix bicycle"
TEST_TASK_3="Ride bike"

cat > todo.txt <<EOF
$TEST_TASK_1
$TEST_TASK_2
$TEST_TASK_3
Ride bike
EOF

test_todo_session 'note show on task with no note' <<EOF
>>> todo.sh note show 1
TODO: Task 1 has no note.
=== 1
EOF

# Test add note to task
test_expect_code 0 'note add to task without note' 'echo n | todo.sh note add 1'

# Get the added note, and the note's filename
NOTE_TAG=$(grep -o "note:.*$" todo.txt)
TAG=${NOTE_TAG//note:/}
NOTE_FILE=$(echo $NOTE_TAG | cut -d: -f2).txt

# Avoid messing with the coloring options in the unittests
export TODOTXT_PLAIN=1

test_expect_success 'note add has created a file for the note' '[ -e notes/$NOTE_FILE ]'

test_todo_session 'note add to task with existing note' <<EOF
>>> todo.sh note add 1
TODO: Task 1 already has a note.
=== 1
EOF

test_todo_session 'note show (task with existing note)' <<EOF
>>> todo.sh note show 1
# $TEST_TASK_1 $NOTE_TAG
EOF

test_todo_session 'note show (task with existing note) using tag' <<EOF
>>> todo.sh note show $TAG
# $TEST_TASK_1 $NOTE_TAG
EOF

test_todo_session 'note show (task with existing note) using context' <<EOF
>>> todo.sh note show @hammer
# $TEST_TASK_1 $NOTE_TAG
EOF

test_todo_session 'note show (task with existing note) using project' <<EOF
>>> todo.sh note show +shovel
# $TEST_TASK_1 $NOTE_TAG
EOF

export EDITOR=cat
test_todo_session 'note edit task with existing note' <<EOF
>>> todo.sh note edit 1
# $TEST_TASK_1 $NOTE_TAG
EOF

touch -d "1 day ago" $NOTE_FILE
today=$($TODO_TEST_REAL_DATE +%Y-%m-%d)
test_todo_session 'note edit task with existing old note' <<EOF
>>> echo y | todo.sh note edit 1
# $TEST_TASK_1 $NOTE_TAG

# $today

EOF

test_todo_session 'do (and archive) task with note' <<EOF
>>> todo.sh do 1
1 x 2009-02-13 $TEST_TASK_1 $NOTE_TAG
TODO: 1 marked as done.
x 2009-02-13 $TEST_TASK_1 $NOTE_TAG
TODO: $HOME/todo.txt archived.
EOF

test_expect_success 'The note file related with archived task does not exist anymore' '[ ! -e notes/$NOTE_FILE ]'
test_expect_success 'Note content for archived task has been appended to the notes archive' 'grep "Buy tools" notes/archive.txt'
test_todo_session 'Show the archive' <<EOF
>>> todo.sh note show archive
# $TEST_TASK_1 $NOTE_TAG
EOF

test_todo_session 'Show a note from the archive' <<EOF
>>> todo.sh note show archive $TAG
# $TEST_TASK_1 $NOTE_TAG
EOF

# Populate the archive with a 'finished' task with both tag and context
cat >> notes/archive.txt <<EOF
# Please @test +notes
EOF

test_todo_session 'Show a note from the archive with context' <<EOF
>>> todo.sh note show archive @test
# Please @test +notes
EOF

test_todo_session 'Show a note from the archive with project' <<EOF
>>> todo.sh note show archive +notes
# Please @test +notes
EOF

test_todo_session 'Try to search unexisting tag from the note archive' <<EOF
>>> todo.sh note show archive testest
There is no note with 'testest' in the archive
EOF

test_todo_session 'Try to search unexisting project from the note archive' <<EOF
>>> todo.sh note show archive +testest
There is no note with '+testest' in the archive
EOF

test_todo_session 'Try to search unexisting context from the note archive' <<EOF
>>> todo.sh note show archive @testest
There is no note with '@testest' in the archive
EOF

# Test do without archiving
echo n | todo.sh note add 1 > /dev/null

# Get the added note, and the note's filename
NOTE_TAG=$(grep -o "note:.*$" todo.txt)
NOTE_FILE=$(echo $NOTE_TAG | cut -d: -f2).txt

ARCHIVE_MD5=$(md5sum notes/archive.txt | cut -d\  -f1)

test_todo_session 'do without archiving task with note' <<EOF
>>> todo.sh -a do 1
1 x 2009-02-13 Fix bicycle $NOTE_TAG
TODO: 1 marked as done.
EOF

test_expect_success 'The note file of the done (but not archived) note has not been deleted' '[ -e notes/$NOTE_FILE ]'
test_expect_success 'Archive file has not changed' '[ $ARCHIVE_MD5 = $(md5sum notes/archive.txt | cut -d\  -f1) ]'

# Test rm hook
todo.sh -n -f rm 1 > /dev/null
test_expect_success 'todo.sh rm <#item> deletes the note file' '[ ! -e notes/$NOTE_FILE ]'


# Test rm hook (rm #item #term)
echo n | todo.sh note add 1 > /dev/null

# Get the added note, and the note's filename
NOTE_TAG=$(grep -o "note:.*$" todo.txt)
NOTE_FILE=$(echo $NOTE_TAG | cut -d: -f2).txt

todo.sh rm 1 bike > /dev/null
test_expect_success 'todo.sh rm <#item> <term> does not delete the note file' '[ -e notes/$NOTE_FILE ]'

test_done

