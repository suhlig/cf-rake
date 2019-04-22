# Rake Tasks for the Cloud Foundry API

[![Build Status](https://travis-ci.org/suhlig/cf-rake.svg?branch=master)](https://travis-ci.org/suhlig/cf-rake)

Assumes that the user has already authenticated using the `cf` command.

## Org

As a developer deploying a Cloud Foundry app using `rake`, I want an organization to exist, so that `cf target -o ORG` succeeds:

```ruby
desc 'Organization exists'
organization 'some-org'

task target_org: 'some-org' do
  `cf target -o some-org`
end
```

## Domain

As a developer deploying a Cloud Foundry app using `rake`, I want a domain referenced by my app to exist, so that the push succeed.

```ruby
desc 'Domain exists'
domain 'example.com', 'some-org'

task domains: 'example.com' do
  puts 'Domains available for the current org:'
  puts `cf domains`
end
```

# Notes

Orgs, spaces, domains, etc. must all be unique, but you can name the task something unique and then override the task name within the block.

Example: Perhaps you have an org and a space that are both named `foo`. The task for space `foo` would have to list the org `foo` as a prerequisite, which would create an endless loop. Instead, just alias the organization task as `bar`, so that it becomes unique. Within the block, the actual name of the org is specified like this:

```ruby
organization 'bar' do |t|
  t.name = 'foo' # the real name
end

space foo: 'bar' # space foo depends on the (aliased) org
```

# TODO

* Check whether Ruby Tapas' [Episode #420: Rake Custom Task](https://www.rubytapas.com/2016/06/16/episode-420-rake-custom-task/) helps
* Space

  ```ruby
  desc 'Space exists'
  space 'dev' => 'some-org'

  task target_space: 'dev' do
    `cf target -o some-org -s dev`
  end
  ```
