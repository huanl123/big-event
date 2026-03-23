CREATE DATABASE IF NOT EXISTS `big_event`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE `big_event`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `article`;
DROP TABLE IF EXISTS `category`;
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) NOT NULL COMMENT '用户名',
  `password` varchar(32) DEFAULT NULL COMMENT '密码',
  `nickname` varchar(10) DEFAULT '' COMMENT '昵称',
  `email` varchar(128) DEFAULT '' COMMENT '邮箱',
  `user_pic` varchar(128) DEFAULT '' COMMENT '头像',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

CREATE TABLE `category` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category_name` varchar(32) NOT NULL COMMENT '分类名称',
  `category_alias` varchar(32) NOT NULL COMMENT '分类别名',
  `create_user` int UNSIGNED NOT NULL COMMENT '创建人ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_category_user` (`create_user`) USING BTREE,
  CONSTRAINT `fk_category_user` FOREIGN KEY (`create_user`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `article` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(30) NOT NULL COMMENT '文章标题',
  `content` varchar(10000) NOT NULL COMMENT '文章内容',
  `cover_img` varchar(128) NOT NULL COMMENT '文章封面',
  `state` varchar(3) DEFAULT '草稿' COMMENT '文章状态',
  `category_id` int UNSIGNED DEFAULT NULL COMMENT '文章分类ID',
  `create_user` int UNSIGNED NOT NULL COMMENT '创建人ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_article_category` (`category_id`) USING BTREE,
  KEY `fk_article_user` (`create_user`) USING BTREE,
  CONSTRAINT `fk_article_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_article_user` FOREIGN KEY (`create_user`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `user` (`id`, `username`, `password`, `nickname`, `email`, `user_pic`, `create_time`, `update_time`)
VALUES
  (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', '', '', NOW(), NOW()),
  (2, 'huanl', 'e10adc3949ba59abbe56e057f20f883e', 'huanl', '', '', NOW(), NOW());

INSERT INTO `category` (`id`, `category_name`, `category_alias`, `create_user`, `create_time`, `update_time`)
VALUES
  (1, '默认分类', 'default', 1, NOW(), NOW()),
  (2, '随笔', 'essay', 1, NOW(), NOW());

INSERT INTO `article` (`id`, `title`, `content`, `cover_img`, `state`, `category_id`, `create_user`, `create_time`, `update_time`)
VALUES
  (1, '欢迎使用', '这是一篇示例文章，用于初始化数据。', 'https://example.com/cover.png', '已发布', 1, 1, NOW(), NOW());

SET FOREIGN_KEY_CHECKS = 1;
