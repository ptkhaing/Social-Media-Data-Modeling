-- =====================
-- TABLE CREATION
-- =====================

CREATE TABLE AppUser (
  userID NUMBER PRIMARY KEY,
  name VARCHAR2(100),
  email VARCHAR2(100) UNIQUE,
  dateOfBirth DATE,
  joinDate DATE
);

CREATE TABLE RegularUser (
  userID NUMBER PRIMARY KEY,
  bio VARCHAR2(255),
  profilePicture VARCHAR2(255),
  lastLogin DATE,
  FOREIGN KEY (userID) REFERENCES AppUser(userID)
);

CREATE TABLE Admin (
  userID NUMBER PRIMARY KEY,
  role VARCHAR2(50),
  permissions VARCHAR2(255),
  lastActivity DATE,
  FOREIGN KEY (userID) REFERENCES AppUser(userID)
);

CREATE TABLE Post (
  postID NUMBER PRIMARY KEY,
  content CLOB,
  postDate DATE,
  userID NUMBER,
  FOREIGN KEY (userID) REFERENCES AppUser(userID)
);

CREATE TABLE PostComment (
  commentID NUMBER PRIMARY KEY,
  content VARCHAR2(500),
  commentDate DATE,
  userID NUMBER,
  postID NUMBER,
  FOREIGN KEY (userID) REFERENCES AppUser(userID),
  FOREIGN KEY (postID) REFERENCES Post(postID)
);

CREATE TABLE PostLike (
  likeID NUMBER PRIMARY KEY,
  likeDate DATE,
  userID NUMBER,
  postID NUMBER,
  FOREIGN KEY (userID) REFERENCES AppUser(userID),
  FOREIGN KEY (postID) REFERENCES Post(postID)
);

CREATE TABLE UserFollower (
  followerID NUMBER PRIMARY KEY,
  userID NUMBER,         -- The user being followed
  followsUserID NUMBER,  -- The user who follows
  FOREIGN KEY (userID) REFERENCES AppUser(userID),
  FOREIGN KEY (followsUserID) REFERENCES AppUser(userID)
);

-- =====================
-- DATA INSERTION
-- =====================

INSERT INTO AppUser VALUES (1, 'Alice Smith', 'alice.smith@gmail.com', TO_DATE('1995-04-12', 'YYYY-MM-DD'), TO_DATE('2023-01-01', 'YYYY-MM-DD'));
INSERT INTO AppUser VALUES (2, 'Bob Lee', 'bob.lee@outlook.com', TO_DATE('1990-06-24', 'YYYY-MM-DD'), TO_DATE('2023-02-10', 'YYYY-MM-DD'));
INSERT INTO AppUser VALUES (3, 'Charlie Admin', 'charlie.admin@gmail.com', TO_DATE('1985-01-01', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'));
INSERT INTO AppUser VALUES (4, 'Dana White', 'dana.white@outlook.com', TO_DATE('1992-09-18', 'YYYY-MM-DD'), TO_DATE('2023-04-05', 'YYYY-MM-DD'));
INSERT INTO AppUser VALUES (5, 'Ethan Ray', 'ethan.ray@gmail.com', TO_DATE('1998-11-30', 'YYYY-MM-DD'), TO_DATE('2023-05-20', 'YYYY-MM-DD'));

INSERT INTO RegularUser VALUES (1, 'Nature lover and coder.', 'alice.jpg', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO RegularUser VALUES (2, 'Tech enthusiast.', 'bob.jpg', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO RegularUser VALUES (4, 'Food blogger.', 'dana.jpg', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO RegularUser VALUES (5, 'Travel photographer.', 'ethan.jpg', TO_DATE('2024-03-05', 'YYYY-MM-DD'));

INSERT INTO Admin VALUES (3, 'Moderator', 'CREATE,DELETE,BAN', TO_DATE('2024-01-20', 'YYYY-MM-DD'));

INSERT INTO Post VALUES (1001, 'Hello world! This is my first post.', TO_DATE('2024-01-05', 'YYYY-MM-DD'), 1);
INSERT INTO Post VALUES (1002, 'Excited about the new tech conference!', TO_DATE('2024-01-07', 'YYYY-MM-DD'), 2);
INSERT INTO Post VALUES (1003, 'Check out my latest recipe!', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 4);
INSERT INTO Post VALUES (1004, 'Sunset at Bali was unreal.', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 5);
INSERT INTO Post VALUES (1005, 'Maintenance update completed.', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 3);

INSERT INTO PostComment VALUES (201, 'Nice post!', TO_DATE('2024-01-06', 'YYYY-MM-DD'), 2, 1001);
INSERT INTO PostComment VALUES (202, 'Love this!', TO_DATE('2024-02-16', 'YYYY-MM-DD'), 1, 1003);
INSERT INTO PostComment VALUES (203, 'Great view!', TO_DATE('2024-03-02', 'YYYY-MM-DD'), 4, 1004);
INSERT INTO PostComment VALUES (204, 'Thanks for the update.', TO_DATE('2024-01-26', 'YYYY-MM-DD'), 5, 1005);
INSERT INTO PostComment VALUES (205, 'I will attend too!', TO_DATE('2024-01-08', 'YYYY-MM-DD'), 4, 1002);

INSERT INTO PostLike VALUES (301, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 2, 1001);
INSERT INTO PostLike VALUES (302, TO_DATE('2024-01-08', 'YYYY-MM-DD'), 1, 1002);
INSERT INTO PostLike VALUES (303, TO_DATE('2024-02-16', 'YYYY-MM-DD'), 5, 1003);
INSERT INTO PostLike VALUES (304, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 2, 1004);
INSERT INTO PostLike VALUES (305, TO_DATE('2024-01-26', 'YYYY-MM-DD'), 4, 1005);

INSERT INTO UserFollower VALUES (401, 1, 2);  -- Bob follows Alice
INSERT INTO UserFollower VALUES (402, 2, 1);  -- Alice follows Bob
INSERT INTO UserFollower VALUES (403, 5, 4);  -- Ethan follows Dana
INSERT INTO UserFollower VALUES (404, 4, 5);  -- Dana follows Ethan
INSERT INTO UserFollower VALUES (405, 2, 3);  -- Bob follows Admin

-- =====================
-- UPDATE Data
-- =====================

UPDATE AppUser
SET email = 'bob.lee.new@gmail.com'
WHERE userID = 2;

-- =====================
-- COMMIT CHANGES
-- =====================

COMMIT;

-- =====================
-- VERIFY Inserted Data 
-- =====================

SELECT * FROM AppUser;
SELECT * FROM Post;
SELECT * FROM PostComment;
SELECT * FROM PostLike;
SELECT * FROM UserFollower;

-- Join: User + their posts
SELECT u.name, p.content
FROM AppUser u
JOIN Post p ON u.userID = p.userID;
SELECT 
  au.name AS commenterName,
  p.content AS postContent,
  pc.content AS commentContent,
  p.postDate
FROM 
  PostComment pc
  INNER JOIN AppUser au ON pc.userID = au.userID
  INNER JOIN Post p ON pc.postID = p.postID
WHERE 
  p.postDate > TO_DATE('2024-01-01', 'YYYY-MM-DD');
SELECT name
FROM AppUser
WHERE userID IN (
  SELECT DISTINCT userID FROM PostComment
  MINUS
  SELECT DISTINCT userID FROM PostLike
);
SELECT 
  au.name,
  a.role,
  a.lastActivity
FROM 
  AppUser au
  INNER JOIN Admin a ON au.userID = a.userID;
SELECT 
  name, email, joinDate
FROM 
  AppUser
WHERE 
  joinDate >= ADD_MONTHS(SYSDATE, -12);
SELECT 
  au.name,
  COUNT(DISTINCT p.postID) AS totalPosts,
  COUNT(pl.likeID) AS totalLikes
FROM 
  AppUser au
  LEFT JOIN Post p ON au.userID = p.userID
  LEFT JOIN PostLike pl ON p.postID = pl.postID
GROUP BY 
  ROLLUP (au.name);