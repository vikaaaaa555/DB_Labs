INSERT INTO role (id, role_type)
VALUES 
	(1, 'admin'),
	(2, 'archivist'),
	(3, 'user');

INSERT INTO users (id, login, password, role_id)
VALUES
	(1, 'beatrix_kiddo', '2k@Ye-GR_yDV3op%CAZM', 1),
	(2, 'violet_harmon', 'yfT22e-y--4mv7%8nKMJ', 2),
	(3, 'tate_langdon', 'p_gcb3NkY2_sUbvMPsb_', 2),
	(4, 'eiichiro_oda', 'cEYJ6ghBfYtpV-----ka', 2),
	(5, 'madison_montgomery', 'KGyWa-yC-5wM3U@@e7us', 3),
	(6, 'jade_mebarak', 'r2KjPLUnfDrp0XyRKrMZ', 3),
	(7, 'chanel_oberlin', 'wimLC%%ehr-FW_t84o8@', 3),
	(8, 'meryem_uzerli', 'jG_BeZ_b0P3951RFj8iH', 3),
	(9, 'matthew_smith', '%658q_1Js@@PZ_a-g3Jy', 3);

INSERT INTO profile (user_id, first_name, last_name, email, phone_number, birth_date)
VALUES
	(1, 'Beatrix', 'Kiddo', 'beatrix.kiddo@example.com', '+123456789', '1970-04-29'),
	(2, 'Violet', 'Harmon', 'violet.harmon@example.com', '+987654321', '1994-08-17'),
	(3, 'Tate', 'Langdon', 'tate.langdon@example.com', '+1112334455', '1987-01-20'),
	(4, 'Eiichiro', 'Oda', 'eiichiro.oda@example.com', '+9998776655', '1975-01-01'),
	(5, 'Madison', 'Montgomery', 'madison.montgomery@example.com', '+1122334455', '1991-02-10'),
	(6, 'Jade', 'Mebarak', 'jade.mebarak@example.com', '+9988776655', '1976-03-18'),
	(7, 'Chanel', 'Oberlin', 'chanel.oberlin@example.com', '+1222334455', '2000-02-20'),
	(8, 'Meryem', 'Uzerli', 'meryem.uzerli@example.com', '+9888776655', '1983-08-12'),
	(9, 'Matthew', 'Smith', 'matthew.smith@example.com', '+2122334455', '1982-10-28');

INSERT INTO action_type (id, name)
VALUES
	(1, 'Registration'),
	(2, 'Login'),
	(3, 'Logout'),
	(4, 'Create Document'),
	(5, 'Edit Document'),
    	(6, 'Delete Document');
	
INSERT INTO action (id, action_time, user_id, action_type_id)
VALUES
	(1, '2023-10-24 12:00:00', 1, 1),
	(2, '2023-10-24 12:15:00', 2, 1),
	(3, '2023-10-24 12:30:00', 3, 1),
	(4, '2023-10-24 12:45:00', 4, 1),
	(5, '2023-10-24 13:00:00', 5, 1),
	(6, '2023-10-24 13:15:00', 6, 1),
	(7, '2023-10-24 13:30:00', 7, 1),
	(8, '2023-10-24 13:45:00', 8, 1),
	(9, '2023-10-24 14:00:00', 9, 1), 
	
	(10, '2023-10-25 08:00:00', 1, 2),
	(11, '2023-10-25 08:15:00', 2, 2),
	(12, '2023-10-25 08:30:00', 3, 2),
	(13, '2023-10-25 08:45:00', 4, 2),
	(14, '2023-10-25 09:00:00', 5, 2),
	(15, '2023-10-25 09:15:00', 6, 2),
	(16, '2023-10-25 09:30:00', 7, 2),
	(17, '2023-10-25 09:45:00', 8, 2),
	(18, '2023-10-25 10:00:00', 9, 2),

	(19, '2023-10-26 17:00:00', 1, 3),
	(20, '2023-10-26 17:15:00', 2, 3),
	(21, '2023-10-26 17:30:00', 3, 3),
	(22, '2023-10-26 17:45:00', 4, 3);
	
INSERT INTO doc_type (id, name)
VALUES 
    (1, 'Biography'),
    (2, 'Military history'),
    (3, 'Cultural history'),
	(4, 'Political history'),
    (5, 'Legal document');
	
INSERT INTO document (id, title, description, last_change_time, doc_type_id, author_id)
VALUES 
    (1, 'Marie Curie Biography','Marie Curie, born on November 7, 1867, in Warsaw, Poland, was a pioneering physicist and chemist. She is best known for her groundbreaking research on radioactivity, which earned her two Nobel Prizes. Marie Curie, along with her husband Pierre Curie, discovered the elements polonium and radium, contributing significantly to the understanding of atomic structure. Her tireless work and dedication to science have left an enduring legacy.', '2023-09-24 14:30:00', 1, 1),
    (2, 'Vytautas Biography', 'Vytautas the Great, born on October 1350 in Trakai, Grand Duchy of Lithuania, was a prominent ruler and military leader. He played a key role in the defense of the Grand Duchy against various threats, including the Teutonic Order and the Golden Horde. Vytautas was known for his military successes, including the Battle of Grunwald in 1410. Additionally, he pursued diplomatic efforts to strengthen the Grand Duchy position in Eastern Europe. Vytautas died on October 27, 1430, leaving a lasting legacy as one of the most significant leaders in Lithuanian history.', '2023-10-20 15:00:00', 1, 1),
	(3, 'Atomic Bombings of Hiroshima and Nagasaki', 'The atomic bombings of Hiroshima and Nagasaki were pivotal events during World War II. On August 6, 1945, the United States dropped an atomic bomb on Hiroshima, followed by another on Nagasaki on August 9. The bombings resulted in Japan unconditional surrender and the end of the war. The devastating impact of the bombs led to widespread destruction, immediate deaths, and long-term health effects due to radiation exposure. The bombings raised ethical and moral questions about the use of nuclear weapons.', '2023-10-24 15:30:00', 2, 3),
    (4, 'Grunwald Battle', 'The Battle of Grunwald, fought on July 15, 1410, was one of the largest medieval battles in Europe. It took place between the Kingdom of Poland and the Grand Duchy of Lithuania, facing the Teutonic Order. The battle marked a turning point in the Northern Crusades and resulted in a decisive victory for the Polish-Lithuanian forces. The aftermath of the battle had significant geopolitical consequences, reshaping the balance of power in Eastern Europe. The Battle of Grunwald is remembered as a symbol of courage and cooperation between Poland and Lithuania.', '2023-03-18 16:00:00', 2, 2),
    (5, 'Silver Age of Russian Poetry', 'The Silver Age of Russian Poetry refers to the period in Russian literature from the late 19th to the early 20th century. It was characterized by a flourishing of artistic and intellectual activity, with poets experimenting with new forms and themes. The period witnessed the emergence of iconic poets like Alexander Blok, Anna Akhmatova, and Sergei Yesenin. The Silver Age reflected a complex interplay of cultural, social, and political factors, and its legacy continues to influence Russian literature and culture.', '2020-07-02 16:30:00', 3, 2),
    (6, 'Influence of Impressionism on Art', 'Impressionism was an art movement that emerged in the 19th century, characterized by its emphasis on capturing the fleeting effects of light and color in the natural world. The movement had a profound impact on the art world, influencing not only painting but also literature and music. Impressionism challenged traditional artistic conventions and paved the way for modern art movements. The most famous impressionist artists are Claude Monet and Vincent van Gogh.', '2021-01-08 17:00:00', 3, 2),
    (7, 'Tokugawa Shogunate Establishment', 'The Tokugawa Shogunate, also known as the Edo Shogunate, was established in Japan in the early 17th century. This marked a period of relative peace and stability, known as the Edo period, which lasted for more than two centuries. The establishment of the Tokugawa Shogunate had a profound impact on Japanese society, politics, and culture. This document provides a detailed description of the events leading to the establishment of the Tokugawa Shogunate and its consequences.', '2019-02-28 17:30:00', 4, 3),
    (8, 'French Revolution', 'The French Revolution was a period of radical social and political upheaval in France that lasted from 1789 to 1799. It marked the end of monarchy, the rise of democracy, and the establishment of the First French Republic. This document provides an overview of the key events, causes, and consequences of the French Revolution, including the storming of the Bastille, the Reign of Terror, and the rise of Napoleon Bonaparte.', '2022-04-14 18:00:00', 4, 1),
    (9, 'Statute of GDL (1588)', 'The Statute of the Grand Duchy of Lithuania (GDL) from 1588 was a landmark legal document shaping the legal and administrative framework. Enacted during Stephen Báthory reign, it addressed governance, judicial procedures, and societal norms. The Statute aimed to balance the interests of nobility, clergy, and commoners, reflecting the Duchy multicultural nature. This document includes the complete text, offering insight into the late 16th-century legal intricacies and societal norms.', '2023-05-19 18:30:00', 5, 1),
    (10, 'United States Declaration of Independence', 'The United States Declaration of Independence, adopted on July 4, 1776, marks a pivotal moment in history. Penned by Thomas Jefferson, the document articulates the colonies resolve to break free from British rule. It eloquently asserts inalienable rights and justifies the decision to declare independence. This text is a crucial foundation for understanding the principles that shaped the United States.', '2022-11-11 19:00:00', 5, 1);

INSERT INTO state_system (id, system_type, description)
VALUES
	(1, 'Monarchy', 'A form of government in which a single person, the monarch, rules as head of state for life or until abdication, and the position is inherited by a close relative, usually a child.'),
	(2, 'Republic', 'A form of government in which the country is considered a "public matter" and the head of state is an elected or appointed official, not a hereditary monarch.');
	
	
INSERT INTO countrie (id, name, capital, state_system_id)
VALUES
	(1, 'France', 'Paris', 2),
	(2, 'The Grand Duchy of Lithuania', 'Vilnius', 1),
	(3, 'Empire of Japan', 'Tokyo', 1),
	(4, 'The Russian Empire', 'Saint Petersburg', 1),
	(5, 'The Kingdom of the Netherlands', 'Amsterdam', 1),
	(6, 'Tokugawa shogunate', 'Edo', 1),
	(7, 'The United States of America', 'Washington', 2);

INSERT INTO historical_figure (id, first_name, last_name, birth_date, death_date)
VALUES
	(1, 'Marie', 'Curie', '1867-11-07', '1934-07-04'),
	(2, 'Vytautas', 'Keystutovich', '1350-01-01', '1430-10-27'),
	(3, 'Hirohito', NULL, '1901-04-29', '1989-01-07'),
	(4, 'Jogaila', NULL, '1352-01-01', '1434-06-01'),
	(5, 'Alexander', 'Blok', '1880-11-28', '1921-08-07'),
	(6, 'Anna', 'Akhmatova', '1889-06-23', '1966-03-05'),
	(7, 'Sergei', 'Yesenin', '1895-10-03', '1925-12-28'),
	(8, 'Claude', 'Monet', '1840-11-14', '1926-12-05'),
	(9, 'Vincent', 'van Gogh', '1853-03-30', '1890-07-29'),
	(10, 'Ieyasu', 'Tokugawa', '1543-01-31', '1616-06-01'),
	(11, 'Marie', 'Antoinette', '1755-11-02', '1793-10-16'),
	(12, 'Sigismund', 'Vasa', '1566-06-20', '1632-04-30'),
	(13, 'Thomas', 'Jefferson', '1743-04-13', '1826-07-04');
	
INSERT INTO figure_countrie_doc_linc (historical_figure_id, countrie_id, document_id)
VALUES
	(1, 1, 1),
	(2, 2, 2),
	(3, 3, 3),
	(4, 2, 4),
	(5, 4, 5),
	(6, 4, 5),
	(7, 4, 5),
	(8, 5, 6),
	(9, 5, 6),
	(10, 6, 7),
	(11, 1, 8),
	(12, 2, 9),
	(13, 7, 10);

INSERT INTO collection (id, name, description)
VALUES
	(1, 'History of The Grand Duchy of Lithuania', 'Documents covering key moments in the history of the GDL.'),
    (2, 'History of Japan', 'Collection of documents narrating the history of Japan.'),
    (3, 'Women in History', 'Documents dedicated to prominent women in history.'),
    (4, 'Literature and Art', 'Collection of documents about art and literature.'),
    (5, 'History of France', 'Documents covering key moments in the history of France.'),
    (6, 'Essential Documents in History', 'Compilation of important historical documents.');

INSERT INTO collection_doc_link (collection_id, document_id)
VALUES
	(1, 2), (1, 4), (1, 9), (2, 3), (2, 7), (3, 1), (4, 5), (4, 6), (5, 1), (5, 8), (6, 9), (6, 10);
	
INSERT INTO user_collection_link (user_id, collection_id, is_subscribe)
SELECT u.id AS user_id, c.id AS collection_id, RANDOM() > 0.5
FROM users u
CROSS JOIN collection c;
