Assumptions for the VOD Conceptual ERD
1.	Customer rentals
A customer can exist in the system without having rented a movie yet.
Each rental must always belong to exactly one customer and one movie.
A rental represents one movie at a time (not a bundle of movies).
2.	Wishlist
A customer can have zero or many wishlist items.
A movie can appear on many customer wishlists.
A wishlist item always belongs to exactly one customer and one movie.
3.	Movies and directors
Each movie has at least one director (mandatory).
A director can direct zero or many movies.
We assume co-directors are possible, so the bridge entity MovieDirector is used.
4.	Movies and actors
Each movie can have zero or many actors (optional for example ,documentaries with no actors).
An actor can appear in zero or many movies.
Each actor’s role in a movie is captured in MovieActor.
5.	Movies and categories
Each movie must belong to at least one category.
A category can have zero or many movies.
Categories are treated as independent (no parent/child hierarchy unless specified later).
6.	Movies and advisories
Movies can have zero or many advisories (for example  PG-13, Violence, Language).
Advisories can apply to zero or many movies.
7.	Identifiers
Every main entity (Customer, Movie, Actor, Director, Category, Advisory) has a unique identifier (e.g., CustomerID, MovieID).
Bridge entities use a composite key of the two related entities (e.g., MovieID + ActorID in MovieActor).
8.	Time and status handling
Rental dates and return status are assumed but not yet modeled in conceptual. They will be added in the logical model.
Same for subscription/payment information and its not included unless explicitly required.
