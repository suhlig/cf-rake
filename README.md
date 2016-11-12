# Rake Tasks for the Cloud Foundry API

When deploying Cloud Foundry apps with `rake`, I want to ensure that a domain my app references actually exists in cf:

```ruby
desc 'Create the domain'
domain 'example.com', 'some-org'

task :deploy => ['example.com'] do
  # cf push ...
end
```
