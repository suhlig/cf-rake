# Rake Tasks for the Cloud Foundry API

## Domain

As a developer deploying a Cloud Foundry app using `rake`, I want a domain referenced by my app to be created for me, so that the push succeeds without errors:

```ruby
desc 'Create the domain'
domain 'example.com', 'some-org'

task :deploy => ['example.com'] do
  # cf push ...
end
```

## Space

```ruby
desc 'Create the space'
space 'dev' => 'some-org'

task :deploy => ['dev'] do
  puts "cf push ..."
end
```
