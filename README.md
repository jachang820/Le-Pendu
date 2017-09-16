# Le-Pendu

Hangman game with a twist. <br />
This is a hobby project based off what I learned from BerkeleyX's CS169 MOOC. A Hangperson game was the first project in that course; however, this app was written from scratch using that as reference and inspiration. It runs off a Sinatra (Ruby) server, using RSpec and Simplecov gems for TDD testing. A good attempt was made to make the game more responsive and RESTful, to allow it to be played without Javascript and for smaller screens (like a mobile phone or tablet). Because of that, a lot of time was spent testing the Javascript, particularly AJAX so that guesses could be made without reloading the entire page (so that the background music wouldn't be interrupted). The music was composed on FLStudio, and trimmed in Audacity to make it more loopable.

## Built With

* [Sinatra](http://www.sinatrarb.com/documentation.html) - Simple server for creating web apps in Ruby
* [RSpec](http://rspec.info/documentation/) - Behavior driven TDD, best way to debug!
* [jQuery 3.2.1](http://api.jquery.com/) - Used to simplify JS and AJAX
* [FLStudio](https://www.image-line.com/flstudio/) - Used to compose the background music
* [Audacity](http://www.audacityteam.org/help/documentation/) - Used to trim music and make loops

## Todo

- [ ] Remove more JS dependencies. Particularly, try to allow audio without JS.
- [ ] Refactor JS and CSS scripts.
- [ ] Allow mobile users to draw their guesses instead of using ugly text box.

## Authors

* **Jonathan Chang** - *Initial work* - [jachang820](https://github.com/jachang820)

## Acknowledgments

### Backgrounds

**Title:** Le Pendu <br />
**Author:** Albert Besnard <br />
**Year:** 1873 <br />
**Website:** https://leprincelointain.blogspot.de/2016/07/albert-besnard-1849-1934-le-pendu-1873.html <br />
 <br />
**Title:** Girl with a Balloon <br />
**Author:** Banksy <br />
**Location:** South Bank of London <br />
 <br />
**Title:** Crows Abbey <br />
**Author:** Pierre Fabre <br />
**Studio:** GKaster/Bright Photon <br />
**Website:** http://bphoton.com/ <br />

### Icons

**Author:** Smashicons <br />
**License:** Creative Commons BY 3.0. <br />
**Website:** https://www.flaticon.com/authors/smashicons <br />
 <br />
### Effects
**Title:** Essential Retro Video Game Sound Effects Collection <br />
**Author:** Juhani Junkala <br />
**License:** Creative Commons CC0 <br />
**Email:** juhani.junkala@musician.org <br />
