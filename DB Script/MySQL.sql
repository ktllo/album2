CREATE TABLE GROUPS(
	GROUP_ID VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	CONSTRAINT PRIMARY KEY(GROUP_ID)
);
CREATE TABLE USERS(
	USER_ID VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	PASSWORD TEXT COLLATE LATIN1_BIN NOT NULL,
	MAIN_GROUP VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	CONSTRAINT PRIMARY KEY(USER_ID),
	CONSTRAINT FOREIGN KEY(MAIN_GROUP) REFERENCES GROUPS(GROUP_ID)
);
CREATE TABLE USER_GROUP(
	GROUP_ID VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	USER_ID VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	CONSTRAINT PRIMARY KEY(USER_ID,GROUP_ID),
	CONSTRAINT FOREIGN KEY(GROUP_ID) REFERENCES GROUPS(GROUP_ID),
	CONSTRAINT FOREIGN KEY(USER_ID) REFERENCES USERS(USER_ID)
);
CREATE TABLE PHOTO(
	PHOTO_ID VARCHAR(38) COLLATE LATIN1_BIN NOT NULL COMMENT 'SHA224 in base64 without padding',
	TITLE VARCHAR(500) COLLATE UTF8_BIN,
	PATH TEXT COLLATE UTF8_BIN NOT NULL,
	OWNER VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	FILE_SIZE INT UNSIGNED NOT NULL,
	PHOTO_LENGTH INT UNSIGNED NOT NULL,
	PHOTO_HEIGHT INT UNSIGNED NOT NULL,
	DESCRIPTION TEXT COLLATE UTF8_BIN,
	CONSTRAINT PRIMARY KEY(PHOTO_ID),
	CONSTRAINT FOREIGN KEY(OWNER) REFERENCES USERS(USER_ID)
);
CREATE TABLE THUMBNAIL(
	THUMBNAIL_ID VARCHAR(64) NOT NULL COMMENT 'SHA384 in base64',
	PHOTO_ID VARCHAR(38) COLLATE LATIN1_BIN NOT NULL,
	PATH TEXT COLLATE UTF8_BIN NOT NULL,
	FILE_SIZE INT UNSIGNED NOT NULL,
	PHOTO_LENGTH INT UNSIGNED NOT NULL,
	PHOTO_HEIGHT INT UNSIGNED NOT NULL,
	CONSTRAINT PRIMARY KEY(THUMBNAIL_ID),
	CONSTRAINT UNIQUE INDEX (PHOTO_ID, PHOTO_LENGTH),
	CONSTRAINT FOREIGN KEY (PHOTO_ID) REFERENCES PHOTO(PHOTO_ID)
);
CREATE TABLE ALBUM(
	ALBUM_ID VARCHAR(32) COLLATE latin1_general_ci NOT NULL,
	ALBUM_NAME VARCHAR(500) COLLATE utf8_bin NOT NULL,
	OWNER VARCHAR(32) COLLATE LATIN1_GENERAL_CI NOT NULL,
	MAIN_PICTURE VARCHAR(38) COLLATE LATIN1_BIN,
	DESCRIPTION TEXT COLLATE utf8mb4_general_ci,
	ALBUM_URL VARCHAR(700) COLLATE latin1_general_ci NOT NULL,
	CONSTRAINT PRIMARY KEY(ALBUM_ID),
	CONSTRAINT UNIQUE INDEX (ALBUM_URL),
	CONSTRAINT FOREIGN KEY(OWNER) REFERENCES USERS(USER_ID),
	CONSTRAINT FOREIGN KEY(MAIN_PICTURE) REFERENCES PHOTO(PHOTO_ID)
);
CREATE TABLE ALBUM_PHOTO(
	ALBUM_ID VARCHAR(32) COLLATE latin1_general_ci NOT NULL,
	SEQ_NO INT UNSIGNED NOT NULL,
	PHOTO_ID VARCHAR(38) COLLATE LATIN1_BIN NOT NULL,
	CONSTRAINT PRIMARY KEY(ALBUM_ID, SEQ_NO),
	CONSTRAINT FOREIGN KEY(ALBUM_ID) REFERENCES ALBUM(ALBUM_ID),
	CONSTRAINT FOREIGN KEY(PHOTO_ID) REFERENCES PHOTO(PHOTO_ID)
);
CREATE TABLE EXIF(
	EXIF_KEY VARCHAR(255) COLLATE LATIN1_GENERAL_CI NOT NULL,
	DATA_TYPE VARCHAR(255) COLLATE LATIN1_GENERAL_CI NOT NULL,
	FIELD_NAME VARCHAR(255) COLLATE UTF8_BIN,
	CONSTRAINT PRIMARY KEY(EXIF_KEY)
);
CREATE TABLE PHOTO_EXIF(
	PHOTO_ID VARCHAR(38) COLLATE LATIN1_BIN NOT NULL,
	EXIF_KEY VARCHAR(255) COLLATE LATIN1_GENERAL_CI NOT NULL,
	EXIF_VALUE TEXT COLLATE UTF8_BIN,
	CONSTRAINT PRIMARY KEY(PHOTO_ID, EXIF_KEY),
	CONSTRAINT FOREIGN KEY(PHOTO_ID) REFERENCES PHOTO(PHOTO_ID),
	CONSTRAINT FOREIGN KEY(EXIF_KEY) REFERENCES EXIF(EXIF_KEY)
);
CREATE TABLE ALBUM_PROPERTIES(
	ALBUM_ID VARCHAR(32) COLLATE latin1_general_ci NOT NULL,
	PROP_NAME VARCHAR(255) COLLATE LATIN1_GENERAL_CI NOT NULL,
	PROP_VALUE TEXT NOT NULL,
	CONSTRAINT PRIMARY KEY (ALBUM_ID, PROP_NAME),
	CONSTRAINT FOREIGN KEY (ALBUM_ID) REFERENCES ALBUM(ALBUM_ID)
);
CREATE TABLE PHOTO_PROPERTIES(
	PHOTO_ID VARCHAR(38) COLLATE LATIN1_BIN NOT NULL,
	PROP_NAME VARCHAR(255) COLLATE LATIN1_GENERAL_CI NOT NULL,
	PROP_VALUE TEXT NOT NULL,
	CONSTRAINT PRIMARY KEY (PHOTO_ID, PROP_NAME),
	CONSTRAINT FOREIGN KEY(PHOTO_ID) REFERENCES PHOTO(PHOTO_ID)	
);

