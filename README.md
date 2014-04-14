create_collector
================

Creates a collector and applies overrides

First argument is the resource type, second the parameter/property you want to match, third its 
value and finally a hash of parameters/properties you want to override.

```
$overrides = { "uid" => "8888","groups" => ["wheel","audio"] }
create_collector('user', 'title', 'myusers', $overrides)
```

Known Issues:
- Can only generate a collector based on a single boolean
