# README

**to setup the database...**

```rake db:create db:migrate db:seed```

**to run the server...**

```rails server```

**to see the possible routes...**

```rails routes```

**examples for a running server...**

_all movies & tv shows_

http://localhost:3000/watchables

_all episodes in a tv show_

http://localhost:3000/watchables/{id}/episodes
  
_all episodes in a tv show season_

http://localhost:3000/watchables/{id}/season/{number}
  
_a single tv show episode_

http://localhost:3000/watchables/{id}/season/{number}/episode/{number}
