
class Post {
    String id;
    String name;
    String location;
    String openingTime;
    String closingTime;
    String categoryId;
    String description;
    String imageUrl;
    Category category;

    Post({
        required this.id,
        required this.name,
        required this.location,
        required this.openingTime,
        required this.closingTime,
        required this.categoryId,
        required this.description,
        required this.imageUrl,
        required this.category,
    });

}

class Category {
    String id;
    String name;

    Category({
        required this.id,
        required this.name,
    });

}
