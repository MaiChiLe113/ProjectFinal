-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2025 at 08:47 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

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
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `organizer_id` int(11) NOT NULL,
  `organizer_name` varchar(255) NOT NULL,
  `organizer_email` varchar(255) NOT NULL,
  `organizer_type` enum('staff','faculty','individual','clubs') NOT NULL,
  `created_date` date NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `registration_deadline` date NOT NULL,
  `participants` varchar(255) NOT NULL,
  `max_capacity` int(11) NOT NULL DEFAULT 1000,
  `current_capacity` int(11) NOT NULL DEFAULT 0,
  `waitlist` int(11) NOT NULL DEFAULT 0,
  `status` enum('upcoming','ongoing','completed','cancelled') NOT NULL DEFAULT 'upcoming',
  `registration_is_open` tinyint(1) NOT NULL DEFAULT 1,
  `requires_approval` tinyint(1) NOT NULL DEFAULT 0,
  `allow_teams` tinyint(1) NOT NULL DEFAULT 0,
  `team_size` int(11) DEFAULT NULL,
  `location_type` enum('online','onsite','hybrid','offline') NOT NULL DEFAULT 'online',
  `venue` varchar(255) DEFAULT NULL,
  `location_link` varchar(500) DEFAULT NULL,
  `prizes` text DEFAULT NULL,
  `rules` text DEFAULT NULL,
  `contact_email` varchar(255) NOT NULL,
  `banner_image` varchar(500) DEFAULT NULL,
  `thumbnail_image` varchar(500) DEFAULT NULL,
  `views` int(11) NOT NULL DEFAULT 0,
  `votes` int(11) NOT NULL DEFAULT 0,
  `registrations` int(11) NOT NULL DEFAULT 0,
  `completion_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `title`, `description`, `category`, `organizer_id`, `organizer_name`, `organizer_email`, `organizer_type`, `created_date`, `start_date`, `end_date`, `registration_deadline`, `participants`, `max_capacity`, `current_capacity`, `waitlist`, `status`, `registration_is_open`, `requires_approval`, `allow_teams`, `team_size`, `location_type`, `venue`, `location_link`, `prizes`, `rules`, `contact_email`, `banner_image`, `thumbnail_image`, `views`, `votes`, `registrations`, `completion_rate`, `created_at`, `updated_at`) VALUES
(1, 'Swin - Hackathon 2026', 'Brings people and AI solutions together to build a better world.', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-10-01', '2026-01-30', '2026-04-30', '2025-12-10', 'All campuses', 10000, 450, 0, 'upcoming', 1, 0, 1, 3, 'online', 'Online Platform', 'https://contest.example.com', '1st Prize: $1000, 2nd Prize: $500, 3rd Prize: $250', 'Follow the official rules and regulations. No plagiarism. All submissions must be original work.', 'coding@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 234, 89, 45, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(2, 'Performative Male', 'Who gonna be best performative S-Winners', 'Community', 20, 'Unknown Penguin', 'meo@gmail.com', 'individual', '2025-10-01', '2025-11-29', '2025-11-30', '2025-12-10', 'Hanoi campus', 10000, 450, 0, 'upcoming', 1, 0, 1, 3, 'offline', '02 Duong Khue, Hanoi', 'https://contest.example.com', '50 GOLD, 200k voucher Highlands Coffee', 'Wear best.', 'meo@gmail.com', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 90, 89, 15, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(3, 'MisChef', 'Chefchoice competition for the best dishes', 'Events', 10, 'Swinburne ChefChoice Club', 'chefchoice@swinburne.edu.vn', 'clubs', '2025-10-01', '2025-11-29', '2025-11-30', '2025-12-10', 'Invitation only', 20, 20, 0, 'upcoming', 1, 0, 1, 3, 'offline', '02 Duong Khue, Hanoi', 'https://contest.example.com', '50 GOLD, 200k voucher Highlands Coffee', 'Wear best.', 'meo@gmail.com', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 90, 89, 15, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(4, 'AI Innovation Challenge', 'Create innovative AI solutions for real-world problems', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-09-15', '2025-12-01', '2025-12-15', '2025-11-20', 'All campuses', 500, 234, 12, 'upcoming', 1, 1, 1, 4, 'hybrid', 'Swinburne Innovation Hub', 'https://ai-challenge.swinburne.edu', '1st: $2000 + AWS Credits, 2nd: $1000, 3rd: $500 + Certificates', 'Must use ethical AI practices. Open-source solutions preferred. Team size 2-4 members.', 'ai@swinburne.edu.au', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 567, 145, 234, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(5, 'SwinBiz Rockstar', 'Pitch your startup idea to win funding and mentorship', 'Business', 2, 'Business Faculty', 'business@swinburne.edu.au', 'staff', '2025-10-05', '2025-12-10', '2025-12-12', '2025-11-30', 'Hanoi campus', 100, 78, 5, 'upcoming', 1, 0, 1, 5, 'offline', 'Swinburne Auditorium, Hanoi', '', '$5000 seed funding, Business mentorship, 100 GOLD', 'Original business ideas only. 5-minute pitch presentation. Q&A session included.', 'bizcomp@swinburne.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 'https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg', 456, 201, 78, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(6, 'Digital Media Showcase', 'Showcase your creative digital media projects', 'Media', 3, 'Media & Communication Faculty', 'media@swinburne.edu.au', 'staff', '2025-09-20', '2025-11-25', '2025-11-27', '2025-11-15', 'All campuses', 200, 156, 8, 'upcoming', 1, 0, 1, 3, 'online', 'Virtual Gallery', 'https://media.swinburne.edu/showcase', 'Best Overall: $800, Category Winners: $300 each, Adobe Creative Suite licenses', 'Original content only. Multiple categories available. Submit in standard formats.', 'mediashowcase@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 389, 167, 156, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(7, 'Code Sprint 2025', '48-hour coding marathon to solve algorithmic challenges', 'Technology', 4, 'Coding Club', 'codingclub@swinburne.edu.vn', 'clubs', '2025-10-10', '2025-12-05', '2025-12-07', '2025-11-28', 'HCMC campus', 150, 89, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Tech Lab, HCMC Campus', '', '1st: 150 GOLD + Mechanical Keyboard, 2nd: 100 GOLD, 3rd: 50 GOLD', 'Individual competition. Any programming language allowed. No external help.', 'codingclub@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 234, 98, 89, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(8, 'Photography Walk', 'Capture the essence of your campus through photography', 'Community', 21, 'Sarah Nguyen', 'sarah.nguyen@student.swin.edu.vn', 'individual', '2025-10-12', '2025-11-30', '2025-11-30', '2025-11-25', 'Hanoi campus', 50, 34, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Swinburne Hanoi Campus', '', 'Best Photo: 500k VND voucher, Runner-up: 300k VND voucher, Certificates', 'DSLR or smartphone photography allowed. Edit photos with credit. No stock images.', 'sarah.nguyen@student.swin.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 145, 67, 34, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(9, 'Debate Championship', 'Annual inter-campus debate competition on contemporary issues', 'Events', 5, 'Debate Society', 'debate@swinburne.edu.vn', 'clubs', '2025-09-25', '2025-12-14', '2025-12-15', '2025-12-01', 'All campuses', 80, 56, 3, 'upcoming', 1, 0, 1, 3, 'hybrid', 'Main Auditorium, Hanoi + Online', 'https://debate.swinburne.edu', 'Winning Team: 200 GOLD each + Trophy, Best Speaker: 100 GOLD + Certificate', 'British Parliamentary format. 3 members per team. Professional judging panel.', 'debate@swinburne.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 'https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg', 278, 123, 56, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(10, 'Mobile App Development Contest', 'Build the next breakthrough mobile application', 'Technology', 1, 'Computer Science Faculty', 'tech@swinburne.edu.au', 'staff', '2025-10-01', '2026-01-15', '2026-03-15', '2025-12-31', 'All campuses', 300, 167, 0, 'upcoming', 1, 0, 1, 4, 'online', 'Online Submission Platform', 'https://mobiledev.swinburne.edu', '$3000 + App Store Developer License, 2nd: $1500, 3rd: $750', 'iOS or Android. Original apps only. Must include documentation and demo video.', 'mobiledev@swinburne.edu.au', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 523, 234, 167, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(11, 'Marketing Case Competition', 'Solve real marketing challenges from industry partners', 'Business', 2, 'Business Faculty', 'business@swinburne.edu.au', 'staff', '2025-09-28', '2025-12-08', '2025-12-09', '2025-11-22', 'Hawthorne campus', 60, 45, 2, 'upcoming', 1, 1, 1, 4, 'offline', 'Business Building, Hawthorne', '', '1st: $2000 + Internship Opportunity, 2nd: $1000, 3rd: $500', 'Teams of 4. Real client cases. 24-hour preparation time. Professional presentation required.', 'marketingcomp@swinburne.edu.au', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 'https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg', 312, 145, 45, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(12, 'Short Film Festival', 'Create and showcase your short film masterpiece', 'Media', 6, 'Film Club', 'filmclub@swinburne.edu.vn', 'clubs', '2025-10-03', '2026-02-01', '2026-02-03', '2026-01-15', 'All campuses', 100, 67, 4, 'upcoming', 1, 0, 1, 6, 'hybrid', 'Campus Theater + Online Streaming', 'https://film.swinburne.edu', 'Best Film: $1200 + Film Equipment, Best Director: 150 GOLD, Audience Choice: 100 GOLD', 'Maximum 15 minutes. Any genre. Original content only. Credits required.', 'filmclub@swinburne.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 445, 198, 67, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(13, 'Data Science Challenge', 'Analyze datasets and extract meaningful insights', 'Technology', 7, 'Data Science Society', 'datascience@swinburne.edu.vn', 'clubs', '2025-09-30', '2025-12-16', '2025-12-18', '2025-12-05', 'All campuses', 200, 143, 7, 'upcoming', 1, 0, 1, 3, 'online', 'Kaggle Platform', 'https://kaggle.com/swinburne-challenge', '1st: 250 GOLD + Cloud Credits, 2nd: 150 GOLD, 3rd: 75 GOLD + Certificates', 'Use provided datasets. Python/R preferred. Submit Jupyter notebooks. Code review required.', 'datascience@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 398, 176, 143, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(14, 'Talent Show Extravaganza', 'Show off your unique talents and skills', 'Community', 22, 'Michael Tran', 'michael.tran@student.swin.edu.vn', 'individual', '2025-10-08', '2025-12-20', '2025-12-20', '2025-12-10', 'HCMC campus', 40, 28, 0, 'upcoming', 1, 0, 0, 1, 'offline', 'Student Center, HCMC', '', 'Winner: 1M VND voucher Shopee, 2nd: 500k VND, 3rd: 300k VND + Certificates', '5-minute performance. Any talent welcome. Clean content only. Backup music on USB.', 'michael.tran@student.swin.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 'https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg', 189, 89, 28, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(15, 'Sustainability Innovation Lab', 'Design sustainable solutions for environmental challenges', 'Events', 8, 'Green Campus Initiative', 'green@swinburne.edu.vn', 'clubs', '2025-10-05', '2026-01-10', '2026-01-12', '2025-12-20', 'All campuses', 120, 87, 5, 'upcoming', 1, 0, 1, 4, 'hybrid', 'Innovation Hub + Virtual', 'https://sustainability.swinburne.edu', '1st: $1500 + Project Implementation Support, 2nd: $800, 3rd: $400', 'Focus on sustainability. Feasible solutions. Prototype preferred. Impact assessment required.', 'green@swinburne.edu.vn', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 267, 134, 87, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(16, 'Esports Championship', 'Compete in League of Legends, Valorant, and CS2', 'Events', 9, 'Esports Club', 'esports@swinburne.edu.vn', 'clubs', '2025-09-22', '2025-12-13', '2025-12-15', '2025-12-01', 'All campuses', 200, 178, 15, 'upcoming', 1, 0, 1, 5, 'online', 'Discord Server', 'https://discord.gg/swinburne-esports', 'Per Game - 1st: 300 GOLD + Gaming Peripherals, 2nd: 150 GOLD, 3rd: 75 GOLD', 'Team of 5. Standard tournament rules. No cheating. Streaming encouraged.', 'esports@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 678, 345, 178, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(17, 'Podcast Creation Workshop', 'Learn to create and produce professional podcasts', 'Media', 3, 'Media & Communication Faculty', 'media@swinburne.edu.au', 'staff', '2025-10-11', '2025-12-18', '2025-12-19', '2025-12-08', 'Hanoi campus', 30, 24, 0, 'upcoming', 1, 0, 1, 2, 'offline', 'Media Studio, Hanoi', '', 'Best Podcast: Audio Equipment Bundle, Runner-up: 100 GOLD, All: Certificates', 'Create 10-15 minute episode. Any topic (appropriate). Team or solo. Professional editing required.', 'podcast@swinburne.edu.vn', 'https://i.pinimg.com/736x/36/13/67/361367ef0a5bad17922f702dd467e96a.jpg', 'https://i.pinimg.com/1200x/f4/cf/e5/f4cfe5361158ac92a94e4031b21cca3b.jpg', 156, 78, 24, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(18, 'Cybersecurity CTF', 'Capture the flag competition for aspiring security professionals', 'Technology', 10, 'InfoSec Club', 'infosec@swinburne.edu.vn', 'clubs', '2025-10-02', '2025-12-21', '2025-12-22', '2025-12-15', 'All campuses', 150, 98, 3, 'upcoming', 1, 0, 1, 3, 'online', 'CTF Platform', 'https://ctf.swinburne.edu', '1st: 200 GOLD + Security Certifications, 2nd: 120 GOLD, 3rd: 60 GOLD', 'Ethical hacking only. No DoS attacks. Document your approach. Learn and have fun.', 'infosec@swinburne.edu.vn', 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 289, 145, 98, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(19, 'Creative Writing Contest', 'Express yourself through short stories and poetry', 'Community', 23, 'Emily Pham', 'emily.pham@student.swin.edu.vn', 'individual', '2025-10-09', '2026-01-05', '2026-01-20', '2025-12-28', 'All campuses', 100, 56, 0, 'upcoming', 1, 0, 0, 1, 'online', 'Online Submission Portal', 'https://writing.swinburne.edu', '1st: 800k VND + Publication, 2nd: 500k VND, 3rd: 300k VND + Feedback Session', 'Max 3000 words for stories, 50 lines for poetry. Original work. English or Vietnamese.', 'emily.pham@student.swin.edu.vn', 'https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg', 'https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg', 223, 102, 56, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(20, 'Investment Challenge', 'Virtual stock trading competition with real market data', 'Business', 11, 'Finance Club', 'finance@swinburne.edu.vn', 'clubs', '2025-09-27', '2026-01-06', '2026-03-06', '2025-12-30', 'All campuses', 250, 189, 10, 'upcoming', 1, 0, 1, 2, 'online', 'Trading Simulator', 'https://invest.swinburne.edu', '1st: $1000 + Bloomberg Terminal Access, 2nd: $600, 3rd: $300', 'Virtual $100K portfolio. Real-time data. Weekly reports required. Ethical trading only.', 'finance@swinburne.edu.vn', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 'https://i.pinimg.com/736x/fe/ca/2e/feca2eecb78773f7bb69b0734564d357.jpg', 445, 223, 189, 0.00, '2025-11-16 04:03:01', '2025-11-16 04:03:01');

-- --------------------------------------------------------

--
-- Table structure for table `competition_gallery`
--

CREATE TABLE `competition_gallery` (
  `id` int(11) NOT NULL,
  `competition_id` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `competition_participants`
--

CREATE TABLE `competition_participants` (
  `id` int(11) NOT NULL,
  `competition_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','approved','rejected','withdrawn') NOT NULL DEFAULT 'approved',
  `team_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competition_participants`
--

INSERT INTO `competition_participants` (`id`, `competition_id`, `user_id`, `joined_at`, `status`, `team_name`) VALUES
(1, 1, 4, '2025-11-16 04:03:01', 'approved', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `publish_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `news`
--

INSERT INTO `news` (`id`, `title`, `content`, `category`, `image`, `publish_date`, `created_at`, `updated_at`) VALUES
(1, 'Annual Coding Competition Announced', 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.', 'Workshop', 'https://i.pinimg.com/736x/34/45/7f/34457f7c2e3bee32d7d2b8768932533a.jpg', '2025-04-06', '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(2, 'New Partnership with Tech Giants', 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 'Competition', 'https://i.pinimg.com/1200x/db/37/c6/db37c6ca4272904d262bb69c472015fb.jpg', '2025-06-23', '2025-11-16 04:03:01', '2025-11-16 04:03:01'),
(3, 'Hackathon 2024 Winners Revealed', 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.', 'Results', 'https://i.pinimg.com/736x/fb/df/2c/fbdf2c19057b6c4d33c9e90955a6184f.jpg', '2025-02-04', '2025-11-16 04:03:01', '2025-11-16 04:03:01');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `competition_id` int(11) NOT NULL,
  `project_name` varchar(255) NOT NULL,
  `elevator_pitch` text NOT NULL,
  `about_project` text NOT NULL,
  `built_with` text NOT NULL,
  `video_demo_link` varchar(500) DEFAULT NULL,
  `thumbnail` varchar(500) DEFAULT NULL,
  `uploader_id` int(11) NOT NULL,
  `uploader_name` varchar(255) NOT NULL,
  `uploader_email` varchar(255) NOT NULL,
  `uploader_avatar` varchar(500) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('draft','submitted','approved','rejected') NOT NULL DEFAULT 'submitted',
  `votes` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `competition_id`, `project_name`, `elevator_pitch`, `about_project`, `built_with`, `video_demo_link`, `thumbnail`, `uploader_id`, `uploader_name`, `uploader_email`, `uploader_avatar`, `submitted_at`, `updated_at`, `status`, `votes`) VALUES
(1, 1, 'EcoTrack AI', 'AI-powered carbon footprint tracker that helps individuals and businesses reduce their environmental impact through personalized recommendations.', '### Inspiration\n\nClimate change is one of the biggest challenges of our generation. We wanted to create a tool that makes it easy for everyone to understand and reduce their carbon footprint.\n\n### What it does\n\nEcoTrack AI uses machine learning to analyze daily activities, transportation choices, and consumption patterns to calculate accurate carbon emissions. It then provides personalized, actionable recommendations to reduce environmental impact.\n\n### How we built it\n\nWe used React Native for the mobile app, Python with TensorFlow for the ML models, and Firebase for backend services. The carbon calculation algorithms are based on EPA and IPCC data.\n\n### Challenges we faced\n\nGetting accurate carbon emission data across different countries was challenging. We also struggled with making the ML model work efficiently on mobile devices.\n\n### What we learned\n\nWe learned about carbon accounting, optimization techniques for mobile ML, and the importance of user-friendly design for environmental apps.', 'React Native, Python, TensorFlow, Firebase, Node.js, EPA Carbon API', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg', 4, 'Nguyen Minh Tuan', 'tuan.nguyen@student.swin.edu.vn', 'https://i.pravatar.cc/150?img=1', '2026-02-15 07:30:00', '2026-03-01 03:15:00', 'approved', 245);

-- --------------------------------------------------------

--
-- Table structure for table `project_comments`
--

CREATE TABLE `project_comments` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_avatar` varchar(500) DEFAULT NULL,
  `comment` text NOT NULL,
  `likes` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project_comments`
--

INSERT INTO `project_comments` (`id`, `project_id`, `user_id`, `user_name`, `user_avatar`, `comment`, `likes`, `timestamp`) VALUES
(1, 1, 5, 'Sarah Chen', 'https://i.pravatar.cc/150?img=5', 'This is amazing! The AI recommendations are really practical and easy to follow. Great work!', 12, '2026-02-16 02:20:00');

-- --------------------------------------------------------

--
-- Table structure for table `project_images`
--

CREATE TABLE `project_images` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `caption` varchar(255) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0
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
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0
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
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `voted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `team_members`
--

CREATE TABLE `team_members` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `role` varchar(100) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_members`
--

INSERT INTO `team_members` (`id`, `project_id`, `user_id`, `name`, `role`, `display_order`) VALUES
(1, 1, 4, 'Nguyen Minh Tuan', 'Full-stack Developer', 1),
(2, 1, NULL, 'Tran Quynh Anh', 'ML Engineer', 2),
(3, 1, NULL, 'Le Hoang Nam', 'UI/UX Designer', 3);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `role` enum('student','staff') NOT NULL DEFAULT 'student',
  `avatar` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
(6, 'Chi', 'May', 'maichiviolet@gmail.com', '08249678682', 'Pass123!', 'Female', 'student', NULL, '2025-11-16 07:46:39', '2025-11-16 07:46:39');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_competitions_full`
-- (See below for the actual view)
--
CREATE TABLE `v_competitions_full` (
`id` int(11)
,`title` varchar(255)
,`description` text
,`category` varchar(100)
,`organizer_id` int(11)
,`organizer_name` varchar(255)
,`organizer_email` varchar(255)
,`organizer_type` enum('staff','faculty','individual')
,`created_date` date
,`start_date` date
,`end_date` date
,`registration_deadline` date
,`participants` varchar(255)
,`max_capacity` int(11)
,`current_capacity` int(11)
,`waitlist` int(11)
,`status` enum('upcoming','ongoing','completed','cancelled')
,`registration_is_open` tinyint(1)
,`requires_approval` tinyint(1)
,`allow_teams` tinyint(1)
,`team_size` int(11)
,`location_type` enum('online','onsite','hybrid')
,`venue` varchar(255)
,`location_link` varchar(500)
,`prizes` text
,`rules` text
,`contact_email` varchar(255)
,`banner_image` varchar(500)
,`thumbnail_image` varchar(500)
,`views` int(11)
,`votes` int(11)
,`registrations` int(11)
,`completion_rate` decimal(5,2)
,`created_at` timestamp
,`updated_at` timestamp
,`organizer_first_name` varchar(100)
,`organizer_last_name` varchar(100)
,`organizer_avatar` varchar(500)
,`actual_registrations` bigint(21)
,`project_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_projects_full`
-- (See below for the actual view)
--
CREATE TABLE `v_projects_full` (
`id` int(11)
,`competition_id` int(11)
,`project_name` varchar(255)
,`elevator_pitch` text
,`about_project` text
,`built_with` text
,`video_demo_link` varchar(500)
,`thumbnail` varchar(500)
,`uploader_id` int(11)
,`uploader_name` varchar(255)
,`uploader_email` varchar(255)
,`uploader_avatar` varchar(500)
,`submitted_at` timestamp
,`updated_at` timestamp
,`status` enum('draft','submitted','approved','rejected')
,`votes` int(11)
,`uploader_first_name` varchar(100)
,`uploader_last_name` varchar(100)
,`competition_title` varchar(255)
,`comment_count` bigint(21)
,`vote_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `v_competitions_full`
--
DROP TABLE IF EXISTS `v_competitions_full`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_competitions_full`  AS SELECT `c`.`id` AS `id`, `c`.`title` AS `title`, `c`.`description` AS `description`, `c`.`category` AS `category`, `c`.`organizer_id` AS `organizer_id`, `c`.`organizer_name` AS `organizer_name`, `c`.`organizer_email` AS `organizer_email`, `c`.`organizer_type` AS `organizer_type`, `c`.`created_date` AS `created_date`, `c`.`start_date` AS `start_date`, `c`.`end_date` AS `end_date`, `c`.`registration_deadline` AS `registration_deadline`, `c`.`participants` AS `participants`, `c`.`max_capacity` AS `max_capacity`, `c`.`current_capacity` AS `current_capacity`, `c`.`waitlist` AS `waitlist`, `c`.`status` AS `status`, `c`.`registration_is_open` AS `registration_is_open`, `c`.`requires_approval` AS `requires_approval`, `c`.`allow_teams` AS `allow_teams`, `c`.`team_size` AS `team_size`, `c`.`location_type` AS `location_type`, `c`.`venue` AS `venue`, `c`.`location_link` AS `location_link`, `c`.`prizes` AS `prizes`, `c`.`rules` AS `rules`, `c`.`contact_email` AS `contact_email`, `c`.`banner_image` AS `banner_image`, `c`.`thumbnail_image` AS `thumbnail_image`, `c`.`views` AS `views`, `c`.`votes` AS `votes`, `c`.`registrations` AS `registrations`, `c`.`completion_rate` AS `completion_rate`, `c`.`created_at` AS `created_at`, `c`.`updated_at` AS `updated_at`, `u`.`first_name` AS `organizer_first_name`, `u`.`last_name` AS `organizer_last_name`, `u`.`avatar` AS `organizer_avatar`, count(distinct `cp`.`id`) AS `actual_registrations`, count(distinct `p`.`id`) AS `project_count` FROM (((`competitions` `c` left join `users` `u` on(`c`.`organizer_id` = `u`.`id`)) left join `competition_participants` `cp` on(`c`.`id` = `cp`.`competition_id` and `cp`.`status` = 'approved')) left join `projects` `p` on(`c`.`id` = `p`.`competition_id` and `p`.`status` = 'approved')) GROUP BY `c`.`id` ;

-- --------------------------------------------------------

--
-- Structure for view `v_projects_full`
--
DROP TABLE IF EXISTS `v_projects_full`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_projects_full`  AS SELECT `p`.`id` AS `id`, `p`.`competition_id` AS `competition_id`, `p`.`project_name` AS `project_name`, `p`.`elevator_pitch` AS `elevator_pitch`, `p`.`about_project` AS `about_project`, `p`.`built_with` AS `built_with`, `p`.`video_demo_link` AS `video_demo_link`, `p`.`thumbnail` AS `thumbnail`, `p`.`uploader_id` AS `uploader_id`, `p`.`uploader_name` AS `uploader_name`, `p`.`uploader_email` AS `uploader_email`, `p`.`uploader_avatar` AS `uploader_avatar`, `p`.`submitted_at` AS `submitted_at`, `p`.`updated_at` AS `updated_at`, `p`.`status` AS `status`, `p`.`votes` AS `votes`, `u`.`first_name` AS `uploader_first_name`, `u`.`last_name` AS `uploader_last_name`, `c`.`title` AS `competition_title`, count(distinct `pc`.`id`) AS `comment_count`, count(distinct `pv`.`id`) AS `vote_count` FROM ((((`projects` `p` left join `users` `u` on(`p`.`uploader_id` = `u`.`id`)) left join `competitions` `c` on(`p`.`competition_id` = `c`.`id`)) left join `project_comments` `pc` on(`p`.`id` = `pc`.`project_id`)) left join `project_votes` `pv` on(`p`.`id` = `pv`.`project_id`)) GROUP BY `p`.`id` ;

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_publish_date` (`publish_date`);

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


-- AUTO_INCREMENT for table `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

-- AUTO_INCREMENT for table `competition_gallery`
--
ALTER TABLE `competition_gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

-- AUTO_INCREMENT for table `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `project_comments`
--
ALTER TABLE `project_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `project_images`
--
ALTER TABLE `project_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `project_links`
--
ALTER TABLE `project_links`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `project_votes`
--
ALTER TABLE `project_votes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `team_members`
--
ALTER TABLE `team_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
