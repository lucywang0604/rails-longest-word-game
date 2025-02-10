Rails.application.routes.draw do
    get "new", to: "games#new", as: 'new_game'
    post "score", to: "games#score"
end
