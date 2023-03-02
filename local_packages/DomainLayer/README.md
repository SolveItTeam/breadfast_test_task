# DomainLayer

Implementation of a domain layer.
To see documetations for source code — build project `.docc` document

## Should contains
- Repositories protocols
- Enteties
- UseCase's implementation

## Structure
- Repositories
    - `PostsRepository` — provides an access to list of all available posts
    - `CommentsRepository` — provides an access to list of all comments for post
    - `UserRepository` — provides an access to user profile info by given ID
- Use cases
    - `GetAllPostsUseCase` — implements business requirement for load all available posts
    - `GetAllPostCommentsUseCase` — implements business requirement for load available comments for post
    

