-- =========================
-- Reset & Setup
-- =========================
DROP SCHEMA IF EXISTS vod CASCADE;
CREATE SCHEMA vod;
SET search_path = vod;

CREATE TYPE credit_card_type AS ENUM ('VISA','MC','AMEX');

-- =========================
-- Parent Tables
-- =========================
CREATE TABLE customer (
  customerid        BIGINT GENERATED ALWAYS AS IDENTITY,
  firstname         VARCHAR(100) NOT NULL,
  lastname          VARCHAR(100) NOT NULL,
  email             VARCHAR(255) NOT NULL,
  phone             VARCHAR(30),
  addressline1      VARCHAR(120),
  addressline2      VARCHAR(120),
  city              VARCHAR(80),
  provincestate     VARCHAR(80),
  postalcode        VARCHAR(20),
  defaultcardnumber VARCHAR(25),
  defaultcardtype   credit_card_type,
  CONSTRAINT pk_customer PRIMARY KEY (customerid)
);

CREATE TABLE movie (
  movieid           BIGINT GENERATED ALWAYS AS IDENTITY,
  title             VARCHAR(200) NOT NULL,
  releasedate       DATE,
  durationminutes   INTEGER,
  rating            VARCHAR(20),
  isnewrelease      BOOLEAN NOT NULL DEFAULT FALSE,
  comingsoon        BOOLEAN NOT NULL DEFAULT FALSE,
  mostpopular       BOOLEAN NOT NULL DEFAULT FALSE,
  sdprice           NUMERIC(7,2),
  hdprice           NUMERIC(7,2),
  CONSTRAINT pk_movie PRIMARY KEY (movieid)
);

CREATE TABLE actor (
  actorid           BIGINT GENERATED ALWAYS AS IDENTITY,
  firstname         VARCHAR(100) NOT NULL,
  lastname          VARCHAR(100) NOT NULL,
  dateofbirth       DATE,
  email             VARCHAR(255),
  CONSTRAINT pk_actor PRIMARY KEY (actorid)
);

CREATE TABLE director (
  directorid        BIGINT GENERATED ALWAYS AS IDENTITY,
  firstname         VARCHAR(100) NOT NULL,
  lastname          VARCHAR(100) NOT NULL,
  dateofbirth       DATE,
  email             VARCHAR(255),
  CONSTRAINT pk_director PRIMARY KEY (directorid)
);

CREATE TABLE category (
  categoryid        BIGINT GENERATED ALWAYS AS IDENTITY,
  categoryname      VARCHAR(120) NOT NULL,
  parentcategoryid  BIGINT,
  CONSTRAINT pk_category PRIMARY KEY (categoryid)
);

CREATE TABLE advisory (
  advisoryid        BIGINT GENERATED ALWAYS AS IDENTITY,
  shortdescription  VARCHAR(120) NOT NULL,
  fulldescription   TEXT,
  CONSTRAINT pk_advisory PRIMARY KEY (advisoryid)
);

-- =========================
-- Children / Bridge Tables
-- =========================
CREATE TABLE rental (
  rentalid          BIGINT GENERATED ALWAYS AS IDENTITY,
  customerid        BIGINT NOT NULL,
  movieid           BIGINT NOT NULL,
  rentaldate        TIMESTAMPTZ NOT NULL DEFAULT now(),
  viewstartat       TIMESTAMPTZ,
  expiresat         TIMESTAMPTZ,
  pricepaid         NUMERIC(7,2),
  paidcardnumber    VARCHAR(25),
  paidcardtype      credit_card_type,
  customerrating    SMALLINT,
  CONSTRAINT pk_rental PRIMARY KEY (rentalid)
);

CREATE TABLE wishlist (
  customerid        BIGINT NOT NULL,
  movieid           BIGINT NOT NULL,
  dateadded         TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_wishlist PRIMARY KEY (customerid, movieid)
);

CREATE TABLE movieactor (
  movieid           BIGINT NOT NULL,
  actorid           BIGINT NOT NULL,
  rolename          VARCHAR(120),
  CONSTRAINT pk_movieactor PRIMARY KEY (movieid, actorid)
);

CREATE TABLE moviedirector (
  movieid           BIGINT NOT NULL,
  directorid        BIGINT NOT NULL,
  CONSTRAINT pk_moviedirector PRIMARY KEY (movieid, directorid)
);

CREATE TABLE moviecategory (
  movieid           BIGINT NOT NULL,
  categoryid        BIGINT NOT NULL,
  CONSTRAINT pk_moviecategory PRIMARY KEY (movieid, categoryid)
);

CREATE TABLE movieadvisory (
  movieid           BIGINT NOT NULL,
  advisoryid        BIGINT NOT NULL,
  CONSTRAINT pk_movieadvisory PRIMARY KEY (movieid, advisoryid)
);

-- =========================
-- ALTERs: UNIQUEs, FKs, CHECKs
-- =========================

-- Uniques
ALTER TABLE customer  ADD CONSTRAINT uq_customer_email  UNIQUE (email);
ALTER TABLE actor     ADD CONSTRAINT uq_actor_email     UNIQUE (email);
ALTER TABLE director  ADD CONSTRAINT uq_director_email  UNIQUE (email);
ALTER TABLE category  ADD CONSTRAINT uq_category_name   UNIQUE (categoryname);

-- Foreign Keys + actions
ALTER TABLE rental
  ADD CONSTRAINT fk_rental_customer
    FOREIGN KEY (customerid) REFERENCES customer(customerid)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT fk_rental_movie
    FOREIGN KEY (movieid)    REFERENCES movie(movieid)
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE wishlist
  ADD CONSTRAINT fk_wishlist_customer
    FOREIGN KEY (customerid) REFERENCES customer(customerid)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_wishlist_movie
    FOREIGN KEY (movieid)    REFERENCES movie(movieid)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE movieactor
  ADD CONSTRAINT fk_movieactor_movie
    FOREIGN KEY (movieid) REFERENCES movie(movieid)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_movieactor_actor
    FOREIGN KEY (actorid)  REFERENCES actor(actorid)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE moviedirector
  ADD CONSTRAINT fk_moviedirector_movie
    FOREIGN KEY (movieid)    REFERENCES movie(movieid)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_moviedirector_director
    FOREIGN KEY (directorid) REFERENCES director(directorid)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE moviecategory
  ADD CONSTRAINT fk_moviecategory_movie
    FOREIGN KEY (movieid)    REFERENCES movie(movieid)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_moviecategory_category
    FOREIGN KEY (categoryid) REFERENCES category(categoryid)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE movieadvisory
  ADD CONSTRAINT fk_movieadvisory_movie
    FOREIGN KEY (movieid)   REFERENCES movie(movieid)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_movieadvisory_advisory
    FOREIGN KEY (advisoryid) REFERENCES advisory(advisoryid)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Category self-FK
ALTER TABLE category
  ADD CONSTRAINT fk_category_parent
    FOREIGN KEY (parentcategoryid) REFERENCES category(categoryid)
    ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT ck_category_parent_not_self
    CHECK (parentcategoryid IS NULL OR parentcategoryid <> categoryid);

-- Movie checks
ALTER TABLE movie
  ADD CONSTRAINT ck_movie_duration_pos  CHECK (durationminutes IS NULL OR durationminutes > 0),
  ADD CONSTRAINT ck_movie_prices_nonneg CHECK ((sdprice IS NULL OR sdprice >= 0) AND (hdprice IS NULL OR hdprice >= 0)),
  ADD CONSTRAINT ck_movie_hd_ge_sd      CHECK (sdprice IS NULL OR hdprice IS NULL OR hdprice >= sdprice);

-- Rental checks
ALTER TABLE rental
  ADD CONSTRAINT ck_rental_price_nonneg CHECK (pricepaid IS NULL OR pricepaid >= 0),
  ADD CONSTRAINT ck_rental_rating_range CHECK (customerrating IS NULL OR customerrating BETWEEN 1 AND 5),
  ADD CONSTRAINT ck_rental_24h_window   CHECK (
    (viewstartat IS NULL AND expiresat IS NULL) OR
    (viewstartat IS NOT NULL AND expiresat = viewstartat + INTERVAL '24 hours')
  );

-- Customer format checks
ALTER TABLE customer
  ADD CONSTRAINT ck_customer_email_format
    CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
  ADD CONSTRAINT ck_customer_phone_format
    CHECK (phone IS NULL OR phone ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'),
  ADD CONSTRAINT ck_customer_postal_format
    CHECK (postalcode IS NULL OR postalcode ~* '^[A-Z][0-9][A-Z][ -]?[0-9][A-Z][0-9]$');

-- Card patterns
ALTER TABLE customer
  ADD CONSTRAINT ck_customer_default_card_matches_type CHECK (
    defaultcardtype IS NULL OR defaultcardnumber IS NULL OR
    CASE defaultcardtype
      WHEN 'VISA' THEN defaultcardnumber ~ '^(4[0-9]{12}([0-9]{3})?)$'
      WHEN 'MC'   THEN defaultcardnumber ~ '^((5[1-5][0-9]{14})|(2[2-7][0-9]{14}))$'
      WHEN 'AMEX' THEN defaultcardnumber ~ '^(3[47][0-9]{13})$'
    END
  );

ALTER TABLE rental
  ADD CONSTRAINT ck_rental_card_matches_type CHECK (
    paidcardtype IS NULL OR paidcardnumber IS NULL OR
    CASE paidcardtype
      WHEN 'VISA' THEN paidcardnumber ~ '^(4[0-9]{12}([0-9]{3})?)$'
      WHEN 'MC'   THEN paidcardnumber ~ '^((5[1-5][0-9]{14})|(2[2-7][0-9]{14}))$'
      WHEN 'AMEX' THEN paidcardnumber ~ '^(3[47][0-9]{13})$'
    END
  );

-- Helpful indexes
CREATE INDEX idx_rental_customer ON rental(customerid);
CREATE INDEX idx_rental_movie    ON rental(movieid);
CREATE INDEX idx_movie_title     ON movie(title);
CREATE INDEX idx_actor_name      ON actor(lastname, firstname);
CREATE INDEX idx_director_name   ON director(lastname, firstname);
