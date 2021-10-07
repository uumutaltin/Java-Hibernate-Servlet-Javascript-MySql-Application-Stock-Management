-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 04 Eyl 2021, 14:26:32
-- Sunucu sürümü: 10.4.20-MariaDB
-- PHP Sürümü: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `depo_project`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BoxOrders` (IN `receipt` BIGINT)  BEGIN

	SELECT 
	box.box_receipt,
	cu.cu_id,
	cu.cu_name,
	cu.cu_surname, 
	cu.cu_status,
	pro.pro_id,
	pro.pro_title,
	pro.pro_sale_price,
	box.box_count,
	box.box_status
	FROM boxaction as box
	INNER JOIN customer as cu
	on box.box_customer_id = cu.cu_id
	INNER JOIN product as pro
	on pro.pro_id = box.box_product_id
	WHERE box.box_receipt = receipt;
	
	/*SELECT * FROM orders AS o WHERE o.box_receipt=1;*/
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `boxStatusChange` (IN `i` BIGINT)  BEGIN
	UPDATE boxaction SET box_status =1 WHERE box_receipt=i;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `customerSearch` (IN `customerName` VARCHAR(50))  BEGIN
	SELECT * FROM customer AS cu
	WHERE MATCH(cu.cu_name) AGAINST(customerName IN BOOLEAN MODE);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `JoinTableReceipt` (IN `i` BIGINT)  BEGIN
	SELECT DISTINCT r.receipt_id ,box_receipt as join_receipt, receipt_total as join_receipt_total, receipt_payment  FROM receipt as r
INNER JOIN receipt_boxaction as rb
on r.receipt_id = rb.Receipt_receipt_id
INNER JOIN boxaction as box
on box.box_id = rb.boxActions_box_id
INNER JOIN customer as c
on c.cu_id = box.customer_cu_id
WHERE cu_id = i;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payInSearch` (IN `i` VARCHAR(50))  BEGIN
	SELECT * FROM payin AS p
	WHERE MATCH(p.cName) AGAINST(i IN BOOLEAN MODE);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PayInTable` (IN `i` BIGINT)  BEGIN
	SELECT r.receipt_id,c.cu_id,c.cu_name,c.cu_surname,r.receipt_payment FROM receipt as r
INNER JOIN receipt_boxaction as rb
on r.receipt_id = rb.Receipt_receipt_id
INNER JOIN boxaction as box
on box.box_id = rb.boxActions_box_id
INNER JOIN customer as c
on c.cu_id = box.customer_cu_id;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `admin`
--

CREATE TABLE `admin` (
  `aid` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `admin`
--

INSERT INTO `admin` (`aid`, `email`, `name`, `password`) VALUES
(1, 'admin@mail.com', 'admin', '827ccb0eea8a706c4c34a16891f84e7b');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxaction`
--

CREATE TABLE `boxaction` (
  `box_id` int(11) NOT NULL,
  `box_count` int(11) NOT NULL,
  `box_customer_id` int(11) NOT NULL,
  `box_product_id` int(11) DEFAULT NULL,
  `box_receipt` bigint(20) NOT NULL,
  `box_status` int(11) NOT NULL,
  `customer_cu_id` int(11) DEFAULT NULL,
  `product_pro_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `boxaction`
--

INSERT INTO `boxaction` (`box_id`, `box_count`, `box_customer_id`, `box_product_id`, `box_receipt`, `box_status`, `customer_cu_id`, `product_pro_id`) VALUES
(1, 1, 1, 1, 527247211, 1, 1, 1),
(2, 2, 1, 2, 527247211, 1, 1, 2),
(3, 3, 2, 3, 827259836, 1, 2, 3),
(4, 1, 2, 2, 827259836, 1, 2, 2),
(5, 10, 1, 1, 831033192, 1, 1, 1),
(6, 1, 1, 1, 531749205, 1, 1, 1),
(11, 15, 1, 3, 836635516, 1, 1, 3),
(12, 1, 1, 1, 705626911, 1, 1, 1),
(13, 5, 1, 1, 206340929, 1, 1, 1),
(14, 1, 1, 1, 710520032, 1, 1, 1),
(15, 1, 1, 1, 914410590, 1, 1, 1),
(16, 1, 1, 2, 520833108, 1, 1, 2),
(17, 5, 2, 2, 21564352, 1, 2, 2),
(18, 3, 2, 2, 21564352, 1, 2, 2),
(19, 5, 2, 2, 623405339, 1, 2, 2),
(20, 10, 2, 1, 123957689, 0, 2, 1),
(21, 4, 3, 2, 863282098, 1, 3, 2),
(22, 1, 1, 1, 773239122, 1, 1, 1),
(23, 1, 1, 1, 952024125, 1, 1, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxcustomerproduc`
--

CREATE TABLE `boxcustomerproduc` (
  `box_id` int(11) NOT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `box_count` int(11) NOT NULL,
  `box_customer_id` int(11) NOT NULL,
  `box_product_id` int(11) NOT NULL,
  `box_receip` int(11) NOT NULL,
  `cu_address` varchar(255) DEFAULT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(255) DEFAULT NULL,
  `cu_id` int(11) NOT NULL,
  `cu_mobile` int(11) NOT NULL,
  `cu_password` int(11) NOT NULL,
  `cu_phone` int(11) NOT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL,
  `pro_amount` int(11) NOT NULL,
  `pro_detail` varchar(255) DEFAULT NULL,
  `pro_id` int(11) NOT NULL,
  `pro_purchase_price` int(11) NOT NULL,
  `pro_sale_price` int(11) NOT NULL,
  `pro_tax` int(11) NOT NULL,
  `pro_title` varchar(255) DEFAULT NULL,
  `pro_unit` int(11) NOT NULL,
  `box_receipt` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `boxorders`
--

CREATE TABLE `boxorders` (
  `box_receipt` bigint(20) NOT NULL,
  `box_count` int(11) NOT NULL,
  `box_status` int(11) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `pro_id` int(11) NOT NULL,
  `pro_sale_price` int(11) NOT NULL,
  `pro_title` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customer`
--

CREATE TABLE `customer` (
  `cu_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_password` varchar(32) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `customer`
--

INSERT INTO `customer` (`cu_id`, `cu_address`, `cu_code`, `cu_company_title`, `cu_email`, `cu_mobile`, `cu_name`, `cu_password`, `cu_phone`, `cu_status`, `cu_surname`, `cu_tax_administration`, `cu_tax_number`) VALUES
(1, '', 10688271, 'Ünvan', 'umut@mail.com', '123', 'Umut', '', '', 2, 'Altın', '', 123),
(2, '', 10714514, 'Ali - Ünvan', 'ali@mail.com', '321', 'Ali', '', '321', 1, 'Bilmem', '', 123),
(3, '', 141204559, 'Avukat', 'osman@mail.com', '123123', 'Osman', '', '', 2, 'Er', '', 12312);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `customersearch`
--

CREATE TABLE `customersearch` (
  `cu_id` int(11) NOT NULL,
  `cu_address` varchar(500) DEFAULT NULL,
  `cu_code` bigint(20) NOT NULL,
  `cu_company_title` varchar(255) DEFAULT NULL,
  `cu_email` varchar(500) DEFAULT NULL,
  `cu_mobile` varchar(255) DEFAULT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_phone` varchar(255) DEFAULT NULL,
  `cu_status` int(11) NOT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `cu_tax_administration` varchar(255) DEFAULT NULL,
  `cu_tax_number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payin`
--

CREATE TABLE `payin` (
  `payIn_id` int(11) NOT NULL,
  `cName` varchar(255) DEFAULT NULL,
  `payIn_amount` int(11) NOT NULL,
  `payIn_date` datetime DEFAULT NULL,
  `payment_detail` varchar(255) DEFAULT NULL,
  `receipt_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `payin`
--

INSERT INTO `payin` (`payIn_id`, `cName`, `payIn_amount`, `payIn_date`, `payment_detail`, `receipt_id`) VALUES
(1, 'Umut', 12, '2021-09-02 23:27:14', 'Su Ödeme Detayı', 9),
(2, 'Umut', 8, '2021-09-03 01:14:26', '', 10),
(3, 'Ali', 64, '2021-09-03 01:27:30', '', 11),
(4, 'Ali', 40, '2021-09-03 03:13:52', '', 12),
(5, 'Osman', 32, '2021-09-03 16:12:36', '', 13),
(6, 'Umut', 12, '2021-09-04 13:47:09', 'Fatura Detayı', 14);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payintable`
--

CREATE TABLE `payintable` (
  `receipt_id` int(11) NOT NULL,
  `box_receipt` bigint(20) NOT NULL,
  `cu_id` int(11) NOT NULL,
  `cu_name` varchar(255) DEFAULT NULL,
  `cu_surname` varchar(255) DEFAULT NULL,
  `payIn_amount` int(11) NOT NULL,
  `payIn_date` datetime DEFAULT NULL,
  `payment_detail` varchar(255) DEFAULT NULL,
  `receipt_total` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `payout`
--

CREATE TABLE `payout` (
  `payOut_id` int(11) NOT NULL,
  `payOutDetail` varchar(255) DEFAULT NULL,
  `payOutTitle` varchar(255) DEFAULT NULL,
  `payOutTotal` int(11) NOT NULL,
  `payOutType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `payout`
--

INSERT INTO `payout` (`payOut_id`, `payOutDetail`, `payOutTitle`, `payOutTotal`, `payOutType`) VALUES
(6, 'Cam Değişimi', 'Ofis Harcaması', 200, 0),
(7, 'Öğle Yemeği', 'Yemek', 38, 1),
(8, 'Otel Ücreti', 'Konaklama', 350, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `product`
--

CREATE TABLE `product` (
  `pro_id` int(11) NOT NULL,
  `pro_amount` int(11) NOT NULL,
  `pro_code` bigint(20) NOT NULL,
  `pro_detail` varchar(255) DEFAULT NULL,
  `pro_purchase_price` int(11) NOT NULL,
  `pro_sale_price` int(11) NOT NULL,
  `pro_tax` int(11) NOT NULL,
  `pro_title` varchar(255) DEFAULT NULL,
  `pro_unit` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `product`
--

INSERT INTO `product` (`pro_id`, `pro_amount`, `pro_code`, `pro_detail`, `pro_purchase_price`, `pro_sale_price`, `pro_tax`, `pro_title`, `pro_unit`) VALUES
(1, 8, 10738657, 'Su  Detay', 10, 12, 0, 'Su', 0),
(2, 6, 10754448, 'Pamuk Detay', 5, 8, 0, 'Pamuk', 0),
(3, 10, 141242610, 'Kırmızı Defter', 20, 32, 3, 'Defter', 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receipt`
--

CREATE TABLE `receipt` (
  `receipt_id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `receipt_payment` int(11) NOT NULL,
  `receipt_total` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `receipt`
--

INSERT INTO `receipt` (`receipt_id`, `date`, `receipt_payment`, `receipt_total`) VALUES
(1, '2021-09-01 23:14:36', 104, 104),
(2, '2021-09-01 23:14:39', 28, 28),
(3, '2021-09-02 00:17:20', 120, 120),
(4, '2021-09-02 00:29:16', 12, 12),
(5, '2021-09-02 01:50:46', 480, 480),
(6, '2021-09-02 21:00:31', 12, 12),
(7, '2021-09-02 21:12:28', 60, 60),
(8, '2021-09-02 22:22:05', 12, 12),
(9, '2021-09-02 23:26:57', 12, 12),
(10, '2021-09-03 01:14:14', 8, 8),
(11, '2021-09-03 01:27:04', 64, 64),
(12, '2021-09-03 01:56:55', 40, 40),
(13, '2021-09-03 16:11:18', 32, 32),
(14, '2021-09-04 13:13:29', 12, 12),
(15, '2021-09-04 13:44:36', 0, 12);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receipttotal`
--

CREATE TABLE `receipttotal` (
  `receipt_id` int(11) NOT NULL,
  `join_receipt` int(11) NOT NULL,
  `join_receipt_total` int(11) NOT NULL,
  `receipt_payment` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `receipt_boxaction`
--

CREATE TABLE `receipt_boxaction` (
  `Receipt_receipt_id` int(11) NOT NULL,
  `boxActions_box_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `receipt_boxaction`
--

INSERT INTO `receipt_boxaction` (`Receipt_receipt_id`, `boxActions_box_id`) VALUES
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(3, 5),
(4, 6),
(5, 11),
(6, 12),
(7, 13),
(8, 14),
(9, 15),
(10, 16),
(11, 17),
(11, 18),
(12, 19),
(13, 21),
(14, 22),
(15, 23);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`aid`);

--
-- Tablo için indeksler `boxaction`
--
ALTER TABLE `boxaction`
  ADD PRIMARY KEY (`box_id`),
  ADD KEY `FK1d88p8eiub1i0f9p1efyubnal` (`customer_cu_id`),
  ADD KEY `FK1hv1r61mcx34aspqiam5hgjrt` (`product_pro_id`);

--
-- Tablo için indeksler `boxcustomerproduc`
--
ALTER TABLE `boxcustomerproduc`
  ADD PRIMARY KEY (`box_id`);

--
-- Tablo için indeksler `boxorders`
--
ALTER TABLE `boxorders`
  ADD PRIMARY KEY (`box_receipt`);

--
-- Tablo için indeksler `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`cu_id`);
ALTER TABLE `customer` ADD FULLTEXT KEY `customerName` (`cu_name`);

--
-- Tablo için indeksler `customersearch`
--
ALTER TABLE `customersearch`
  ADD PRIMARY KEY (`cu_id`);

--
-- Tablo için indeksler `payin`
--
ALTER TABLE `payin`
  ADD PRIMARY KEY (`payIn_id`);
ALTER TABLE `payin` ADD FULLTEXT KEY `i` (`cName`);

--
-- Tablo için indeksler `payintable`
--
ALTER TABLE `payintable`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Tablo için indeksler `payout`
--
ALTER TABLE `payout`
  ADD PRIMARY KEY (`payOut_id`);

--
-- Tablo için indeksler `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`pro_id`);

--
-- Tablo için indeksler `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Tablo için indeksler `receipttotal`
--
ALTER TABLE `receipttotal`
  ADD PRIMARY KEY (`receipt_id`);

--
-- Tablo için indeksler `receipt_boxaction`
--
ALTER TABLE `receipt_boxaction`
  ADD UNIQUE KEY `UK_cy58347o0ysikco3j3iml7vx8` (`boxActions_box_id`),
  ADD KEY `FKo5hx6cyepp38ncb565nqk5vwy` (`Receipt_receipt_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `admin`
--
ALTER TABLE `admin`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `boxaction`
--
ALTER TABLE `boxaction`
  MODIFY `box_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Tablo için AUTO_INCREMENT değeri `customer`
--
ALTER TABLE `customer`
  MODIFY `cu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `customersearch`
--
ALTER TABLE `customersearch`
  MODIFY `cu_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `payin`
--
ALTER TABLE `payin`
  MODIFY `payIn_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `payout`
--
ALTER TABLE `payout`
  MODIFY `payOut_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `product`
--
ALTER TABLE `product`
  MODIFY `pro_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Tablo için AUTO_INCREMENT değeri `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `boxaction`
--
ALTER TABLE `boxaction`
  ADD CONSTRAINT `FK1d88p8eiub1i0f9p1efyubnal` FOREIGN KEY (`customer_cu_id`) REFERENCES `customer` (`cu_id`),
  ADD CONSTRAINT `FK1hv1r61mcx34aspqiam5hgjrt` FOREIGN KEY (`product_pro_id`) REFERENCES `product` (`pro_id`);

--
-- Tablo kısıtlamaları `receipt_boxaction`
--
ALTER TABLE `receipt_boxaction`
  ADD CONSTRAINT `FKlduw1msf59atv5ht3r8viehh4` FOREIGN KEY (`boxActions_box_id`) REFERENCES `boxaction` (`box_id`),
  ADD CONSTRAINT `FKo5hx6cyepp38ncb565nqk5vwy` FOREIGN KEY (`Receipt_receipt_id`) REFERENCES `receipt` (`receipt_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
