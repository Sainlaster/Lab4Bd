CREATE TYPE status AS ENUM('Жив', 'Мёртв', 'Неизвестно');
CREATE TYPE floor_status AS ENUM('Открыт', 'Закрыт');
CREATE TYPE gender AS ENUM('Мужской', 'Женский');
CREATE TYPE method_to_get_item AS ENUM('0.1', '0.001', '0.90', '0.5');
CREATE TYPE method_to_get_skill AS ENUM('1', '5','10');

CREATE TYPE fight_result AS ENUM('Игрок победил', 'Игрок проиграл');

CREATE TABLE Location (
  locationId serial PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  coordinate point NOT NULL
);

CREATE TABLE Inventory (
  inventoryId serial PRIMARY KEY,
  size INTEGER CHECK (size >= 50 AND size <= 100) NOT NULL
);

CREATE TABLE Player (
  playerId serial PRIMARY KEY,
  nickname VARCHAR(15) NOT NULL,
  hitpoints int CHECK (hitpoints >= 0 AND hitpoints <= 1000000) NOT NULL,
  experience int CHECK (experience >= 0 AND experience <= 100000) NOT NULL,
  gender gender NOT NULL,
  age int CHECK (age >= 0 AND age <= 150) NOT NULL,
  money int CHECK (money >= 0 AND money <= 1000000) NOT NULL,
  status status NOT NULL,
  inventoryId serial REFERENCES Inventory(inventoryId) NOT NULL
);

CREATE TABLE Item (
  itemId serial PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(150) NOT NULL,
  drop_method VARCHAR(150) NOT NULL,
  lvl int CHECK (lvl >= 1 AND lvl <= 100) NOT NULL
);

CREATE TABLE Armor (
  armorId serial PRIMARY KEY,
  itemId serial REFERENCES Item(itemId),
  defence_value int CHECK (defence_value >= 0 AND defence_value <= 10000) NOT NULL
);

CREATE TABLE Equipment (
  equipmentId serial PRIMARY KEY,
  itemId serial REFERENCES Item(itemId),
  defence_value int CHECK (defence_value >= 0 AND defence_value <= 500) NOT NULL
);

CREATE TABLE Weapons (
  weaponsId serial PRIMARY KEY,
  itemId serial REFERENCES Item(itemId),
  damage_value int CHECK (damage_value >= 1 AND damage_value <= 10000) NOT NULL
);

CREATE TABLE Inventory_Item (
  inventoryId serial REFERENCES Inventory(inventoryId),
  itemId serial REFERENCES Item(itemId)
);

CREATE TABLE Skill (
  skillId serial PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  type VARCHAR(25) NOT NULL,
  drop_method VARCHAR(200) NOT NULL,
  description VARCHAR(300) NOT NULL
);

CREATE TABLE Skill_Player (
  playerId serial REFERENCES Player(playerId),
  skillId serial REFERENCES Skill(skillId),
  killCounter INTEGER DEFAULT 0
);

CREATE TABLE Floor (
  floorId serial PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  climate VARCHAR(15) NOT NULL,
  main_town VARCHAR(30) NOT NULL,
  status floor_status NOT NULL,
  description VARCHAR(300) NOT NULL
);

CREATE TABLE Boss (
  bossId serial PRIMARY KEY,
  name VARCHAR(25) NOT NULL,
  hitpoints int CHECK (hitpoints >= 0 AND hitpoints <= 1000000),
  floor int REFERENCES Floor(floorId),
  spawn_point serial REFERENCES Location(locationId),
  features VARCHAR(300) NOT NULL,
  drop_item serial REFERENCES Item(itemId),
  teleport_ability bool NOT NULL,
  status status NOT NULL
);

CREATE TABLE Mob (
  mobId serial PRIMARY KEY,
  name VARCHAR(25) NOT NULL,
  hitpoints int CHECK (hitpoints >= 0 AND hitpoints <= 100000),
  floor int REFERENCES Floor(floorId),
  features VARCHAR(150) NOT NULL,
  drop_item serial REFERENCES Item(itemId) NOT NULL,
  spawn_point serial REFERENCES Location(locationId)
);

CREATE TABLE ExistMobs (
  exmobId serial PRIMARY KEY,
  mobId serial REFERENCES Mob(mobId),
  status status
);

CREATE TABLE Fight (
  fightId serial PRIMARY KEY,
  exmobId serial REFERENCES ExistMobs(exmobId) NOT NULL,
  playerId serial REFERENCES Player(playerId) NOT NULL,
  fightResult fight_result NOT NULL
);

CREATE TABLE BossFight (
  fightId serial PRIMARY KEY,
  bossId serial REFERENCES Boss(bossId) NOT NULL,
  playerId serial REFERENCES Player(playerId) NOT NULL,
  fightResult fight_result NOT NULL
);


CREATE OR REPLACE FUNCTION giveBossDrop()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT status FROM Player WHERE playerId = NEW.playerId)='Жив' and (SELECT status FROM boss WHERE bossid=NEW.bossid)='Жив' THEN
    IF (New.fightResult) = 'Игрок победил' THEN
      INSERT INTO Inventory_Item (inventoryId, itemId)
      VALUES ((SELECT inventoryId FROM Player WHERE playerId = NEW.playerId), (SELECT drop_item FROM boss WHERE bossid=NEW.bossid));
      UPDATE boss SET status='Мёртв' WHERE bossid=NEW.bossid;
      UPDATE Skill_Player SET killcounter=killcounter+1 WHERE playerId=NEW.playerId;
    ELSE
      UPDATE player SET status='Мёртв' WHERE playerid=NEW.playerId;
    END IF;
  ---ELSE DELETE FROM bossfight WHERE fightid=NEW.fightid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bossfight_trigger
AFTER INSERT ON BossFight
FOR EACH ROW
EXECUTE FUNCTION giveBossDrop();


CREATE OR REPLACE FUNCTION giveMobDrop()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT status FROM Player WHERE playerId = NEW.playerId)='Жив' and (SELECT status FROM existmobs WHERE exmobId=NEW.exmobId)='Жив' THEN
    IF (New.fightResult) = 'Игрок победил' THEN
      INSERT INTO Inventory_Item (inventoryId, itemId)
      VALUES ((SELECT inventoryId FROM Player WHERE playerId = NEW.playerId), (SELECT drop_item FROM mob WHERE mobid=(SELECT mobid FROM existmobs WHERE exmobid=NEW.exmobid)));
      UPDATE existmobs SET status='Мёртв' WHERE exmobId=NEW.exmobId;
      UPDATE Skill_Player SET killcounter=killcounter+1 WHERE playerId=NEW.playerId;
    ELSE
      UPDATE player SET status='Мёртв' WHERE playerid=NEW.playerId;
    END IF;
  ---ELSE DELETE FROM bossfight WHERE fightid=NEW.fightid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mobDrop_trigger
AFTER INSERT ON Fight
FOR EACH ROW
EXECUTE FUNCTION giveMobDrop();

CREATE OR REPLACE FUNCTION showPlayerInventory(pId INTEGER) 
RETURNS TABLE(
  name VARCHAR(50),
  description VARCHAR(150),
  drop_method VARCHAR(150)
)
AS $$
BEGIN
RETURN QUERY
SELECT item.name, item.description, item.drop_method FROM player JOIN inventory ON player.inventoryid=inventory.inventoryid JOIN inventory_item on inventory.inventoryid=inventory_item.inventoryid JOIN item ON inventory_item.itemid=item.itemid WHERE player.playerid=pID;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION showPlayerSkills(pId INTEGER) 
RETURNS TABLE(
  name VARCHAR(50),
  type VARCHAR(25),
  description VARCHAR(150),
  drop_method VARCHAR(150)
)
AS $$
BEGIN
RETURN QUERY
SELECT skill.name, skill.type, skill.description, skill.drop_method FROM skill_player JOIN skill ON skill_player.skillid=skill.skillid WHERE skill_player.playerid=pId;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION howToGetItem(itemName TEXT) 
RETURNS TEXT
AS $$
DECLARE
    result_text TEXT;
BEGIN
  IF (SELECT count(boss.name) FROM boss JOIN item ON itemName=item.name WHERE item.itemid=boss.drop_item)>0 THEN
    SELECT 'Чтобы получить этот предмет, вам надо убить '||boss.name||', находящегося на '||boss.floor||' этаже, в локации ' ||location.name  INTO result_text FROM boss JOIN item ON itemName=item.name JOIN location ON boss.spawn_point=location.locationid WHERE item.itemid=boss.drop_item;
  ELSEIF (SELECT count(mob.name) FROM mob JOIN item ON itemName=item.name WHERE item.itemid=mob.drop_item)>0 THEN
    SELECT 'Чтобы получить этот предмет, вам надо убить '||mob.name||', находящегося на '||mob.floor||' этаже, в локации ' ||location.name  INTO result_text FROM mob JOIN item ON itemName=item.name JOIN location ON mob.spawn_point=location.locationid WHERE item.itemid=mob.drop_item;
  END IF;
  RETURN result_text;
END;
$$ LANGUAGE PLPGSQL