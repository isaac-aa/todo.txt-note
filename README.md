# Note add-on for todotxt

This add-on allows to keep notes attached to tasks. Just one note per task is allowed.
`note` can be used as a fully-fledged diary within `todo.sh`.

This is a fork of the unmaintained version [developed by Manuel J. Garrido](https://github.com/mgarrido/todo.txt-cli/tree/note/todo.actions.d).
The idea behind this repository is to improve and maintain this great note add-on for [todo.txt](https://todotxt.org).

## Example of use

Let's exemplify the usefulness of the `todo.sh` and `note` combination.
Some tasks are fast and easy, such as "Send an email to Bob".
But others require more work, and there is no way in `todo.sh` to keep track of that. Until `note`.

Imagine that you have to do a longer task. For example, implement a feature in a code.
```
> todo.sh add Implement feature A +project
```
This task may take longer than one day and may even involve some trials and errors.
How to keep track of all this? A physical notebook? No, a `note`:
```
> todo.sh note add 1
# 2022-12-30 Implement feature A +project note:FZA
```
The `note:FZA` key-value pair is the unique identifier of this task from now on.
As every task has a unique identifier associated with it, you can do cross-references.
Then, you can use the note as a diary on the progress of the task:
```
> todo.sh note edit 1

I want to implement feature A using as a base [...].
I have some ideas about how to proceed [...]
```

If completing the task takes longer than one day, further edits will be added with date tags:
```
> todo.sh note edit 1
Note has not been edited today, add 'date' header? (y/n) y
# 2022-12-31

I tried to do X but did not work because [...]
```

Later, you can see the note associated with each task or look for given context/projects:
```
> todo.sh note show 1
> todo.sh note show +project
> todo.sh note show FZA
```
Or even what you did in a given day
```
> todo.sh note show 2022-12-31
# 2022-12-31

I tried to do X but did not work because [...]
```

Once finished, the note contents are archived and are still searchable.
```
> todo.sh note show archive +project
> todo.sh note show archive FZA
> todo.sh note show archive 2022-12-31
```

Enough advertisement! Below is detailed documentation.
Feel free to post issues and pull requests.

## Adding, viewing and editing notes

* `note add|a ITEM#`. Adds a new note to task ITEM# and gives the chance to edit it.
* `note edit|e ITEM#`. Opens the note related with task ITEM# in editor.
* `note show|s ITEM#|([archive|a] [TAG|@context|+project|yyyy-mm-dd])`. Shows the note related with task ITEM# or the archive.
  A task TAG, context, project or date can be specified. For example, to look for the contents of notes added a given day: `note s 2023-01-01`.
  The search can be restricted to already finished tasks with `note s archive 2023-01-01`.

The shown notes will be highlighted using the same criteria than `todo.sh`.
In addition, the task names are also highlighted for easier navigation.

## The notes' format

A note is a simple plain text file, with extension `TODO_NOTE_EXT`.
It has sections delimited by lines starting with `# yyyy-mm-dd`.
Until the next section, all the text will be assigned to that task, in that given day.

An example note would be:
```
# 2022-12-14 Do something id:RJUg6

I have to do something, and here I can take notes or ideas on how to solve the task

# 2022-12-16

I tried an approach and did not work, @sad

# 2022-12-22

With this amazing solution [introduce amazing solution here] it works!
```

Context, projects and key:value pairs are allowed in the text, and will be highlighted accordingly when showing the note.

## The notes' archive

When a done task is archived, the content of its note (if any) is appended to an archive file.
This archive can be viewed or edited with the `show` and `edit` operations.

The archive file is the only way to access an archived task's note.
The archive contains the note tag for each done task such that it can be navigated easily.

## Deleted tasks

When a task is deleted, its note (if any) are also also deleted.

## Installation

Copy the `note` `archive`, `del` and `rm` files in this directory to your add-ons folder.
Be aware that this add-on overrides the `archive`, `del` and `rm` commands.
If you already have overwritten some of them, you'll need to do some tweaking to combine both versions.

## Configuration

This add-on can be personalized in different ways to better suit your needs.
Take into account that changing some of this variables may render old notes unusable.
Of course, you can still recover them manually as they are not removed.
Thus, it is suggested to do this personalization before *starting to create notes*.

You can change the note file extension by adding an entry to your `todo.cfg` file.
The defaults are show below.

```
# Editor to use when editting notes
export $EDITOR
# Note file extension
export TODO_NOTE_EXT=.txt
# Directory where the notes will be stored
export TODO_NOTES_DIR=$TODO_DIR/notes
# Tag added to the tasks
export TODO_NOTE_TAG=note
# Shape to randomise the name of the tag (internally it uses mktemp)
export TODO_NOTE_TEMPLATE=XXX
```

## Contributing

There are unittest for the implementation, make sure that when modifying the add-on it still pass the tests.
Feel free to add more if required.

For running them the source code for [todo.txt-cli](https://github.com/todotxt/todo.txt-cli) is needed, as it contains the
testing library.
Then:
```
> ln -s /path/to/todo.txt-note/tests/t2320-note.sh /path/to/todo.txt-cli/tests/t2320-note.sh
> cd /path/to/todo.txt-cli/tests/
> ./t2320-note.sh
```

