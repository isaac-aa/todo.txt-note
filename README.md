# Note add-on for todotxt

This add-on allows to keep notes attached to tasks. Just one note per task is allowed.

This is a fork of the unmaintained version [developed by Manuel J. Garrido](https://github.com/mgarrido/todo.txt-cli/tree/note/todo.actions.d).
The idea behind this repository is to improve and maintain this great note add-on for [todo.txt](https://todotxt.org).

## Adding, viewing and editing notes

* `note add|a ITEM#`. Adds a new note to task ITEM# and gives the chance to edit it.
* `note edit|e ITEM#`. Opens the note related with task ITEM# in editor.
* `note show|s ITEM#`. Shows the note related with task ITEM#.

## The notes' archive

When a done task is archived, the content of its note (if any) is appended to an archive file. This archive can be viewed or edited with the `show` and `edit` operations:

* `note edit|e archive|a`. Opens in editor the notes' archive.
* `note show|s archive|a`. Shows the notes' archive.

The archive file is the only way to acces an archived task's note.

## Deleted tasks

When a task is deleted, its note (if any) is also also deleted.

## Example of use

	$ todo.sh ls
	1 Cook cake for birthday party
	2 Fix bicycle
	--
	TODO: 2 of 2 tasks shown

Say you're collecting recipes to prepare the cake from task 1 and want to write a note with the links to that recipes:

	$ todo.sh note add 1
	1 Cook cake for birthday party note:cUn.txt
	TODO: Note added to task 1.
	Edit note?  (y/n)
	y

At this point, an editor is opened where you can enter any information related with task 1.

Later on, you may want to see the content of the note of task 1:

	$ todo.sh note show 1
	# Cook cake for birthday party

	A couple of cakes thar look great:
	* http://www.terrificfantasticcakes.com/sacher
	* http://www.evenbettercakes.com/tartadesanmarcos

Perhaps you want to edit the note to add something else, then `todo.sh note edit 1` would open again the editor.

## Installation

Copy the `archive`, `del` and `rm` files in this directory to your add-ons folder. Be aware that this add-on overrides the `archive`, `del` and `rm` commands. If you already have overriden some of them, you'll need to do some tweaking to combine both versions.

## Contributing

There are unittest for the implementation, make sure that when modifying the
add-on they still pass
Feel free to add more if required.

For running them the source code for [todo.txt-cli](https://github.com/todotxt/todo.txt-cli) is needed, as it contains the
testing library.
Then:
```
> ln -s /path/to/todo.txt-note/tests/t2320-note.sh /path/to/todo.txt-cli/tests/t2320-note.sh
> cd /path/to/todo.txt-cli/tests/
> ./t2320-note.sh
```

## Configuration

You can change the note file extension by adding an entry to your `todo.cfg` file:

```
# Note file extension
export TODO_NOTE_EXT=.md
```

