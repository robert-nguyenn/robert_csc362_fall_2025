-- Lab 9: Triggers (min/max party size) and a trade procedure with a transaction.
DROP DATABASE IF EXISTS pokemon_league;
CREATE DATABASE pokemon_league;
USE pokemon_league;

CREATE TABLE trainers (
    trainer_id          INT AUTO_INCREMENT,
    trainer_name        VARCHAR(32),
    trainer_hometown    VARCHAR(32),
    PRIMARY KEY (trainer_id)
);

CREATE TABLE pokemon (
    pokemon_id          INT AUTO_INCREMENT,
    pokemon_species     VARCHAR(32),
    pokemon_level       INT,
    trainer_id          INT,
    pokemon_is_in_party BOOLEAN,
    PRIMARY KEY (pokemon_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers (trainer_id),
    CONSTRAINT minimum_pokemon_level CHECK (pokemon_level >= 1),
    CONSTRAINT maximum_pokemon_level CHECK (pokemon_level <= 100)
);

INSERT INTO trainers (trainer_name, trainer_hometown)
 VALUES ('Ash', 'Pallet Town'),
        ('Misty', 'Cerulean City'),
        ('Brock', 'Pewter City');

INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
 VALUES ('Pikachu', 58, 1, TRUE),
        ('Staryu',  44, 2, TRUE),
        ('Onyx',    52, 3, TRUE),
        ('Magicarp',12, 1, FALSE);

-- Trigger: block adding a 7th party member; block leaving a party empty.
DELIMITER //

CREATE TRIGGER trg_pokemon_bi_limit
BEFORE INSERT ON pokemon
FOR EACH ROW
BEGIN
  IF NEW.pokemon_is_in_party THEN
    IF (SELECT COUNT(*) FROM pokemon
        WHERE trainer_id = NEW.trainer_id AND pokemon_is_in_party = TRUE) >= 6 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot exceed 6 Pokémon in party.';
    END IF;
  END IF;
END;
//

CREATE TRIGGER trg_pokemon_bu_limit
BEFORE UPDATE ON pokemon
FOR EACH ROW
BEGIN
  -- Making NEW row be in party (including trainer change while TRUE)
  IF NEW.pokemon_is_in_party = TRUE THEN
    IF (SELECT COUNT(*) FROM pokemon
          WHERE trainer_id = NEW.trainer_id AND pokemon_is_in_party = TRUE
            AND NOT (pokemon_id = OLD.pokemon_id AND OLD.pokemon_is_in_party = TRUE
                     AND OLD.trainer_id = NEW.trainer_id)) >= 6 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot exceed 6 Pokémon in party.';
    END IF;
  END IF;

  -- Removing from OLD trainer’s party (TRUE→FALSE or trainer change)
  IF OLD.pokemon_is_in_party = TRUE THEN
    IF NEW.pokemon_is_in_party = FALSE OR NEW.trainer_id <> OLD.trainer_id THEN
      IF (SELECT COUNT(*) FROM pokemon
            WHERE trainer_id = OLD.trainer_id AND pokemon_is_in_party = TRUE) <= 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trainer must keep at least 1 Pokémon in party.';
      END IF;
    END IF;
  END IF;
END;
//

CREATE TRIGGER trg_pokemon_bd_limit
BEFORE DELETE ON pokemon
FOR EACH ROW
BEGIN
  IF OLD.pokemon_is_in_party = TRUE THEN
    IF (SELECT COUNT(*) FROM pokemon
        WHERE trainer_id = OLD.trainer_id AND pokemon_is_in_party = TRUE) <= 1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trainer must keep at least 1 Pokémon in party.';
    END IF;
  END IF;
END;
//
DELIMITER ;

-- Procedure: trade two party Pokémon atomically (both must be in party; swap owners).
DELIMITER //
CREATE OR REPLACE PROCEDURE trade_pokemon(IN pkmn_a INT, IN pkmn_b INT)
BEGIN
  DECLARE tA INT; DECLARE inPartyA BOOL;
  DECLARE tB INT; DECLARE inPartyB BOOL;

  DECLARE EXIT HANDLER FOR 45000 BEGIN ROLLBACK; END;

  START TRANSACTION;

  SELECT trainer_id, pokemon_is_in_party INTO tA, inPartyA
    FROM pokemon WHERE pokemon_id = pkmn_a FOR UPDATE;
  SELECT trainer_id, pokemon_is_in_party INTO tB, inPartyB
    FROM pokemon WHERE pokemon_id = pkmn_b FOR UPDATE;

  IF tA IS NULL OR tB IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trade failed: invalid pokemon_id.';
  END IF;
  IF tA = tB THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trade failed: Pokémon share the same trainer.';
  END IF;
  IF NOT inPartyA OR NOT inPartyB THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trade failed: both Pokémon must be in party.';
  END IF;

  UPDATE pokemon SET trainer_id = tB WHERE pokemon_id = pkmn_a;
  UPDATE pokemon SET trainer_id = tA WHERE pokemon_id = pkmn_b;

  COMMIT;
END;
//
DELIMITER ;

-- Tests (leave in file). Uncomment to run each case.
-- 1) Removing last party member should ERROR.
-- UPDATE pokemon SET pokemon_is_in_party = FALSE WHERE pokemon_species = 'Staryu';  -- Expected: ERROR

-- 2) Adding a 7th party member should ERROR (prep to 6, then attempt 7th).
INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
VALUES ('Bulbasaur', 20, 1, TRUE),
       ('Charmander', 21, 1, TRUE),
       ('Squirtle', 22, 1, TRUE),
       ('Pidgeotto', 23, 1, TRUE),
       ('Snorlax',   24, 1, TRUE);
-- INSERT INTO pokemon (pokemon_species, pokemon_level, trainer_id, pokemon_is_in_party)
-- VALUES ('Butterfree', 25, 1, TRUE);  -- Expected: ERROR

-- 3) Trading a non-party Pokémon should ERROR.
-- CALL trade_pokemon(
--   (SELECT pokemon_id FROM pokemon WHERE pokemon_species='Magicarp'),
--   (SELECT pokemon_id FROM pokemon WHERE pokemon_species='Onyx')
-- );  -- Expected: ERROR

-- 4) Valid trade should succeed.
-- CALL trade_pokemon(
--   (SELECT pokemon_id FROM pokemon WHERE pokemon_species='Pikachu'),
--   (SELECT pokemon_id FROM pokemon WHERE pokemon_species='Staryu')
-- );  -- Expected: OK