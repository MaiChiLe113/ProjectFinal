-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Nov 28, 2025 at 04:39 AM
-- Server version: 8.0.40
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `swincom`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_competition_details` (IN `comp_id` INT)   BEGIN
    SELECT * FROM v_competitions_full WHERE id = comp_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_project_details` (IN `proj_id` INT)   BEGIN
    -- Main project data
    SELECT * FROM v_projects_full WHERE id = proj_id;

    -- Project links
    SELECT * FROM project_links WHERE project_id = proj_id ORDER BY display_order;

    -- Project images
    SELECT * FROM project_images WHERE project_id = proj_id ORDER BY display_order;

    -- Team members
    SELECT * FROM team_members WHERE project_id = proj_id ORDER BY display_order;

    -- Comments
    SELECT * FROM project_comments WHERE project_id = proj_id ORDER BY timestamp DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_join_competition` (IN `comp_id` INT, IN `usr_id` INT)   BEGIN
    DECLARE already_joined INT;
    DECLARE comp_open BOOLEAN;

    -- Check if already joined
    SELECT COUNT(*) INTO already_joined
    FROM competition_participants
    WHERE competition_id = comp_id AND user_id = usr_id;

    -- Check if registration is open
    SELECT registration_is_open INTO comp_open
    FROM competitions
    WHERE id = comp_id;

    IF already_joined > 0 THEN
        SELECT 'error' as status, 'Already joined this competition' as message;
    ELSEIF comp_open = FALSE THEN
        SELECT 'error' as status, 'Registration is closed' as message;
    ELSE
        INSERT INTO competition_participants (competition_id, user_id)
        VALUES (comp_id, usr_id);

        UPDATE competitions
        SET current_capacity = current_capacity + 1
        WHERE id = comp_id;

        SELECT 'success' as status, 'Successfully joined competition' as message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_vote_project` (IN `proj_id` INT, IN `usr_id` INT)   BEGIN
    DECLARE vote_exists INT;

    -- Check if user already voted
    SELECT COUNT(*) INTO vote_exists
    FROM project_votes
    WHERE project_id = proj_id AND user_id = usr_id;

    IF vote_exists = 0 THEN
        INSERT INTO project_votes (project_id, user_id) VALUES (proj_id, usr_id);
        UPDATE projects SET votes = votes + 1 WHERE id = proj_id;
        SELECT 'success' as status, 'Vote recorded' as message;
    ELSE
        SELECT 'error' as status, 'Already voted' as message;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `competitions`
--

CREATE TABLE `competitions` (
  `id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `organizer_id` int NOT NULL,
  `organizer_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `organizer_email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `organizer_type` enum('staff','faculty','individual','clubs') COLLATE utf8mb4_general_ci NOT NULL,
  `created_date` date NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `registration_deadline` date NOT NULL,
  `participants` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `max_capacity` int NOT NULL DEFAULT '1000',
  `current_capacity` int NOT NULL DEFAULT '0',
  `waitlist` int NOT NULL DEFAULT '0',
  `status` enum('upcoming','ongoing','completed','cancelled') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'upcoming',
  `registration_is_open` tinyint(1) NOT NULL DEFAULT '1',
  `requires_approval` tinyint(1) NOT NULL DEFAULT '0',
  `allow_teams` tinyint(1) NOT NULL DEFAULT '0',
  `team_size` int DEFAULT NULL,
  `location_type` enum('online','onsite','hybrid','offline') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'online',
  `venue` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location_link` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prizes` text COLLATE utf8mb4_general_ci,
  `rules` text COLLATE utf8mb4_general_ci,
  `contact_email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `banner_image` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `views` int NOT NULL DEFAULT '0',
  `votes` int NOT NULL DEFAULT '0',
  `registrations` int NOT NULL DEFAULT '0',
  `completion_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `title`, `description`, `category`, `organizer_id`, `organizer_name`, `organizer_email`, `organizer_type`, `created_date`, `start_date`, `end_date`, `registration_deadline`, `participants`, `max_capacity`, `current_capacity`, `waitlist`, `status`, `registration_is_open`, `requires_approval`, `allow_teams`, `team_size`, `location_type`, `venue`, `location_link`, `prizes`, `rules`, `contact_email`, `banner_image`, `views`, `votes`, `registrations`, `completion_rate`, `created_at`, `updated_at`) VALUES
(1, 'Swin - Hackathon 2026', 'Brings people and AI solutions together to build a better world.', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-10-01', '2026-01-30', '2026-04-30', '2025-12-10', 'All campuses', 10000, 450, 0, 'upcoming', 1, 0, 1, 3, 'online', 'Online Platform', 'https://contest.example.com', '1st Prize: $1000, 2nd Prize: $500, 3rd Prize: $250', 'Follow the official rules and regulations. No plagiarism. All submissions must be original work.', 'coding@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 234, 89, 45, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(2, 'Performative Male', 'Who gonna be best performative S-Winners', 'Community', 20, 'Unknown Penguin', 'meo@gmail.com', 'individual', '2025-10-01', '2025-11-29', '2025-11-30', '2025-12-10', 'Hanoi campus', 10000, 450, 0, 'upcoming', 1, 0, 1, 3, 'offline', '02 Duong Khue, Hanoi', 'https://contest.example.com', '50 GOLD, 200k voucher Highlands Coffee', 'Wear best.', 'meo@gmail.com', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 90, 89, 15, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(3, 'MisChef', 'Chefchoice competition for the best dishes', 'Events', 10, 'Swinburne ChefChoice Club', 'chefchoice@swinburne.edu.vn', 'clubs', '2025-10-01', '2025-11-29', '2025-11-30', '2025-12-10', 'Invitation only', 20, 20, 0, 'upcoming', 1, 0, 1, 3, 'offline', '02 Duong Khue, Hanoi', 'https://contest.example.com', '50 GOLD, 200k voucher Highlands Coffee', 'Wear best.', 'meo@gmail.com', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 90, 89, 15, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(4, 'AI Innovation Challenge', 'Create innovative AI solutions for real-world problems', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-09-15', '2025-12-01', '2025-12-15', '2025-11-20', 'All campuses', 500, 234, 12, 'upcoming', 1, 1, 1, 4, 'hybrid', 'Swinburne Innovation Hub', 'https://ai-challenge.swinburne.edu', '1st: $2000 + AWS Credits, 2nd: $1000, 3rd: $500 + Certificates', 'Must use ethical AI practices. Open-source solutions preferred. Team size 2-4 members.', 'ai@swinburne.edu.au', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 567, 145, 234, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(5, 'SwinBiz Rockstar', 'Pitch your startup idea to win funding and mentorship', 'Business', 2, 'Business Faculty', 'business@swinburne.edu.au', 'staff', '2025-10-05', '2025-12-10', '2025-12-12', '2025-11-30', 'Hanoi campus', 100, 78, 5, 'upcoming', 1, 0, 1, 5, 'offline', 'Swinburne Auditorium, Hanoi', '', '$5000 seed funding, Business mentorship, 100 GOLD', 'Original business ideas only. 5-minute pitch presentation. Q&A session included.', 'bizcomp@swinburne.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 456, 201, 78, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(6, 'Digital Media Showcase', 'Showcase your creative digital media projects', 'Media', 3, 'Media & Communication Faculty', 'media@swinburne.edu.au', 'staff', '2025-09-20', '2025-11-25', '2025-11-27', '2025-11-15', 'All campuses', 200, 156, 8, 'upcoming', 1, 0, 1, 3, 'online', 'Virtual Gallery', 'https://media.swinburne.edu/showcase', 'Best Overall: $800, Category Winners: $300 each, Adobe Creative Suite licenses', 'Original content only. Multiple categories available. Submit in standard formats.', 'mediashowcase@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 389, 167, 156, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(7, 'Code Sprint 2025', '48-hour coding marathon to solve algorithmic challenges', 'Technology', 4, 'Coding Club', 'codingclub@swinburne.edu.vn', 'clubs', '2025-10-10', '2025-12-05', '2025-12-07', '2025-11-28', 'HCMC campus', 150, 89, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Tech Lab, HCMC Campus', '', '1st: 150 GOLD + Mechanical Keyboard, 2nd: 100 GOLD, 3rd: 50 GOLD', 'Individual competition. Any programming language allowed. No external help.', 'codingclub@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 234, 98, 89, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(8, 'Photography Walk', 'Capture the essence of your campus through photography', 'Community', 21, 'Sarah Nguyen', 'sarah.nguyen@student.swin.edu.vn', 'individual', '2025-10-12', '2025-11-30', '2025-11-30', '2025-11-25', 'Hanoi campus', 50, 34, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Swinburne Hanoi Campus', '', 'Best Photo: 500k VND voucher, Runner-up: 300k VND voucher, Certificates', 'DSLR or smartphone photography allowed. Edit photos with credit. No stock images.', 'sarah.nguyen@student.swin.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 145, 67, 34, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(9, 'Debate Championship', 'Annual inter-campus debate competition on contemporary issues', 'Events', 5, 'Debate Society', 'debate@swinburne.edu.vn', 'clubs', '2025-09-25', '2025-12-14', '2025-12-15', '2025-12-01', 'All campuses', 80, 56, 3, 'upcoming', 1, 0, 1, 3, 'hybrid', 'Main Auditorium, Hanoi + Online', 'https://debate.swinburne.edu', 'Winning Team: 200 GOLD each + Trophy, Best Speaker: 100 GOLD + Certificate', 'British Parliamentary format. 3 members per team. Professional judging panel.', 'debate@swinburne.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 278, 123, 56, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(10, 'Mobile App Development Contest', 'Build the next breakthrough mobile application', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-10-01', '2026-01-15', '2026-03-15', '2025-12-31', 'All campuses', 300, 167, 0, 'upcoming', 1, 0, 1, 4, 'online', 'Online Submission Platform', 'https://mobiledev.swinburne.edu', '$3000 + App Store Developer License, 2nd: $1500, 3rd: $750', 'iOS or Android. Original apps only. Must include documentation and demo video.', 'mobiledev@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 523, 234, 167, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(11, 'Marketing Case Competition', 'Solve real marketing challenges from industry partners', 'Business', 2, 'Business Faculty', 'business@swinburne.edu.au', 'staff', '2025-09-28', '2025-12-08', '2025-12-09', '2025-11-22', 'Hawthorne campus', 60, 45, 2, 'upcoming', 1, 1, 1, 4, 'offline', 'Business Building, Hawthorne', '', '1st: $2000 + Internship Opportunity, 2nd: $1000, 3rd: $500', 'Teams of 4. Real client cases. 24-hour preparation time. Professional presentation required.', 'marketingcomp@swinburne.edu.au', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 312, 145, 45, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(12, 'Short Film Festival', 'Create and showcase your short film masterpiece', 'Media', 6, 'Film Club', 'filmclub@swinburne.edu.vn', 'clubs', '2025-10-03', '2026-02-01', '2026-02-03', '2026-01-15', 'All campuses', 100, 67, 4, 'upcoming', 1, 0, 1, 6, 'hybrid', 'Campus Theater + Online Streaming', 'https://film.swinburne.edu', 'Best Film: $1200 + Film Equipment, Best Director: 150 GOLD, Audience Choice: 100 GOLD', 'Maximum 15 minutes. Any genre. Original content only. Credits required.', 'filmclub@swinburne.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 445, 198, 67, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(13, 'Data Science Challenge', 'Analyze datasets and extract meaningful insights', 'Technology', 7, 'Data Science Society', 'datascience@swinburne.edu.vn', 'clubs', '2025-09-30', '2025-12-16', '2025-12-18', '2025-12-05', 'All campuses', 200, 143, 7, 'upcoming', 1, 0, 1, 3, 'online', 'Kaggle Platform', 'https://kaggle.com/swinburne-challenge', '1st: 250 GOLD + Cloud Credits, 2nd: 150 GOLD, 3rd: 75 GOLD + Certificates', 'Use provided datasets. Python/R preferred. Submit Jupyter notebooks. Code review required.', 'datascience@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 398, 176, 143, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(14, 'Talent Show Extravaganza', 'Show off your unique talents and skills', 'Community', 22, 'Michael Tran', 'michael.tran@student.swin.edu.vn', 'individual', '2025-10-08', '2025-12-20', '2025-12-20', '2025-12-10', 'HCMC campus', 40, 28, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Student Center, HCMC', '', 'Winner: 1M VND voucher Shopee, 2nd: 500k VND, 3rd: 300k VND + Certificates', '5-minute performance. Any talent welcome. Clean content only. Backup music on USB.', 'michael.tran@student.swin.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 189, 89, 28, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(15, 'Sustainability Innovation Lab', 'Design sustainable solutions for environmental challenges', 'Events', 8, 'Green Campus Initiative', 'green@swinburne.edu.vn', 'clubs', '2025-10-05', '2026-01-10', '2026-01-12', '2025-12-20', 'All campuses', 120, 87, 5, 'upcoming', 1, 0, 1, 4, 'hybrid', 'Innovation Hub + Virtual', 'https://sustainability.swinburne.edu', '1st: $1500 + Project Implementation Support, 2nd: $800, 3rd: $400', 'Focus on sustainability. Feasible solutions. Prototype preferred. Impact assessment required.', 'green@swinburne.edu.vn', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 267, 134, 87, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(16, 'Esports Championship', 'Compete in League of Legends, Valorant, and CS2', 'Events', 9, 'Esports Club', 'esports@swinburne.edu.vn', 'clubs', '2025-09-22', '2025-12-13', '2025-12-15', '2025-12-01', 'All campuses', 200, 178, 15, 'upcoming', 1, 0, 1, 5, 'online', 'Discord Server', 'https://discord.gg/swinburne-esports', 'Per Game - 1st: 300 GOLD + Gaming Peripherals, 2nd: 150 GOLD, 3rd: 75 GOLD', 'Team of 5. Standard tournament rules. No cheating. Streaming encouraged.', 'esports@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 678, 345, 178, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(17, 'Podcast Creation Workshop', 'Learn to create and produce professional podcasts', 'Media', 3, 'Media & Communication Faculty', 'media@swinburne.edu.au', 'staff', '2025-10-11', '2025-12-18', '2025-12-19', '2025-12-08', 'Hanoi campus', 30, 24, 0, 'upcoming', 1, 0, 1, 2, 'offline', 'Media Studio, Hanoi', '', 'Best Podcast: Audio Equipment Bundle, Runner-up: 100 GOLD, All: Certificates', 'Create 10-15 minute episode. Any topic (appropriate). Team or solo. Professional editing required.', 'podcast@swinburne.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 156, 78, 24, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(18, 'Cybersecurity CTF', 'Capture the flag competition for aspiring security professionals', 'Technology', 10, 'InfoSec Club', 'infosec@swinburne.edu.vn', 'clubs', '2025-10-02', '2025-12-21', '2025-12-22', '2025-12-15', 'All campuses', 150, 98, 3, 'upcoming', 1, 0, 1, 3, 'online', 'CTF Platform', 'https://ctf.swinburne.edu', '1st: 200 GOLD + Security Certifications, 2nd: 120 GOLD, 3rd: 60 GOLD', 'Ethical hacking only. No DoS attacks. Document your approach. Learn and have fun.', 'infosec@swinburne.edu.vn', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 289, 145, 98, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(19, 'Creative Writing Contest', 'Express yourself through short stories and poetry', 'Community', 23, 'Emily Pham', 'emily.pham@student.swin.edu.vn', 'individual', '2025-10-09', '2026-01-05', '2026-01-20', '2025-12-28', 'All campuses', 100, 56, 0, 'upcoming', 1, 0, 0, 1, 'online', 'Online Submission Portal', 'https://writing.swinburne.edu', '1st: 800k VND + Publication, 2nd: 500k VND, 3rd: 300k VND + Feedback Session', 'Max 3000 words for stories, 50 lines for poetry. Original work. English or Vietnamese.', 'emily.pham@student.swin.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 223, 102, 56, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(20, 'Investment Challenge', 'Virtual stock trading competition with real market data', 'Business', 11, 'Finance Club', 'finance@swinburne.edu.vn', 'clubs', '2025-09-27', '2026-01-06', '2026-03-06', '2025-12-30', 'All campuses', 250, 189, 10, 'upcoming', 1, 0, 1, 2, 'online', 'Trading Simulator', 'https://invest.swinburne.edu', '1st: $1000 + Bloomberg Terminal Access, 2nd: $600, 3rd: $300', 'Virtual $100K portfolio. Real-time data. Weekly reports required. Ethical trading only.', 'finance@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 445, 223, 189, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(21, 'Future of Fintech Challenge', 'Design and prototype a decentralized finance application in a 3-week sprint.', 'Technology', 25, 'Alex Chen', 'alex.chen@swinburne.edu.au', 'staff', '2025-09-01', '2025-11-10', '2025-12-01', '2025-11-05', 'All campuses', 500, 150, 0, 'ongoing', 0, 0, 1, 4, 'online', NULL, NULL, '1st: $3000, Mentorship, 2nd: $1500', NULL, 'fintech@swinburne.edu.au', NULL, 850, 0, 150, 0.00, '2025-11-16 11:06:08', '2025-11-16 11:06:08'),
(22, 'Swinburne Annual Chess Tournament', 'The yearly battle of minds.', 'Community', 11, 'Finance Club', 'finance@swinburne.edu.vn', 'clubs', '2025-08-01', '2025-10-05', '2025-10-05', '2025-09-30', 'Hanoi campus', 50, 48, 0, 'completed', 0, 0, 0, 1, 'offline', 'Library Hall, Hanoi', 'https://c.files.bbci.co.uk/7CC2/production/_118283913_29xp-meme-mobilemasterat3x-v3.jpg', '1st: 200 GOLD, Trophy, 2nd: 100 GOLD', 'https://c.files.bbci.co.uk/7CC2/production/_118283913_29xp-meme-mobilemasterat3x-v3.jpg', 'chess@swinburne.edu.vn', NULL, 450, 0, 48, 0.85, '2025-11-16 11:06:08', '2025-11-28 04:03:32'),
(23, 'Green Tech Design Sprint', 'A challenge to design an energy-efficient device.', 'Events', 25, 'Alex Chen', 'alex.chen@swinburne.edu.au', 'staff', '2025-11-01', '2026-02-01', '2026-02-05', '2026-01-20', 'All campuses', 300, 5, 0, 'upcoming', 1, 0, 1, 3, 'hybrid', 'Innovation Lab + Zoom', NULL, '1st: $1000 + Manufacturing Support', NULL, 'greentech@swinburne.edu.au', 'https://i.pinimg.com/1200x/23/9c/69/239c6952a0bf8d7b57fdce27eff1f082.jpg', 20, 0, 5, 0.00, '2025-11-16 11:06:08', '2025-11-28 04:23:02');

-- --------------------------------------------------------

--
-- Table structure for table `competition_gallery`
--

CREATE TABLE `competition_gallery` (
  `id` int NOT NULL,
  `competition_id` int NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `caption` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competition_gallery`
--

INSERT INTO `competition_gallery` (`id`, `competition_id`, `url`, `caption`) VALUES
(1, 1, 'https://i.pinimg.com/736x/5d/2a/e5/5d2ae59e3ebd0c245c7dad1125eb0fd7.jpg', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\r\n\r\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.'),
(2, 1, 'https://i.pinimg.com/736x/5d/2a/e5/5d2ae59e3ebd0c245c7dad1125eb0fd7.jpg', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\r\n\r\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.'),
(3, 1, 'https://i.pinimg.com/736x/5d/2a/e5/5d2ae59e3ebd0c245c7dad1125eb0fd7.jpg', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\r\n\r\nIn congue. Etiam justo. Etiam pretium iaculis justo.\r\n\r\nIn hac habitasse pla');

-- --------------------------------------------------------

--
-- Table structure for table `competition_participants`
--

CREATE TABLE `competition_participants` (
  `id` int NOT NULL,
  `competition_id` int NOT NULL,
  `user_id` int NOT NULL,
  `joined_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','approved','rejected','withdrawn') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'approved',
  `team_name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competition_participants`
--

INSERT INTO `competition_participants` (`id`, `competition_id`, `user_id`, `joined_at`, `status`, `team_name`) VALUES
(1, 1, 4, '2025-11-16 04:03:01', 'approved', 'Meme'),
(2, 21, 26, '2025-11-10 03:00:00', 'approved', 'Finnovators'),
(3, 21, 27, '2025-11-10 03:15:00', 'approved', 'Finnovators'),
(4, 23, 27, '2025-11-16 11:00:00', 'pending', 'Green Dream Team');

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `content` text COLLATE utf8mb4_general_ci,
  `category` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `image`, `date`, `title`, `content`, `category`) VALUES
(1, 'https://i.pinimg.com/736x/13/50/2d/13502dfd688966737d608cf45d4c79d7.jpg', '2025-04-06', 'Annual Coding Competition Announced', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.', 'Workshop'),
(2, 'https://i.pinimg.com/1200x/95/98/ea/9598ea91027906d3873b0bf6d40fd3c7.jpg', '2025-06-23', 'New Partnership with Tech Giants', 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 'Competition'),
(3, 'https://i.pinimg.com/736x/37/05/9b/37059bbbf5d9060b1984dcbc5ef3b810.jpg', '2025-02-04', 'Hackathon 2024 Winners Revealed', 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', 'Results'),
(4, 'https://i.pinimg.com/736x/95/85/38/95853855f02ebb4a32ccc7ef0a5b13e1.jpg', '2025-05-19', 'Design Competition Extended Deadline', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Competition'),
(5, 'https://i.pinimg.com/1200x/aa/c6/81/aac681c78d3d537c497139af349d99b7.jpg', '2025-09-04', 'Workshop: Introduction to Machine Learning', 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', 'Workshop'),
(6, 'https://i.pinimg.com/736x/5d/2a/e5/5d2ae59e3ebd0c245c7dad1125eb0fd7.jpg', '2025-09-30', 'Platform Update: New Features Released', 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Update'),
(7, 'http://dummyimage.com/x.png/dddddd/000000', '2025-03-25', 'Data Science Challenge Begins', 'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 'Competition'),
(8, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-10-14', 'Success Story: Alumni Spotlight', 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Results'),
(9, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-06-07', 'Mobile App Development Contest', 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', 'Workshop'),
(10, 'http://dummyimage.com/x.png/dddddd/000000', '2025-05-12', 'Cybersecurity Awareness Month', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Competition'),
(11, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-03-23', 'New Mentor Program Launched', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Workshop'),
(12, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-07-26', 'Web Development Bootcamp Registration', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', 'Update'),
(13, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-07-30', 'Community Meetup This Weekend', 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', 'Partnership'),
(14, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-02-09', 'Game Development Jam Announced', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Program'),
(15, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-06-27', 'Scholarship Opportunities Available', 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', 'Program'),
(16, 'http://dummyimage.com/x.png/dddddd/000000', '2024-12-04', 'Platform Maintenance Scheduled', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Update'),
(17, 'http://dummyimage.com/x.png/dddddd/000000', '2024-12-18', 'Interview Preparation Workshop', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', 'Opportunity'),
(18, 'http://dummyimage.com/x.png/dddddd/000000', '2025-06-13', 'Open Source Contribution Drive', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Results'),
(19, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-04-07', 'ΑΙ Workshop Series Begins', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 'Results'),
(20, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-02-26', 'Cloud Computing Competition', 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Program'),
(21, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-04-25', 'Frontend Development Masterclass', 'Duis mattis egestas metus. Aenean fermentum.', 'Update'),
(22, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-01-05', 'Backend Development Challenge', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', 'Results'),
(23, 'http://dummyimage.com/x.png/dddddd/000000', '2025-11-06', 'Full Stack Developer Summit', 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', 'Program'),
(24, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-01-16', 'Tech Talk: Future of Web Development', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 'Event'),
(25, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-10-18', 'Student Projects Showcase', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Success Story'),
(26, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-06-11', 'Career Fair Registration Open', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Workshop'),
(27, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-09-02', 'Networking Event Next Month', 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', 'Workshop'),
(28, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-09-22', 'Advanced React Workshop', 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 'Update'),
(29, 'http://dummyimage.com/x.png/ff4444/ffffff', '2024-12-20', 'Python Programming Bootcamp', 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Partnership'),
(30, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-08-14', 'Database Design Competition', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Success Story'),
(31, 'http://dummyimage.com/x.png/dddddd/000000', '2025-07-19', 'DevOps Best Practices Seminar', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Opportunity'),
(32, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-04-03', 'Agile Development Workshop', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', 'Partnership'),
(33, 'http://dummyimage.com/x.png/dddddd/000000', '2025-10-23', 'Code Review Best Practices', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.', 'Workshop'),
(34, 'http://dummyimage.com/x.png/dddddd/000000', '2025-05-10', 'Git and GitHub Masterclass', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 'Partnership'),
(35, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-06-24', 'API Development Workshop', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Results'),
(36, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-02-24', 'Microservices Architecture Talk', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'Results'),
(37, 'http://dummyimage.com/x.png/dddddd/000000', '2025-02-28', 'Testing Strategies Workshop', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Competition'),
(38, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-01-03', 'Performance Optimization Seminar', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Partnership'),
(39, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-03-15', 'Security Best Practices Event', 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Competition'),
(40, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-08-27', 'UI/UX Design Principles', 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', 'Competition'),
(41, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-04-24', 'Mobile First Design Workshop', 'Vivamus tortor. Duis mattis egestas. metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 'Results'),
(42, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-10-12', 'Accessibility in Web Development', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Results'),
(43, 'http://dummyimage.com/x.png/cc0000/ffffff', '2024-12-19', 'Progressive Web Apps Workshop', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 'Success Story'),
(44, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-03-10', 'GraphQL Introduction Session', 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Partnership'),
(45, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2024-11-17', 'Docker and Containers Workshop', 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 'Event'),
(46, 'http://dummyimage.com/x.png/dddddd/000000', '2025-01-27', 'Kubernetes Fundamentals', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Partnership'),
(47, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-01-28', 'CI/CD Pipeline Workshop', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 'Update'),
(48, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-06-26', 'Tech Industry Panel Discussion', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', 'Competition'),
(49, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-06-14', 'Startup Pitch Competition', 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Results'),
(50, 'http://dummyimage.com/x.png/dddddd/000000', '2024-12-03', 'Innovation Challenge Announced', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Event'),
(51, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-08-11', 'Blockchain Technology Seminar', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Competition'),
(52, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-04-08', 'Quantum Computing Introduction', 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', 'Event'),
(53, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-11-03', 'Virtual Reality Development Workshop', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', 'Workshop'),
(54, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-05-26', 'Augmented Reality Applications', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Opportunity'),
(55, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-09-29', 'Internet of Things Projects', 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Competition'),
(56, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-09-25', '5G Technology Overview', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Success Story'),
(57, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-03-06', 'Software Architecture Patterns', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', 'Results'),
(58, 'http://dummyimage.com/x.png/dddddd/000000', '2025-01-18', 'Microservices vs Monoliths Debate', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Results'),
(59, 'http://dummyimage.com/x.png/ff4444/ffffff', '2025-04-25', 'Serverless Computing Workshop', 'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', 'Event'),
(60, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-06-17', 'Edge Computing Fundamentals', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', 'Results'),
(61, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-09-24', 'Neural Networks Deep Dive', 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.', 'Results'),
(62, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-04-06', 'Natural Language Processing Tutorial', 'Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 'Competition'),
(63, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-05-30', 'Computer Vision Applications', 'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', 'Partnership'),
(64, 'http://dummyimage.com/x.png/ff4444/ffffff', '2024-12-26', 'Reinforcement Learning Workshop', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', 'Event'),
(65, 'http://dummyimage.com/x.png/cc0000/ffffff', '2024-12-17', 'Deep Learning Bootcamp', 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.', 'Workshop'),
(66, 'http://dummyimage.com/x.png/cc0000/ffffff', '2024-12-03', 'TensorFlow Masterclass', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', 'Program'),
(67, 'http://dummyimage.com/x.png/5fa2dd/ffffff', '2025-03-23', 'PyTorch Programming Guide', 'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Partnership'),
(68, 'http://dummyimage.com/x.png/dddddd/000000', '2025-02-16', 'MLOps Best Practices', 'Fusce consequat. Nulla nisl.', 'Event'),
(69, 'http://dummyimage.com/x.png/dddddd/000000', '2025-08-28', 'Data Engineering Pipeline', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', 'Success Story'),
(70, 'http://dummyimage.com/x.png/dddddd/000000', '2025-03-06', 'Big Data Analytics Workshop', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', 'Results'),
(71, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-01-15', 'Apache Spark Tutorial', 'Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Program'),
(72, 'http://dummyimage.com/x.png/dddddd/000000', '2025-05-30', 'Hadoop Ecosystem Overview', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', 'Opportunity'),
(73, 'http://dummyimage.com/x.png/cc0000/ffffff', '2024-11-14', 'NoSQL Databases Comparison', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', 'Update'),
(74, 'http://dummyimage.com/x.png/cc0000/ffffff', '2025-07-03', 'PostgreSQL Advanced Features', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'Workshop');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int NOT NULL,
  `competition_id` int NOT NULL,
  `project_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `elevator_pitch` text COLLATE utf8mb4_general_ci NOT NULL,
  `about_project` text COLLATE utf8mb4_general_ci NOT NULL,
  `built_with` text COLLATE utf8mb4_general_ci NOT NULL,
  `video_demo_link` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `thumbnail` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uploader_id` int NOT NULL,
  `uploader_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `uploader_email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `uploader_avatar` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('draft','submitted','approved','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'submitted',
  `votes` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `competition_id`, `project_name`, `elevator_pitch`, `about_project`, `built_with`, `video_demo_link`, `thumbnail`, `uploader_id`, `uploader_name`, `uploader_email`, `uploader_avatar`, `submitted_at`, `updated_at`, `status`, `votes`) VALUES
(1, 1, 'EcoTrack AI', 'AI-powered carbon footprint tracker that helps individuals and businesses reduce their environmental impact through personalized recommendations.', '### Inspiration\n\nClimate change is one of the biggest challenges of our generation. We wanted to create a tool that makes it easy for everyone to understand and reduce their carbon footprint.\n\n### What it does\n\nEcoTrack AI uses machine learning to analyze daily activities, transportation choices, and consumption patterns to calculate accurate carbon emissions. It then provides personalized, actionable recommendations to reduce environmental impact.\n\n### How we built it\n\nWe used React Native for the mobile app, Python with TensorFlow for the ML models, and Firebase for backend services. The carbon calculation algorithms are based on EPA and IPCC data.\n\n### Challenges we faced\n\nGetting accurate carbon emission data across different countries was challenging. We also struggled with making the ML model work efficiently on mobile devices.\n\n### What we learned\n\nWe learned about carbon accounting, optimization techniques for mobile ML, and the importance of user-friendly design for environmental apps.', 'React Native, Python, TensorFlow, Firebase, Node.js, EPA Carbon API', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 4, 'Nguyen Minh Tuan', 'tuan.nguyen@student.swin.edu.vn', 'https://i.pravatar.cc/150?img=1', '2026-02-15 07:30:00', '2026-03-01 03:15:00', 'approved', 245),
(2, 21, 'SwiftPay: Decentralized P2P Lending', 'A smart contract-based platform for transparent, instant, and borderless peer-to-peer lending.', 'SwiftPay aims to disrupt traditional finance by using blockchain to eliminate intermediaries, reduce fees, and offer better rates. The system features an on-chain credit score based on repayment history. The project was built over 3 weeks during the Fintech Challenge.', 'Solidity, Ethereum, React.js, Web3.js, IPFS', 'https://www.youtube.com/watch?v=SWIFTDEMO', NULL, 26, 'Jessica Lee', 'jessica.lee@student.swin.edu.vn', 'https://i.pravatar.cc/150?img=26', '2025-11-25 07:00:00', '2025-11-16 11:06:30', 'approved', 42);

-- --------------------------------------------------------

--
-- Table structure for table `project_comments`
--

CREATE TABLE `project_comments` (
  `id` int NOT NULL,
  `project_id` int NOT NULL,
  `user_id` int NOT NULL,
  `user_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `user_avatar` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_general_ci NOT NULL,
  `likes` int NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_comments`
--

INSERT INTO `project_comments` (`id`, `project_id`, `user_id`, `user_name`, `user_avatar`, `comment`, `likes`, `timestamp`) VALUES
(1, 1, 5, 'Sarah Chen', 'https://i.pravatar.cc/150?img=5', 'This is amazing! The AI recommendations are really practical and easy to follow. Great work!', 12, '2026-02-16 02:20:00'),
(2, 2, 25, 'Alex Chen', NULL, 'Great concept! Have you considered the regulatory challenges in different jurisdictions?', 5, '2025-11-16 11:06:57'),
(3, 2, 1, 'Computer Science Faculty', NULL, 'The UI is very clean and intuitive. Excellent work on the smart contract integration.', 12, '2025-11-16 11:06:57');

-- --------------------------------------------------------

--
-- Table structure for table `project_images`
--

CREATE TABLE `project_images` (
  `id` int NOT NULL,
  `project_id` int NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `caption` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `display_order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_images`
--

INSERT INTO `project_images` (`id`, `project_id`, `url`, `caption`, `display_order`) VALUES
(1, 1, 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'EcoTrack Dashboard', 1),
(2, 1, 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 'Carbon Footprint Analysis', 2);

-- --------------------------------------------------------

--
-- Table structure for table `project_links`
--

CREATE TABLE `project_links` (
  `id` int NOT NULL,
  `project_id` int NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `display_order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_links`
--

INSERT INTO `project_links` (`id`, `project_id`, `url`, `display_order`) VALUES
(1, 1, 'https://github.com/ecotrack-ai/mobile-app', 1),
(2, 1, 'https://ecotrack-demo.herokuapp.com', 2);

-- --------------------------------------------------------

--
-- Table structure for table `project_votes`
--

CREATE TABLE `project_votes` (
  `id` int NOT NULL,
  `project_id` int NOT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_votes`
--

INSERT INTO `project_votes` (`id`, `project_id`, `user_id`) VALUES
(4, 2, 25),
(5, 2, 26),
(6, 2, 27);

-- --------------------------------------------------------

--
-- Table structure for table `team_members`
--

CREATE TABLE `team_members` (
  `id` int NOT NULL,
  `project_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `display_order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_members`
--

INSERT INTO `team_members` (`id`, `project_id`, `user_id`, `name`, `role`, `display_order`) VALUES
(1, 1, 4, 'Nguyen Minh Tuan', 'Full-stack Developer', 1),
(2, 1, NULL, 'Tran Quynh Anh', 'ML Engineer', 2),
(3, 1, NULL, 'Le Hoang Nam', 'UI/UX Designer', 3),
(4, 2, 26, 'Jessica Lee', 'Project Lead / Frontend', 1),
(5, 2, 27, 'David Kim', 'Blockchain Developer', 2);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(11) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('Male','Female','Other') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('student','staff') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'student',
  `avatar` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `password`, `gender`, `role`, `avatar`, `created_at`, `updated_at`) VALUES
(1, 'Patrick', 'Kliemke', 'pkliemke0@so-net.ne.jp', NULL, 'Pass123!', NULL, 'student', 'https://i.pravatar.cc/150?img=1', '2025-11-16 04:03:01', '2025-11-16 04:11:05'),
(2, 'Bobby', 'Gwatkin', 'bgwatkin1@wikia.com', NULL, 'Pass123!', NULL, 'student', 'https://i.pravatar.cc/150?img=2', '2025-11-16 04:03:01', '2025-11-16 04:11:15'),
(3, 'Computer Science', 'Faculty', 'tech@swinburne.edu.au', NULL, 'Pass123!', NULL, 'staff', 'https://i.pravatar.cc/150?img=10', '2025-11-16 04:03:01', '2025-11-16 04:11:16'),
(4, 'Nguyen Minh', 'Tuan', 'tuan.nguyen@student.swin.edu.vn', NULL, 'Pass123!', NULL, 'student', 'https://i.pravatar.cc/150?img=3', '2025-11-16 04:03:01', '2025-11-16 04:11:17'),
(5, 'Sarah', 'Chen', 'sarah.chen@student.swin.edu.vn', NULL, 'Pass123!', NULL, 'student', 'https://i.pravatar.cc/150?img=5', '2025-11-16 04:03:01', '2025-11-16 04:11:21'),
(6, 'Chi', 'May', 'maichiviolet@gmail.com', '08249678682', 'Pass123!', 'Female', 'student', NULL, '2025-11-16 07:46:39', '2025-11-16 07:46:39'),
(25, 'Alex', 'Chen', 'alex.chen@swinburne.edu.au', '0912345670', '$2a$10$HASHEDPASSWORD', 'Male', 'staff', 'https://i.pravatar.cc/150?img=25', '2025-11-16 11:05:57', '2025-11-16 11:05:57'),
(26, 'Jessica', 'Lee', 'jessica.lee@student.swin.edu.vn', '0912345671', '$2a$10$HASHEDPASSWORD', 'Female', 'student', 'https://i.pravatar.cc/150?img=26', '2025-11-16 11:05:57', '2025-11-16 11:05:57'),
(27, 'David', 'Kim', 'david.kim@student.swin.edu.vn', '0912345672', '$2a$10$HASHEDPASSWORD', 'Male', 'student', 'https://i.pravatar.cc/150?img=27', '2025-11-16 11:05:57', '2025-11-16 11:05:57');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_competitions_full`
-- (See below for the actual view)
--
CREATE TABLE `v_competitions_full` (
`id` int
,`title` varchar(255)
,`description` text
,`category` varchar(100)
,`organizer_id` int
,`organizer_name` varchar(255)
,`organizer_email` varchar(255)
,`organizer_type` enum('staff','faculty','individual','clubs')
,`created_date` date
,`start_date` date
,`end_date` date
,`registration_deadline` date
,`participants` varchar(255)
,`max_capacity` int
,`current_capacity` int
,`waitlist` int
,`status` enum('upcoming','ongoing','completed','cancelled')
,`registration_is_open` tinyint(1)
,`requires_approval` tinyint(1)
,`allow_teams` tinyint(1)
,`team_size` int
,`location_type` enum('online','onsite','hybrid','offline')
,`venue` varchar(255)
,`location_link` varchar(500)
,`prizes` text
,`rules` text
,`contact_email` varchar(255)
,`banner_image` varchar(500)
,`views` int
,`votes` int
,`registrations` int
,`completion_rate` decimal(5,2)
,`created_at` timestamp
,`updated_at` timestamp
,`organizer_first_name` varchar(100)
,`organizer_last_name` varchar(100)
,`organizer_avatar` varchar(500)
,`actual_registrations` bigint
,`project_count` bigint
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_projects_full`
-- (See below for the actual view)
--
CREATE TABLE `v_projects_full` (
`id` int
,`competition_id` int
,`project_name` varchar(255)
,`elevator_pitch` text
,`about_project` text
,`built_with` text
,`video_demo_link` varchar(500)
,`thumbnail` varchar(500)
,`uploader_id` int
,`uploader_name` varchar(255)
,`uploader_email` varchar(255)
,`uploader_avatar` varchar(500)
,`submitted_at` timestamp
,`updated_at` timestamp
,`status` enum('draft','submitted','approved','rejected')
,`votes` int
,`uploader_first_name` varchar(100)
,`uploader_last_name` varchar(100)
,`competition_title` varchar(255)
,`comment_count` bigint
,`vote_count` bigint
);

-- --------------------------------------------------------

--
-- Structure for view `v_competitions_full`
--
DROP TABLE IF EXISTS `v_competitions_full`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_competitions_full`  AS SELECT `c`.`id` AS `id`, `c`.`title` AS `title`, `c`.`description` AS `description`, `c`.`category` AS `category`, `c`.`organizer_id` AS `organizer_id`, `c`.`organizer_name` AS `organizer_name`, `c`.`organizer_email` AS `organizer_email`, `c`.`organizer_type` AS `organizer_type`, `c`.`created_date` AS `created_date`, `c`.`start_date` AS `start_date`, `c`.`end_date` AS `end_date`, `c`.`registration_deadline` AS `registration_deadline`, `c`.`participants` AS `participants`, `c`.`max_capacity` AS `max_capacity`, `c`.`current_capacity` AS `current_capacity`, `c`.`waitlist` AS `waitlist`, `c`.`status` AS `status`, `c`.`registration_is_open` AS `registration_is_open`, `c`.`requires_approval` AS `requires_approval`, `c`.`allow_teams` AS `allow_teams`, `c`.`team_size` AS `team_size`, `c`.`location_type` AS `location_type`, `c`.`venue` AS `venue`, `c`.`location_link` AS `location_link`, `c`.`prizes` AS `prizes`, `c`.`rules` AS `rules`, `c`.`contact_email` AS `contact_email`, `c`.`banner_image` AS `banner_image`, `c`.`views` AS `views`, `c`.`votes` AS `votes`, `c`.`registrations` AS `registrations`, `c`.`completion_rate` AS `completion_rate`, `c`.`created_at` AS `created_at`, `c`.`updated_at` AS `updated_at`, `u`.`first_name` AS `organizer_first_name`, `u`.`last_name` AS `organizer_last_name`, `u`.`avatar` AS `organizer_avatar`, count(distinct `cp`.`id`) AS `actual_registrations`, count(distinct `p`.`id`) AS `project_count` FROM (((`competitions` `c` left join `users` `u` on((`c`.`organizer_id` = `u`.`id`))) left join `competition_participants` `cp` on(((`c`.`id` = `cp`.`competition_id`) and (`cp`.`status` = 'approved')))) left join `projects` `p` on(((`c`.`id` = `p`.`competition_id`) and (`p`.`status` = 'approved')))) GROUP BY `c`.`id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_projects_full`
--
DROP TABLE IF EXISTS `v_projects_full`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_projects_full`  AS SELECT `p`.`id` AS `id`, `p`.`competition_id` AS `competition_id`, `p`.`project_name` AS `project_name`, `p`.`elevator_pitch` AS `elevator_pitch`, `p`.`about_project` AS `about_project`, `p`.`built_with` AS `built_with`, `p`.`video_demo_link` AS `video_demo_link`, `p`.`thumbnail` AS `thumbnail`, `p`.`uploader_id` AS `uploader_id`, `p`.`uploader_name` AS `uploader_name`, `p`.`uploader_email` AS `uploader_email`, `p`.`uploader_avatar` AS `uploader_avatar`, `p`.`submitted_at` AS `submitted_at`, `p`.`updated_at` AS `updated_at`, `p`.`status` AS `status`, `p`.`votes` AS `votes`, `u`.`first_name` AS `uploader_first_name`, `u`.`last_name` AS `uploader_last_name`, `c`.`title` AS `competition_title`, count(distinct `pc`.`id`) AS `comment_count`, count(distinct `pv`.`id`) AS `vote_count` FROM ((((`projects` `p` left join `users` `u` on((`p`.`uploader_id` = `u`.`id`))) left join `competitions` `c` on((`p`.`competition_id` = `c`.`id`))) left join `project_comments` `pc` on((`p`.`id` = `pc`.`project_id`))) left join `project_votes` `pv` on((`p`.`id` = `pv`.`project_id`))) GROUP BY `p`.`id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `competitions`
--
ALTER TABLE `competitions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_organizer` (`organizer_id`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_location_type` (`location_type`);

--
-- Indexes for table `competition_gallery`
--
ALTER TABLE `competition_gallery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_competition` (`competition_id`);

--
-- Indexes for table `competition_participants`
--
ALTER TABLE `competition_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_participant` (`competition_id`,`user_id`),
  ADD KEY `idx_competition` (`competition_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indexes for table `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_competition` (`competition_id`),
  ADD KEY `idx_uploader` (`uploader_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_votes` (`votes`);

--
-- Indexes for table `project_comments`
--
ALTER TABLE `project_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project` (`project_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `project_images`
--
ALTER TABLE `project_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project` (`project_id`);

--
-- Indexes for table `project_links`
--
ALTER TABLE `project_links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_project` (`project_id`);

--
-- Indexes for table `project_votes`
--
ALTER TABLE `project_votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_vote` (`project_id`,`user_id`),
  ADD KEY `idx_project` (`project_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indexes for table `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_project` (`project_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `competition_gallery`
--
ALTER TABLE `competition_gallery`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `project_comments`
--
ALTER TABLE `project_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `project_images`
--
ALTER TABLE `project_images`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `project_links`
--
ALTER TABLE `project_links`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `project_votes`
--
ALTER TABLE `project_votes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `team_members`
--
ALTER TABLE `team_members`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `competition_gallery`
--
ALTER TABLE `competition_gallery`
  ADD CONSTRAINT `competition_gallery_ibfk_1` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_comments`
--
ALTER TABLE `project_comments`
  ADD CONSTRAINT `project_comments_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_images`
--
ALTER TABLE `project_images`
  ADD CONSTRAINT `project_images_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_links`
--
ALTER TABLE `project_links`
  ADD CONSTRAINT `project_links_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_votes`
--
ALTER TABLE `project_votes`
  ADD CONSTRAINT `project_votes_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_votes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `team_members_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `team_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
