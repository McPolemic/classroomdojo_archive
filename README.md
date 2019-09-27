# Classdojo Archive

## Usage

To update a given archive:

```
$ bundle exec ruby update.rb
```

You may have to update the cookie used to interface with ClassDojo if it hasn't been run in awhile. To do so, log in to http://www.classdojo.com and pull the request from Chrome Dev Tools as a curl request. Pull the cookie out and put it in update.rb.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/classdojo_archive. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ClassdojoArchive project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/classdojo_archive/blob/master/CODE_OF_CONDUCT.md).
