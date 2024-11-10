// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {
    struct Post {
        string message;
        address author;
        uint256 timestamp;
        uint256 modified;
        uint256 likes;
        uint256 dislikes;
    }

    Post[] public posts;
    mapping(address => uint256[]) public userPosts; // Mapping to track user posts

    event NewPost(uint256 postId, string message, address indexed author);
    event PostLiked(uint256 postId);
    event PostDisliked(uint256 postId);
    event PostEdited(uint256 postId, string newMessage);

    // Publish a new post
    function publishPost(string memory _message) public {
        uint256 postId = posts.length;
        posts.push(Post({
            message: _message,
            author: msg.sender,
            timestamp: block.timestamp,
            modified: 0,
            likes: 0,
            dislikes: 0
        }));
        userPosts[msg.sender].push(postId);
        emit NewPost(postId, _message, msg.sender);
    }

    // Like a post
    function likePost(uint256 _postId) public {
        require(_postId < posts.length, "Post does not exist.");
        posts[_postId].likes += 1;
        emit PostLiked(_postId);
    }

    // Dislike a post
    function dislikePost(uint256 _postId) public {
        require(_postId < posts.length, "Post does not exist.");
        posts[_postId].dislikes += 1;
        emit PostDisliked(_postId);
    }

    // Edit a post
    function editPost(uint256 _postId, string memory _newMessage) public {
        require(_postId < posts.length, "Post does not exist.");
        require(posts[_postId].author == msg.sender, "You can only edit your own posts.");
        
        posts[_postId].message = _newMessage;
        posts[_postId].modified = block.timestamp;
        emit PostEdited(_postId, _newMessage);
    }

    // Get the list of posts
    function getPosts() public view returns (Post[] memory) {
        return posts;
    }
}
