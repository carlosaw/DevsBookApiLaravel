-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 30-Dez-2021 às 10:22
-- Versão do servidor: 10.4.17-MariaDB
-- versão do PHP: 7.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `devsbook`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Extraindo dados da tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2021_06_03_123932_create_all_tables', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `postcomments`
--

CREATE TABLE `postcomments` (
  `id` int(11) NOT NULL,
  `id_post` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `body` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `postlikes`
--

CREATE TABLE `postlikes` (
  `id` int(11) NOT NULL,
  `id_post` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `postlikes`
--

INSERT INTO `postlikes` (`id`, `id_post`, `id_user`, `created_at`) VALUES
(2, 8, 1, '2021-06-03 15:16:16'),
(10, 9, 1, '2021-06-11 17:25:33'),
(7, 3, 1, '2021-06-11 17:16:43');

-- --------------------------------------------------------

--
-- Estrutura da tabela `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `type` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `body` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `posts`
--

INSERT INTO `posts` (`id`, `id_user`, `type`, `created_at`, `body`) VALUES
(1, 1, 'photo', '2020-07-28 01:10:48', '1.jpg'),
(2, 1, 'text', '2020-07-28 01:12:02', 'Postando alguma coisa bem legal'),
(3, 1, 'text', '2020-07-27 21:19:19', 'Outro post bacana'),
(4, 1, 'text', '2020-07-28 09:19:22', 'Postando aquilo que gosta'),
(5, 1, 'text', '2020-07-28 10:49:27', 'enviando de novo'),
(6, 1, 'text', '2020-07-28 10:50:13', 'algum post enviado'),
(7, 1, 'text', '2020-07-28 10:50:36', 'enviando com igual'),
(8, 1, 'text', '2020-07-28 10:52:56', 'mais post bem legal'),
(9, 1, 'text', '2020-08-03 16:13:37', 'Digitando teste'),
(10, 1, 'photo', '2021-06-11 23:29:06', '390cfb7f933951228191441542a92a7a.jpg');

-- --------------------------------------------------------

--
-- Estrutura da tabela `userrelations`
--

CREATE TABLE `userrelations` (
  `id` int(11) NOT NULL,
  `user_from` int(11) NOT NULL,
  `user_to` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `userrelations`
--

INSERT INTO `userrelations` (`id`, `user_from`, `user_to`) VALUES
(2, 6, 1),
(3, 1, 6);

-- --------------------------------------------------------

--
-- Estrutura da tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `name` varchar(100) NOT NULL,
  `birthdate` date NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `work` varchar(100) DEFAULT NULL,
  `avatar` varchar(100) NOT NULL DEFAULT 'avatar.jpg',
  `cover` varchar(100) NOT NULL DEFAULT 'cover.jpg',
  `token` varchar(200) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `name`, `birthdate`, `city`, `work`, `avatar`, `cover`, `token`) VALUES
(1, 'b7@gmail.com', '$2y$10$5p/JG23TE0F9a.hgLZhNouz5KPR4kftjrjV6aZHrjtIua7ph69C2O', 'Carlos Alberto', '1902-12-11', 'Cuiabá', 'AW Regulagens Ltda.', 'c7db04545fb435472fe8ef3d6654f6e8.jpg', 'c009dbf9239845104089322375658a68.jpg', '577074112fd2baac994ec0043c98a7c5'),
(2, 'carlos@gmail.com', '$2y$10$i5iQElOAYZxniLwQHQH2gOhSFuOWxpa5t1sUXd6jgTFHPyYm/h2.y', 'Alberto Moraes', '1930-01-10', '', '', 'avatar.jpg', 'cover.jpg', '7bff8b4396e14a7b335f48d0f493cd00'),
(3, 'feliciano@gmail.com', '$2y$10$F57iro3e9uE6qcp3Z.2nx.KjUUC7YA8X.ttNs4UYiK0qml00LTD6G', 'João Feliciano', '1980-11-12', NULL, NULL, 'avatar.jpg', 'cover.jpg', '6f2f3bc9eaf71ea76b7ca94c5e4c8502'),
(4, 'pedro@gmail.com', '$2y$10$xVnqsu14neBM9MFf2aHyP.jVEJ23xXxq5SHT2d9gZQ5HA6JdW0FHq', 'Pedro Henrique', '1980-10-11', NULL, NULL, 'avatar.jpg', 'cover.jpg', '885d4612bebcc87f13642a6644d53026'),
(5, 'joao@gmail.com', '$2y$10$3fm7dwaKH4KRoW.aDoiFG.yxwW57bmKFRf15G3fy9djCDHdP9aZLq', 'JoaÃµ Pedro', '1980-04-20', NULL, NULL, 'avatar.jpg', 'cover.jpg', '7bdd402ce096f464d60ff6fbf7473edc'),
(6, 'ana@gmail.com', '$2y$10$W0esw6vcXfVBFuJJ.tIf0ePPE3LmH4PnfPNZAR2XN9.PkWFSbqsKS', 'Ana Paula', '1980-12-11', 'VÃ¡rzea Grande', 'ConcÃ³rdia Grill', 'avatar.jpg', 'cover.jpg', '5513445823a702c05ece8f621d2374e8');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `postcomments`
--
ALTER TABLE `postcomments`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `postlikes`
--
ALTER TABLE `postlikes`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `userrelations`
--
ALTER TABLE `userrelations`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `postcomments`
--
ALTER TABLE `postcomments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `postlikes`
--
ALTER TABLE `postlikes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `userrelations`
--
ALTER TABLE `userrelations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
