-- Users
CREATE TABLE IF NOT EXISTS users (
	id INTEGER,
	reputation INTEGER,
	views INTEGER DEFAULT 0,
	down_votes INTEGER DEFAULT 0,
	up_votes INTEGER DEFAULT 0,
	display_name VARCHAR(255),
	location VARCHAR(512)
);

-- Posts
CREATE TABLE IF NOT EXISTS posts (
	id INTEGER,
	owner_user_id INTEGER,
	last_editor_user_id INTEGER,
	post_type_id SMALLINT,
	accepted_answer_id INTEGER,
	score INTEGER,
	parent_id INTEGER,
	view_count INTEGER,
	answer_count INTEGER DEFAULT 0,
	comment_count INTEGER DEFAULT 0,
	owner_display_name VARCHAR(64),
	last_editor_display_name VARCHAR(64),
	title VARCHAR(512),
	tags VARCHAR(512),
	favorite_count INTEGER,
	creation_date TIMESTAMP NULL DEFAULT NULL,
	community_owned_date TIMESTAMP NULL DEFAULT NULL,
	closed_date TIMESTAMP NULL DEFAULT NULL,
	last_edit_date TIMESTAMP NULL DEFAULT NULL,
	last_activity_date TIMESTAMP NULL DEFAULT NULL
);

-- PostLinks
CREATE TABLE IF NOT EXISTS post_links (
	related_post_id INTEGER,
	post_id INTEGER,
	link_type_id TINYINT,
	creation_date TIMESTAMP NULL DEFAULT NULL
);

-- PostHistory
CREATE TABLE IF NOT EXISTS post_history (
	post_id INTEGER,
	user_id INTEGER,
	post_history_type_id INTEGER,
	user_display_name VARCHAR(255),
	creation_date TIMESTAMP NULL DEFAULT NULL
);

-- Comments
CREATE TABLE IF NOT EXISTS comments (
	post_id INTEGER,
	user_id INTEGER,
	score TINYINT,
	user_display_name VARCHAR(64),
	text MEDIUMTEXT,
	creation_date TIMESTAMP NULL DEFAULT NULL
);

-- Votes
CREATE TABLE IF NOT EXISTS votes (
	user_id INTEGER,
	post_id INTEGER,
	vote_type_id TINYINT,
	bounty_amount TINYINT,
	creation_date TIMESTAMP NULL DEFAULT NULL
);

-- Badges
CREATE TABLE IF NOT EXISTS badges (
	user_id INTEGER,
	class TINYINT,
	name VARCHAR(64),
	date TIMESTAMP NULL DEFAULT NULL
);


