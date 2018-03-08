### Packing Checklist

A quick and easy way to export from Quiver to Wunderlist

### Installation
```
bundle
```

### Usage

```
WL_ACCESS_TOKEN=your_key WL_CLIENT_ID=your_id ruby app/run.rb
```
Will output your quiver Packing Checklist list to your Wunderlist Packing list.

#### Options
```
LIST_NAME - Name of the list in Wunderlist
CHECKLIST_NAME - Name of the checklist note in Quiver
NOTEBOOK_DIR - The directory, including filename, of your .qvlibrary root quiver folder
ITEM_PREFIX - The markdown or text used to delimit a checklist item
```

### Test
```
rspec
```
