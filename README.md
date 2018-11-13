# README

## Setting up

- Clone repo with `git clone git@github.com:jvidalba1/files-organising.git`

- Go to folder `file-organising`

- Run `bundle install` to install all gems/libraries

- Run `rake db:create` to set all databases

- Run `rake db:migrate` to run database migrations

- Run `rails server` to start the server.


## Endpoints

> POST `/file`, params: { name: <string>, tags: <array of tags> }

![](https://image.ibb.co/n24aQL/Screen-Shot-2018-11-13-at-3-45-58-PM.png)

> GET `/files/:tag_search_query/:page`, params: { tag_search_query: <string>, page: <string> }

![](https://image.ibb.co/fOeH5L/Screen-Shot-2018-11-13-at-3-49-38-PM.png)
