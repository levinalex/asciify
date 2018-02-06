# Asciify
strip non-ASCII characters from a string and replace them with something else

Monkeypatches an `asciify` method onto the string class

```ruby
'Mötorhead © Copyright'.asciify # => "Moetorhead (c) Copyright"
```
# Installation
```
  gem 'asciify'
```

# Important Note
Default behaviour is to just replace all non-ascii with "?". However, there is a handy [default mapping]() you can use which covers some of the most common non-ascii characters.
To make use of it run the following at app startup:

```ruby
Asciify.mapping_config = :default
# or
# Asciify.mapping_config = [:default, '_MISSING_'] # if you want to put something else instead of '?' when mapping is not present
```

If this doesn't cover your needs you can make a mapping YAML file in a format like this
```yaml
---
"Ä": "Ae"
"Ö": "Oe"
```

...then your config will be
```ruby
Asciify.mapping_config = 'my/yaml/file/path.yaml'
```