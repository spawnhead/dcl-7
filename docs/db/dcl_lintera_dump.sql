--
-- PostgreSQL database dump
--

\restrict ILOHr4Qm7MTSfszFVUQ2GBU4GV1FrpWugN4WwOzUXtHiNuz7UvQMhkQWoEUsL56

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: addday(date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.addday(d date, n integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN d + n; END;
$$;


--
-- Name: addday(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.addday(d timestamp without time zone, n integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN d + (n || ' days')::interval; END;
$$;


--
-- Name: addmonth(date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.addmonth(d date, n integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN d + (n || ' months')::interval; END;
$$;


--
-- Name: addmonth(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.addmonth(d timestamp without time zone, n integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN d + (n || ' months')::interval; END;
$$;


--
-- Name: addsecond(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.addsecond(d timestamp without time zone, n integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN d + (n || ' seconds')::interval; END;
$$;


--
-- Name: checkusermessagesondelete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.checkusermessagesondelete() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  message_id integer;
  message_creation_date date;
  delete_user_messages_period integer;
  _rec RECORD;
BEGIN
  SELECT stn_value INTO delete_user_messages_period
  FROM DCL_SETTING ds WHERE ds.stn_name = 'deleteUserMessagesPeriod';

  FOR _rec IN SELECT orm_id, orm_create_date FROM DCL_ORD_MESSAGE
  LOOP
    message_id := _rec.orm_id;
    message_creation_date := _rec.orm_create_date;
    IF ((CURRENT_DATE::date - message_creation_date::date) >= delete_user_messages_period) THEN
      DELETE FROM DCL_ORD_MESSAGE WHERE orm_id = message_id;
    END IF;
  END LOOP;

  FOR _rec IN SELECT pms_id, pms_create_date FROM DCL_PAY_MESSAGE
  LOOP
    message_id := _rec.pms_id;
    message_creation_date := _rec.pms_create_date;
    IF ((CURRENT_DATE::date - message_creation_date::date) >= delete_user_messages_period) THEN
      DELETE FROM DCL_PAY_MESSAGE WHERE pms_id = message_id;
    END IF;
  END LOOP;

  FOR _rec IN SELECT cms_id, cms_create_date FROM DCL_CON_MESSAGE
  LOOP
    message_id := _rec.cms_id;
    message_creation_date := _rec.cms_create_date;
    IF ((CURRENT_DATE::date - message_creation_date::date) >= delete_user_messages_period) THEN
      DELETE FROM DCL_CON_MESSAGE WHERE cms_id = message_id;
    END IF;
  END LOOP;

  FOR _rec IN SELECT ccm_id, ccm_create_date FROM DCL_CFC_MESSAGE
  LOOP
    message_id := _rec.ccm_id;
    message_creation_date := _rec.ccm_create_date;
    IF ((CURRENT_DATE::date - message_creation_date::date) >= delete_user_messages_period) THEN
      DELETE FROM DCL_CFC_MESSAGE WHERE ccm_id = message_id;
    END IF;
  END LOOP;
END
$$;


--
-- Name: date2str(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.date2str(p_data date) RETURNS TABLE(strdate character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  d_year integer;
  d_month integer;
  d_day integer;
BEGIN
  strdate := '';

  d_year := extract(YEAR from p_data);
  d_month := extract(MONTH from p_data);
  d_day := extract(DAY from p_data);
  if (D_DAY < 10) THEN
  strdate := '0' || cast(D_DAY as varchar(2));
  ELSE
  strdate := cast(D_DAY as varchar(2));
  END IF;
  if (D_MONTH < 10) THEN
  strdate := strDate || '.' || '0' || cast(D_MONTH as varchar(2));
  ELSE
  strdate := strDate || '.' || cast(D_MONTH as varchar(2));
  END IF;
  strdate := strDate || '.' || cast(D_YEAR as varchar(4));

  RETURN NEXT;
END
$$;


--
-- Name: dcl_1c_number_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_1c_number_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    if (new.id is null ) then
    new.id = nextval('dcl_1c_number_history_generator');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_account_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_account_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  CTR_ID INTEGER;
  DOUBLE_ACCOUNT INTEGER;
BEGIN
  if ( old.acc_account is not null ) then
    SELECT count(ctr_id) INTO double_account from dcl_contractor ctr
    where ctr.ctr_id != old.ctr_id and
          ctr.ctr_double_account is not null;

    if ( double_account = 1 ) then
      SELECT ctr_id INTO ctr_id from dcl_contractor ctr
      where ctr.ctr_id != old.ctr_id and
            ctr.ctr_double_account is not null;

      update dcl_contractor set ctr_double_account = null where ctr_id = ctr_id;
  END IF;
  END IF;
RETURN OLD;
END
$$;


--
-- Name: dcl_account_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_account_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
  CTR_ID INTEGER;
  DOUBLE_ACCOUNT INTEGER;
BEGIN
  IF (NEW.acc_ID IS NULL) THEN
    NEW.acc_ID = nextval('gen_dcl_account_id');
  ELSE
    ID = nextval('gen_dcl_account_id');
    IF ( ID < NEW.acc_ID ) THEN
      ID = nextval('gen_dcl_account_id');
  END IF;
  END IF;

  if ( new.acc_account is not null ) then
    SELECT count(acc_id) INTO double_account from dcl_account acc
    where acc.acc_account = new.acc_account and
          acc.ctr_id != new.ctr_id;

    if ( double_account > 0 ) then
      FOR ctr_id IN select ctr_id
        from dcl_contractor ctr,
        dcl_account acc
        where acc.ctr_id = ctr.ctr_id and
        acc.acc_account = new.acc_account and
        ctr.ctr_double_account is null
      LOOP
        update dcl_contractor set ctr_double_account = 1 where ctr_id = ctr_id;
      END LOOP;
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_account_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_account_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  CTR_ID INTEGER;
  DOUBLE_ACCOUNT INTEGER;
BEGIN
  if ( old.acc_account is not null ) then
    SELECT count(ctr_id) INTO double_account from dcl_contractor ctr
    where ctr.ctr_id != old.ctr_id and
          ctr.ctr_double_account is not null;

    if ( double_account = 1 ) then
      SELECT ctr_id INTO ctr_id from dcl_contractor ctr
      where ctr.ctr_id != old.ctr_id and
            ctr.ctr_double_account is not null;

      update dcl_contractor set ctr_double_account = null where ctr_id = ctr_id;
  END IF;
  END IF;

  if ( new.acc_account is not null ) then
    SELECT count(acc_id) INTO double_account from dcl_account acc
    where acc.acc_account = new.acc_account and
          acc.ctr_id != new.ctr_id;

    if ( double_account > 0 ) then
      FOR ctr_id IN select ctr_id
        from dcl_contractor ctr,
        dcl_account acc
        where acc.ctr_id = ctr.ctr_id and
        acc.acc_account = new.acc_account and
        ctr.ctr_double_account is null
      LOOP
        update dcl_contractor set ctr_double_account = 1 where ctr_id = ctr_id;
      END LOOP;
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_action_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_action_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ACT_ID IS NULL) THEN
    NEW.ACT_ID = nextval('gen_dcl_action_id');
  ELSE
    ID = nextval('gen_dcl_action_id');
    IF ( ID < NEW.ACT_ID ) THEN
      ID = nextval('gen_dcl_action_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_add_info_service_guarantee(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_add_info_service_guarantee(p_lps_id integer) RETURNS TABLE(shp_date character varying, con_number character varying, con_date character varying, spc_number character varying, spc_date character varying, con_seller_id integer, con_seller character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_shp_date_local DATE; v_con_date_local DATE; v_spc_date_local DATE;
BEGIN
  shp_date := NULL; con_number := NULL; con_date := NULL;
  spc_number := NULL; spc_date := NULL; con_seller_id := NULL; con_seller := NULL;
  SELECT shp.shp_date, con.con_number, con.con_date, spc.spc_number, spc.spc_date,
         sln.sln_id, sln.sln_name
    INTO v_shp_date_local, con_number, v_con_date_local, spc_number, v_spc_date_local,
         con_seller_id, con_seller
    FROM dcl_shipping shp
    JOIN dcl_shp_list_produce lps ON shp.shp_id = lps.shp_id
    JOIN dcl_con_list_spec spc ON spc.spc_id = shp.spc_id
    JOIN dcl_contract con ON con.con_id = spc.con_id
    LEFT JOIN dcl_seller sln ON sln.sln_id = con.sln_id
    WHERE lps.lps_id = p_lps_id;
  IF (v_shp_date_local IS NOT NULL) THEN
    SELECT d.strdate INTO shp_date FROM date2str(v_shp_date_local) d;
  END IF;
  IF (v_con_date_local IS NOT NULL) THEN
    SELECT d.strdate INTO con_date FROM date2str(v_con_date_local) d;
  END IF;
  IF (v_spc_date_local IS NOT NULL) THEN
    SELECT d.strdate INTO spc_date FROM date2str(v_spc_date_local) d;
  END IF;
  RETURN NEXT;
END $$;


--
-- Name: dcl_asm_count_by_prd_id_asm_id(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_asm_count_by_prd_id_asm_id(p_prd_id integer, p_stf_id integer, p_ord_id integer, p_asm_id integer) RETURNS TABLE(trn_produce_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_opr_id INTEGER;
  v_apr_count DECIMAL(15,2);
  v_ord_id_local INTEGER;
  _rec RECORD;
BEGIN
  trn_produce_count := 0;
  FOR _rec IN SELECT apr.opr_id, apr.apr_count
    FROM dcl_assemble asm, dcl_asm_list_produce apr
    WHERE asm.asm_id = p_asm_id AND asm.stf_id = p_stf_id
      AND apr.asm_id = asm.asm_id AND apr.prd_id = p_prd_id
  LOOP
    v_opr_id := _rec.opr_id;
    v_apr_count := _rec.apr_count;
    IF (p_ord_id IS NOT NULL AND v_opr_id IS NOT NULL) THEN
      SELECT opr.ord_id INTO v_ord_id_local FROM dcl_ord_list_produce opr WHERE opr.opr_id = v_opr_id;
      IF (p_ord_id = v_ord_id_local) THEN
        trn_produce_count := trn_produce_count + v_apr_count;
      END IF;
    ELSIF (p_ord_id IS NULL) THEN
      trn_produce_count := trn_produce_count + v_apr_count;
    END IF;
  END LOOP;
  RETURN NEXT;
END $$;


--
-- Name: dcl_asm_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_asm_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.APR_ID IS NULL) THEN
    NEW.APR_ID = nextval('gen_dcl_asm_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_asm_list_produce_id');
        IF ( ID < NEW.APR_ID ) THEN
          ID = nextval('gen_dcl_asm_list_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_asm_list_produce_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_asm_list_produce_load(p_apr_id_in integer) RETURNS TABLE(apr_id integer, asm_id integer, prd_id integer, stf_id integer, stf_name character varying, opr_id integer, apr_count numeric, ctn_number character varying, apr_occupied integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  apr_id := NULL; asm_id := NULL; prd_id := NULL; stf_id := NULL;
  stf_name := NULL; opr_id := NULL; apr_count := NULL; apr_occupied := NULL; ctn_number := NULL;
  SELECT a.apr_id, a.asm_id, a.prd_id, s.stf_id, a.opr_id, a.apr_count,
    (SELECT v.apr_id FROM dcl_occupied_apr_produce_v v WHERE v.apr_id = a.apr_id)
    INTO apr_id, asm_id, prd_id, stf_id, opr_id, apr_count, apr_occupied
    FROM dcl_assemble s, dcl_asm_list_produce a
    WHERE s.asm_id = a.asm_id AND a.apr_id = p_apr_id_in;
  IF (opr_id IS NOT NULL) THEN
    SELECT l.stf_id INTO stf_id FROM dcl_ord_list_produce_load(opr_id) l;
  END IF;
  IF (stf_id IS NOT NULL) THEN
    SELECT sc.stf_name INTO stf_name FROM dcl_stuff_category sc WHERE sc.stf_id = stf_id;
    SELECT cn.ctn_number INTO ctn_number FROM dcl_catalog_number cn WHERE cn.stf_id = stf_id AND cn.prd_id = prd_id;
  END IF;
  RETURN NEXT;
END $$;


--
-- Name: dcl_asm_list_produces_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_asm_list_produces_load(p_asm_id_in integer) RETURNS TABLE(apr_id integer, asm_id integer, prd_id integer, stf_id integer, stf_name character varying, opr_id integer, apr_count numeric, ctn_number character varying, apr_occupied integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  asm_id = p_asm_id_in;

  FOR apr_id IN select apr_id from dcl_asm_list_produce apr where apr.asm_id = p_asm_id_in order by apr_id
  LOOP
    select
      apr_id,
      asm_id,
      prd_id,
      stf_id,
      stf_name,
      opr_id,
      apr_count,
      apr_occupied,
      ctn_number
    from dcl_asm_list_produce_load(apr_id)
    into apr_id,
         asm_id,
         prd_id,
         stf_id,
         stf_name,
         opr_id,
         apr_count,
         apr_occupied,
         ctn_number
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_assemble_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_assemble_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ASM_ID IS NULL) THEN
    NEW.ASM_ID = nextval('gen_dcl_assemble_id');
  ELSE
        ID = nextval('gen_dcl_assemble_id');
        IF ( ID < NEW.ASM_ID ) THEN
          ID = nextval('gen_dcl_assemble_id');
  END IF;
  END IF;
  new.asm_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.asm_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_assemble_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_assemble_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.asm_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_assemble_filter(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_assemble_filter(p_asm_number character varying, p_date_begin character varying, p_date_end character varying, p_asm_user character varying) RETURNS TABLE(asm_id integer, asm_number character varying, asm_date date, asm_block smallint, asm_user character varying, asm_type smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_date_begin DATE;
  v_date_end DATE;
  v_number VARCHAR;
  v_user VARCHAR;
BEGIN
  v_date_begin := CASE WHEN p_date_begin IS NOT NULL AND p_date_begin != '' THEN p_date_begin::DATE ELSE NULL END;
  v_date_end := CASE WHEN p_date_end IS NOT NULL AND p_date_end != '' THEN p_date_end::DATE ELSE NULL END;
  v_number := UPPER(p_asm_number);
  v_user := UPPER(p_asm_user);

  RETURN QUERY
    SELECT a.asm_id, a.asm_number, a.asm_date, a.asm_block,
           (SELECT ul.usr_surname || ' ' || ul.usr_name FROM dcl_user_language ul WHERE ul.usr_id = a.usr_id_create AND ul.lng_id = 1)::VARCHAR(50) AS asm_user,
           a.asm_type
    FROM dcl_assemble a
    WHERE (v_date_begin IS NULL OR a.asm_date >= v_date_begin)
      AND (v_date_end IS NULL OR a.asm_date <= v_date_end)
      AND (v_user IS NULL OR v_user = '' OR (SELECT UPPER(u.usr_surname || ' ' || u.usr_name) FROM dcl_user_language u WHERE u.usr_id = a.usr_id_create AND u.lng_id = 1) LIKE '%' || v_user || '%')
      AND (v_number IS NULL OR v_number = '' OR UPPER(a.asm_number) LIKE '%' || v_number || '%')
    ORDER BY a.asm_date DESC, a.asm_number DESC;
END;
$$;


--
-- Name: dcl_assemble_insert(date, character varying, integer, integer, integer, integer, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_assemble_insert(p_asm_date date, p_asm_number character varying, p_asm_count integer, p_prd_id integer, p_stf_id integer, p_opr_id integer, p_asm_type smallint) RETURNS TABLE(asm_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_assemble (
      p_asm_number,
      p_asm_date,
      p_asm_count,
      p_prd_id,
      p_stf_id,
      p_opr_id,
      p_asm_type
    )
    values (
     p_asm_number,
     p_asm_date,
     p_asm_count,
     p_prd_id,
     p_stf_id,
     p_opr_id,
     p_asm_type
    )
    returning asm_id into asm_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_assemble_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_assemble_load(p_asm_id_in integer) RETURNS TABLE(asm_id integer, usr_id_create integer, usr_id_edit integer, asm_create_date timestamp without time zone, asm_edit_date timestamp without time zone, asm_number character varying, asm_date date, asm_block smallint, asm_count integer, prd_id integer, stf_id integer, opr_id integer, asm_type smallint, asm_occupied integer, ord_number character varying, ord_date date, ord_info character varying, ord_info_contractor_for character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ord_id integer;
  contractors_for varchar(1000);
  str_date varchar(20);
  _rec RECORD;
BEGIN
  asm_id = null;
  usr_id_create = null;
  usr_id_edit = null;
  asm_create_date = null;
  asm_edit_date = null;
  asm_number = null;
  asm_date = null;
  asm_block = null;
  asm_count = null;
  prd_id = null;
  stf_id = null;
  opr_id = null;
  asm_type = null;
  asm_occupied = null;
  ord_number = null;
  ord_date = null;
  ord_info = '';
  ord_info_contractor_for = '';

  select
    asm_id,
    usr_id_create,
    usr_id_edit,
    asm_create_date,
    asm_edit_date,
    asm_number,
    asm_date,
    asm_block,
    asm_count,
    prd_id,
    stf_id,
    opr_id,
    asm_type,
    (select asm_id from DCL_OCCUPIED_ASM_PRODUCE_V where asm_id = asm.asm_id)
  from dcl_assemble asm
  where asm_id = p_asm_id_in
  into
    asm_id,
    usr_id_create,
    usr_id_edit,
    asm_create_date,
    asm_edit_date,
    asm_number,
    asm_date,
    asm_block,
    asm_count,
    prd_id,
    stf_id,
    opr_id,
    asm_type,
    asm_occupied
  ;

  -- assemble
  if ( asm_type = 0 ) then
  FOR _rec IN select distinct ord_id, ord_number, ord_date, ord_date_str, contractors_for from dcl_get_ord_info_for_asm(asm_id)
  LOOP
    ord_id := _rec.ord_id;
    ord_number := _rec.ord_number;
    ord_date := _rec.ord_date;
    str_date := _rec.str_date;
    contractors_for := _rec.contractors_for;
      ord_info = ord_info || ord_number || 'from' || str_date || '<br>';
      ord_info_contractor_for = ord_info_contractor_for || contractors_for;
  END LOOP;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_attachment_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_attachment_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ATT_ID IS NULL) THEN
    NEW.ATT_ID = nextval('gen_dcl_attachment_id');
  ELSE
        ID = nextval('gen_dcl_attachment_id');
        IF ( ID < NEW.ATT_ID ) THEN
          ID = nextval('gen_dcl_attachment_id');
  END IF;
  END IF;

  NEW.att_create_date = CURRENT_TIMESTAMP;
  new.usr_id = get_context('usr_id');
  if ( new.usr_id is null ) then
    select usr_id from dcl_user where usr_code = '000' into new.usr_id;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_begin_of_next_week(timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_begin_of_next_week(t_indate timestamp without time zone) RETURNS TABLE(t_begin_of_next_week timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
  T DATE;
begin
  -- ISO8601 first day of week is Monday
  t = ADDDAY(T_INDATE, 8 - (EXTRACT (weekday from t_indate - 1) + 1));
  T_BEGIN_OF_NEXT_WEEK = t;

  RETURN NEXT;
end
$$;


--
-- Name: dcl_blank_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_blank_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.BLN_ID IS NULL) THEN
    NEW.BLN_ID = nextval('gen_dcl_blank_id');
  ELSE
        ID = nextval('gen_dcl_blank_id');
        IF ( ID < NEW.BLN_ID ) THEN
          ID = nextval('gen_dcl_blank_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_blank_image_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_blank_image_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.BIM_ID IS NULL) THEN
    NEW.BIM_ID = nextval('gen_dcl_blank_image_id');
  ELSE
        ID = nextval('gen_dcl_blank_image_id');
        IF ( ID < NEW.BIM_ID ) THEN
          ID = nextval('gen_dcl_blank_image_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_blank_insert(smallint, character varying, integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_blank_insert(p_bln_type smallint, p_bln_name character varying, p_lng_id integer, p_bln_charset character varying, p_bln_preamble character varying, p_bln_note character varying, p_bln_usage character varying) RETURNS TABLE(bln_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_blank (
    p_bln_type,
    p_bln_name,
    p_lng_id,
    p_bln_charset,
    p_bln_preamble,
    p_bln_note,
    p_bln_usage
  )
  values (
    p_bln_type,
    p_bln_name,
    p_lng_id,
    p_bln_charset,
    p_bln_preamble,
    p_bln_note,
    p_bln_usage
  )
  returning bln_id into bln_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_blank_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_blank_load(p_bln_id_in integer) RETURNS TABLE(bln_id integer, bln_type smallint, bln_name character varying, bln_charset character varying, lng_id integer, lng_name character varying, bln_preamble character varying, bln_note character varying, bln_usage character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  bln_id = null;
  bln_type = null;
  bln_name = null;
  bln_charset = null;
  lng_id = null;
  lng_name = null;
  bln_preamble = null;
  bln_note = null;
  bln_usage = null;

  select bln.bln_id,
         bln.bln_type,
         bln.bln_name,
         lng.lng_id,
         lng.lng_name,
         bln.bln_charset,
         bln.bln_preamble,
         bln.bln_note,
         bln.bln_usage
  from dcl_blank bln
       left join dcl_language lng on lng.lng_id = bln.lng_id
  where bln.bln_id = p_bln_id_in
  into   bln_id,
         bln_type,
         bln_name,
         lng_id,
         lng_name,
         bln_charset,
         bln_preamble,
         bln_note,
         bln_usage;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_blanks_load(smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_blanks_load(p_bln_type_in smallint) RETURNS TABLE(bln_id integer, bln_type smallint, bln_name character varying, bln_images character varying, bln_charset character varying, bln_language character varying, bln_preamble character varying, bln_note character varying, bln_usage character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_checktype SMALLINT;
  v_bln_id_save INTEGER; v_bln_type_save SMALLINT; v_bln_name_save VARCHAR(50);
  v_bln_charset_save VARCHAR(20); v_bln_language_save VARCHAR(32);
  v_bln_preamble_save VARCHAR(1000); v_bln_note_save VARCHAR(1000);
  v_bln_usage_save VARCHAR(1000);
  _rec RECORD;
  _rec2 RECORD;
BEGIN
  v_checktype := -1;
  FOR _rec IN SELECT b.bln_id FROM dcl_blank b
    WHERE (p_bln_type_in IS NULL OR b.bln_type = p_bln_type_in)
    ORDER BY b.bln_type
  LOOP
    bln_id := _rec.bln_id;
    SELECT bl.bln_type, bl.bln_name, bl.lng_name, bl.bln_charset,
           bl.bln_preamble, bl.bln_note, bl.bln_usage
      INTO bln_type, bln_name, bln_language, bln_charset, bln_preamble, bln_note, bln_usage
      FROM dcl_blank_load(bln_id) bl;
    IF (v_checktype != bln_type AND v_checktype != -1) THEN
      v_bln_id_save := bln_id; v_bln_type_save := bln_type; v_bln_name_save := bln_name;
      v_bln_language_save := bln_language; v_bln_charset_save := bln_charset;
      v_bln_preamble_save := bln_preamble; v_bln_note_save := bln_note; v_bln_usage_save := bln_usage;
      bln_id := NULL; bln_type := NULL; bln_name := NULL; bln_language := NULL;
      bln_images := NULL; bln_charset := NULL; bln_preamble := NULL; bln_note := NULL; bln_usage := NULL;
      RETURN NEXT;
      bln_id := v_bln_id_save; bln_type := v_bln_type_save; bln_name := v_bln_name_save;
      bln_language := v_bln_language_save; bln_charset := v_bln_charset_save;
      bln_preamble := v_bln_preamble_save; bln_note := v_bln_note_save; bln_usage := v_bln_usage_save;
    END IF;
    v_checktype := bln_type;
    SELECT bi.bln_images INTO bln_images FROM dcl_get_blank_images_in_str(bln_id) bi;
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_calculation_state(integer, integer, smallint, smallint, integer, integer, smallint, date, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_calculation_state(p_ctr_id integer, p_cur_id integer, p_not_include_zero smallint, p_include_all_specs smallint, p_sln_id_in integer, p_con_id_in integer, p_not_show_annul smallint, p_earliest_doc_date date, p_usr_id integer, p_dep_id integer) RETURNS TABLE(con_id integer, con_number character varying, con_date date, con_currency character varying, con_annul smallint, con_annul_date date, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_add_pay_cond character varying, spc_delivery_cond character varying, spc_delivery_date date, spc_delivery_date_math date, spc_annul smallint, spc_annul_date date, pay_id integer, pay_date date, pay_summ numeric, pay_block smallint, shp_id integer, shp_number character varying, shp_date date, shp_summ numeric, itog_line smallint, rest_doc_line smallint, shp_currency character varying, pay_currency character varying, ctr_name character varying, ctr_line smallint, pay_closed integer, shp_closed integer, managers character varying, stuff_categories character varying, count_day integer, shp_date_expiration date, shp_letter1_date date, shp_letter2_date date, shp_letter3_date date, shp_complaint_in_court_date date, shp_comment character varying, shp_original smallint, pay_comment character varying, shp_no_act smallint, only_spec smallint, no_shipping smallint, pay_date_expiration date, alone_shipping smallint, con_comment_flag integer, spc_comment_flag integer, dates_for_produce_on_storage character varying, shp_closed_correct integer, get_pay_expiration_from_proc smallint, spc_letter1_date date, spc_letter2_date date, spc_letter3_date date, spc_complaint_in_court_date date, spc_pay_expiration integer, spc_whose_id integer, spc_whose character varying, usr_id_list_con character varying, dep_id_list_con character varying, usr_id_list_shp character varying, con_final_date date, con_day_before_final integer, con_incorrect_final_date smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  max_doc_for_spc_count integer;
  shp_count integer;
  pay_count integer;
  idx integer;
  curr_pay integer;
  curr_shp integer;
  spc_summ_itog decimal(15,2);
  pay_summ_itog decimal(15,2);
  shp_summ_itog decimal(15,2);
  cur_itog varchar(10);
  ctr_name_check varchar(200);
  con_id_saved integer;
  con_number_saved varchar(200);
  con_date_saved date;
  con_currency_saved varchar(10);
  con_annul_saved smallint;
  con_annul_date_saved date;
  spc_id_saved integer;
  spc_number_saved varchar(50);
  spc_date_saved date;
  spc_summ_saved decimal(15,2);
  spc_add_pay_cond_saved varchar(2000);
  spc_delivery_cond_saved varchar(2000);
  spc_delivery_date_saved date;
  spc_annul_saved smallint;
  spc_annul_date_saved date;
  ctr_id_local integer;
  spc_group_delivery smallint;
  spc_pay_summ decimal(15,2);
  spc_shp_summ decimal(15,2);
  take_part_spc smallint;
  have_shp_or_pay integer;
  contractor_sort varchar(200);
  max_pay_date_for_shp date;
  shp_montage smallint;
  con_comment_flag_saved integer;
  spc_comment_flag_saved integer;
  dates_for_produce_on_storage_saved varchar(200);
  include_other_pay_shp smallint;
  spc_letter1_date_saved date;
  spc_letter2_date_saved date;
  spc_letter3_date_saved date;
  spc_complaint_in_court_date_saved date;
  usr_id_list_con_saved varchar(200);
  dep_id_list_con_saved varchar(200);
  spc_id_shp integer;
  con_final_date_saved date;
  con_day_before_final_saved integer;
  con_incorrect_final_date_saved smallint;
  _rec RECORD;
  _rec2 RECORD;
BEGIN
  -- not include payments and shipping without specification
  include_other_pay_shp := 1;
  if ( ( p_usr_id is not null and p_usr_id != -1 ) or ( p_dep_id is not null and p_dep_id != -1 ) ) THEN
  include_other_pay_shp := null;
  END IF;
  ctr_name_check := 'FirstCheckContractor';
  FOR _rec IN select p_ctr_id, ctr_name, upper(ctr_name) as contractor_sort from dcl_contractor where p_ctr_id = p_ctr_id or p_ctr_id = -1 order by contractor_sort
  LOOP
    ctr_id_local := _rec.p_ctr_id;
    ctr_name := _rec.ctr_name;
    contractor_sort := _rec.contractor_sort;
  alone_shipping := null;

  FOR _rec2 IN select con.con_id, con.con_number, con.con_date, con.con_annul, con.con_annul_date, con.con_final_date, LENGTH(con.con_comment), cur.cur_name, spc.spc_id, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_group_delivery, spc.spc_add_pay_cond, spc.spc_delivery_cond, spc.spc_delivery_date, spc.spc_annul, spc.spc_annul_date, spc.spc_letter1_date, spc.spc_letter2_date, spc.spc_letter3_date, spc.spc_complaint_in_court_date, LENGTH(spc.spc_comment), spc.usr_id from dcl_contract con, dcl_con_list_spec spc, dcl_currency cur where con.ctr_id = ctr_id_local and spc.con_id = con.con_id and cur.cur_id = con.cur_id and (p_sln_id_in is null or con.sln_id = p_sln_id_in ) and (p_cur_id is null or cur.cur_id = p_cur_id) and (p_con_id_in is null or p_con_id_in = -1 or con.con_id = p_con_id_in ) and ( p_not_show_annul is null or ( p_not_show_annul is not null and con.con_annul is null and spc.spc_annul is null ) ) and ( p_usr_id = -1 or p_usr_id is null or spc.usr_id = p_usr_id ) and ( p_dep_id = -1 or p_dep_id is null or p_dep_id = ( select p_dep_id from dcl_user where p_usr_id = spc.usr_id ) ) order by spc.spc_date DESC
  LOOP
    con_id := _rec2.con_id;
    con_number := _rec2.con_number;
    con_date := _rec2.con_date;
    con_annul := _rec2.con_annul;
    con_annul_date := _rec2.con_annul_date;
    con_final_date := _rec2.con_final_date;
    con_comment_flag := _rec2.cur_name;
    con_currency := _rec2.spc_id;
    spc_id := _rec2.spc_number;
    spc_number := _rec2.spc_date;
    spc_date := _rec2.spc_summ;
    spc_summ := _rec2.spc_group_delivery;
    spc_group_delivery := _rec2.spc_add_pay_cond;
    spc_add_pay_cond := _rec2.spc_delivery_cond;
    spc_delivery_cond := _rec2.spc_delivery_date;
    spc_delivery_date := _rec2.spc_annul;
    spc_annul := _rec2.spc_annul_date;
    spc_annul_date := _rec2.spc_letter1_date;
    spc_letter1_date := _rec2.spc_letter2_date;
    spc_letter2_date := _rec2.spc_letter3_date;
    spc_letter3_date := _rec2.spc_complaint_in_court_date;
    spc_complaint_in_court_date := _rec2.usr_id;
    spc_comment_flag := _rec2.spc_comment_flag;
    spc_whose_id := _rec2.spc_whose_id;
  con_incorrect_final_date := null;
  con_day_before_final := 0;
  if ( con_final_date is not null) THEN
  SELECT count_day
    INTO con_day_before_final
    from dcl_get_count_day(con_final_date, (select CURRENT_DATE ));
  if (con_day_before_final <= 35) THEN
  con_incorrect_final_date := 1;
  END IF;
  END IF;
  SELECT usr_id_list,
dep_id_list
    INTO usr_id_list_con,
dep_id_list_con

    from dcl_get_usr_dep_list_con(con_id);

  dates_for_produce_on_storage := null;
  SELECT dates_for_produce_on_storage
    INTO dates_for_produce_on_storage
    from get_prc_dates_on_storage(ctr_id_local, con_id, spc_id);

  spc_summ_itog := spc_summ;
  cur_itog := con_currency;
  spc_delivery_date_math := spc_delivery_date;

  itog_line := null;
  rest_doc_line := null;
  pay_count := 0;
  shp_count := 0;

  spc_pay_summ := 0;
  spc_shp_summ := 0;

  take_part_spc := null;
  if ( spc_group_delivery is not null ) THEN
  SELECT dNVL(cast(sum(lps.lps_summ) as double precision), 0)
    INTO spc_pay_summ
    from dcl_pay_list_summ lps
where lps.spc_id = spc_id and
exists ( select distinct lps_id from dcl_ctc_pay where lps_id = lps.lps_id );

  SELECT dNVL(cast(sum(lps.lps_summ_plus_nds) as double precision), 0)
    INTO spc_shp_summ
    from dcl_shp_list_produce lps,
dcl_shipping shp
where lps.shp_id = shp.shp_id and
shp.spc_id = spc_id and
exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id );

  if ( spc_summ_itog != spc_pay_summ or spc_summ_itog != spc_shp_summ ) THEN
  take_part_spc := 1;
  END IF;
  END IF;
  SELECT count(psum.lps_id)
    INTO pay_count
    from
dcl_payment pay,
dcl_pay_list_summ psum
where
psum.spc_id = spc_id and
pay.pay_id = psum.pay_id and
(
p_earliest_doc_date is null or
take_part_spc = 1 or
(
p_earliest_doc_date is not null and
(
pay.pay_date > p_earliest_doc_date or
not exists ( select distinct lps_id from dcl_ctc_pay where lps_id = psum.lps_id )
)
)
)
and
(p_cur_id is null or pay.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and psum.lps_summ != 0) );

  SELECT count(shp.shp_id)
    INTO shp_count
    from
dcl_shipping shp
where
spc_id = spc_id and
(
p_earliest_doc_date is null or
take_part_spc = 1 or
(
p_earliest_doc_date is not null and
(
shp.shp_date > p_earliest_doc_date or
not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id )
)
)
)
and
(p_cur_id is null or p_cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and shp_summ_plus_nds != 0) );

  -- correcting
  if ( ( pay_count > 0 or shp_count > 0 ) and p_earliest_doc_date is not null ) THEN
  SELECT count(psum.lps_id)
    INTO pay_count
    from
dcl_payment pay,
dcl_pay_list_summ psum
where
psum.spc_id = spc_id and
pay.pay_id = psum.pay_id and
(p_cur_id is null or pay.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and psum.lps_summ != 0) );

  SELECT count(shp.shp_id)
    INTO shp_count
    from
dcl_shipping shp
where
spc_id = spc_id and
(p_cur_id is null or p_cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and shp_summ_plus_nds != 0) );
  END IF;
  have_shp_or_pay := null;
  if ( p_include_all_specs is not null and pay_count = 0 and shp_count = 0 ) THEN
  SELECT count(lps_id)
    INTO have_shp_or_pay
    from dcl_pay_list_summ where spc_id = spc_id;
  if ( have_shp_or_pay = 0 ) THEN
  SELECT count(shp_id)
    INTO have_shp_or_pay
    from dcl_shipping where spc_id = spc_id;
  END IF;
  END IF;
  if ( p_ctr_id = -1 and ((pay_count != 0 or shp_count != 0) or have_shp_or_pay = 0) and ctr_name_check != ctr_name ) THEN
  ctr_name_check := ctr_name;

  con_id_saved := con_id;
  con_number_saved := con_number;
  con_date_saved := con_date;
  con_currency_saved := con_currency;
  con_annul_saved := con_annul;
  con_annul_date_saved := con_annul_date;
  con_final_date_saved := con_final_date;
  con_day_before_final_saved := con_day_before_final;
  con_incorrect_final_date_saved := con_incorrect_final_date;
  con_comment_flag_saved := con_comment_flag;
  usr_id_list_con_saved := usr_id_list_con;
  dep_id_list_con_saved := dep_id_list_con;
  spc_id_saved := spc_id;
  spc_number_saved := spc_number;
  spc_date_saved := spc_date;
  spc_summ_saved := spc_summ;
  spc_add_pay_cond_saved := spc_add_pay_cond;
  spc_delivery_cond_saved := spc_delivery_cond;
  spc_delivery_date_saved := spc_delivery_date;
  spc_annul_saved := spc_annul;
  spc_annul_date_saved := spc_annul_date;
  spc_letter1_date_saved := spc_letter1_date;
  spc_letter2_date_saved := spc_letter2_date;
  spc_letter3_date_saved := spc_letter3_date;
  spc_complaint_in_court_date_saved := spc_complaint_in_court_date;
  spc_comment_flag_saved := spc_comment_flag;
  dates_for_produce_on_storage_saved := dates_for_produce_on_storage;

  con_id := null;
  con_number := ctr_name;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_delivery_date_math := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  dates_for_produce_on_storage := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_closed := null;
  pay_block := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  itog_line := null;
  ctr_line := 1;

  RETURN NEXT;

  ctr_line := null;
  con_id := con_id_saved;
  con_number := con_number_saved;
  con_date := con_date_saved;
  con_currency := con_currency_saved;
  con_annul := con_annul_saved;
  con_annul_date := con_annul_date_saved;
  con_final_date := con_final_date_saved;
  con_day_before_final := con_day_before_final_saved;
  con_incorrect_final_date := con_incorrect_final_date_saved;
  con_comment_flag := con_comment_flag_saved;
  usr_id_list_con := usr_id_list_con_saved;
  dep_id_list_con := dep_id_list_con_saved;
  spc_id := spc_id_saved;
  spc_number := spc_number_saved;
  spc_date := spc_date_saved;
  spc_summ := spc_summ_saved;
  spc_add_pay_cond := spc_add_pay_cond_saved;
  spc_delivery_cond := spc_delivery_cond_saved;
  spc_delivery_date := spc_delivery_date_saved;
  spc_delivery_date_math := spc_delivery_date_saved;
  spc_annul := spc_annul_saved;
  spc_annul_date := spc_annul_date_saved;
  spc_letter1_date := spc_letter1_date_saved;
  spc_letter2_date := spc_letter2_date_saved;
  spc_letter3_date := spc_letter3_date_saved;
  spc_complaint_in_court_date := spc_complaint_in_court_date_saved;
  spc_comment_flag := spc_comment_flag_saved;
  dates_for_produce_on_storage := dates_for_produce_on_storage_saved;
  END IF;
  max_doc_for_spc_count := 0;
  if ( pay_count > shp_count ) THEN
  max_doc_for_spc_count := pay_count;
  ELSE
  max_doc_for_spc_count := shp_count;
  END IF;

  no_shipping := null;
  if ( shp_count = 0 ) THEN
  no_shipping := 1;
  END IF;
  only_spec := null;
  if ( have_shp_or_pay = 0 and max_doc_for_spc_count = 0 ) THEN
  max_doc_for_spc_count := 1;
  only_spec := 1;
  END IF;
  if ( max_doc_for_spc_count != 0 ) THEN
  idx := 0;
  curr_pay := 0;
  curr_shp := 0;

  pay_summ_itog := 0;
  shp_summ_itog := 0;

  WHILE (idx < max_doc_for_spc_count) LOOP
  pay_id := null;
  pay_date := null;
  pay_closed := null;
  pay_summ := null;
  pay_block := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  if ( only_spec = 1 ) THEN
  curr_pay := -1;
  curr_shp := -1;
  END IF;
  if ( curr_pay != -1 ) THEN
  SELECT psum.lps_id,
pay.pay_id,
pay.pay_date,
pay.pay_block,
psum.lps_summ,
pay.pay_comment
    INTO curr_pay,
pay_id,
pay_date,
pay_block,
pay_summ,
pay_comment
    from
dcl_payment pay,
dcl_pay_list_summ psum
where
psum.lps_id > curr_pay and
psum.spc_id = spc_id and
pay.pay_id = psum.pay_id and
(p_cur_id is null or pay.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and psum.lps_summ != 0) )
order by psum.lps_id;

  if ( pay_date is not null ) THEN
  pay_date_expiration := pay_date;
  END IF;
  pay_closed := null;
  if ( spc_group_delivery is not null ) THEN
  SELECT distinct lps_id
    INTO pay_closed
    from dcl_ctc_pay where lps_id = curr_pay;
  END IF;
  if ( ( spc_summ_itog = spc_pay_summ and spc_summ_itog = spc_shp_summ ) or ( spc_pay_summ = 0 and spc_shp_summ = 0 ) ) THEN
  pay_closed := null;
  END IF;
  END IF;
  if ( pay_date is null ) THEN
  curr_pay := -1;
  ELSE
  pay_summ_itog := pay_summ_itog + pay_summ;
  END IF;

  if ( curr_shp != -1 ) THEN
  SELECT shp_id,
shp_id,
shp_date,
shp_date_expiration,
shp_number,
shp_summ_plus_nds,
(select count_day from dcl_get_count_day((select CURRENT_DATE ), shp.shp_date_expiration)) as count_day,
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id
    INTO curr_shp,
shp_id,
shp_date,
shp_date_expiration,
shp_number,
shp_summ,
count_day,
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id_shp
    from
dcl_shipping shp
where
shp.shp_id > curr_shp and
spc_id = spc_id and
(p_cur_id is null or shp.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and shp_summ_plus_nds != 0) )
order by shp.shp_id;

  SELECT usr_id_list
    INTO usr_id_list_shp
    from dcl_get_usr_id_list_shp(shp_id, spc_id_shp);

  SELECT manager_list
    INTO managers
    from DCL_GET_MANAGER_LIST_BY_SHP_ID(shp_id);
  SELECT product_list
    INTO stuff_categories
    from DCL_GET_PRODUCT_LIST_BY_SHP_ID(shp_id);
  shp_no_act := null;
  if ( shp_montage is not null ) THEN
  SELECT count(lps.lps_id)
    INTO shp_no_act
    from dcl_shp_list_produce lps
where lps.shp_id = shp_id and
lps.lps_enter_in_use_date is null and
lps.lps_montage_off is null;
  END IF;
  shp_closed_correct := null;
  shp_closed := null;
  SELECT distinct shp_id
    INTO shp_closed_correct
    from dcl_ctc_shp ctc_shp where ctc_shp.shp_id = shp_id;
  if ( spc_group_delivery is not null ) THEN
  shp_closed := shp_closed_correct;
  END IF;
  if ( ( spc_summ_itog = spc_pay_summ and spc_summ_itog = spc_shp_summ ) or ( spc_pay_summ = 0 and spc_shp_summ = 0 ) ) THEN
  shp_closed := null;
  END IF;
  END IF;
  if ( shp_date is null ) THEN
  curr_shp := -1;
  ELSE
  shp_summ_itog := shp_summ_itog + shp_summ;
  END IF;

  get_pay_expiration_from_proc := null;
  if ( shp_count = 1 and pay_count = 1 and ( (spc_summ_itog = pay_summ_itog and spc_summ_itog = shp_summ_itog) or (spc_summ_itog = pay_summ_itog and pay_summ_itog > shp_summ_itog) ) ) THEN
  SELECT count_day
    INTO count_day
    from dcl_get_count_day(pay_date, shp_date_expiration);
  get_pay_expiration_from_proc := 1;
  END IF;
  if ( shp_count = 1 and pay_count > 1 ) THEN
  SELECT dNVL(cast(sum(lps.lps_summ) as double precision), 0)
    INTO spc_pay_summ
    from dcl_pay_list_summ lps
where lps.spc_id = spc_id;

  if ( spc_pay_summ = spc_summ_itog ) THEN
  SELECT max(pay_date)
    INTO max_pay_date_for_shp
    from
dcl_payment pay,
dcl_pay_list_summ psum
where
psum.spc_id = spc_id and
pay.pay_id = psum.pay_id and
(
p_earliest_doc_date is null or
take_part_spc = 1 or
(
p_earliest_doc_date is not null and
(
pay.pay_date > p_earliest_doc_date or
not exists ( select distinct lps_id from dcl_ctc_pay where lps_id = psum.lps_id )
)
)
)
and
(p_cur_id is null or pay.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and psum.lps_summ != 0) );

  SELECT count_day
    INTO count_day
    from dcl_get_count_day(max_pay_date_for_shp, shp_date_expiration);
  get_pay_expiration_from_proc := 1;
  END IF;
  END IF;
  if ( pay_closed is null and pay_count = 1 and shp_count > 1 ) THEN
  ELSE
  pay_date_expiration := null;
  END IF;

  SELECT spc_pay_expiration
    INTO spc_pay_expiration
    from dcl_get_spc_pay_expiration(spc_id);
  spc_whose := null;
  if ( spc_whose_id is not null ) THEN
  SELECT usr_lng_shp.usr_surname || ' ' || usr_lng_shp.usr_name
    INTO spc_whose
    from dcl_user_language usr_lng_shp
where usr_lng_shp.usr_id = spc_whose_id and
usr_lng_shp.lng_id = 1;
  END IF;
  RETURN NEXT;

  spc_pay_expiration := null;
  spc_whose_id := null;
  spc_whose := null;

  idx := idx + 1;
  if ( idx = 1 ) THEN
  con_number := null;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  dates_for_produce_on_storage := null;
  END IF;
  END LOOP;

  con_id := null;
  con_number := null;
  con_date := null;
  con_currency := cur_itog;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := spc_summ_itog;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_delivery_date_math := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  dates_for_produce_on_storage := null;

  pay_id := null;
  pay_date := null;
  pay_summ := pay_summ_itog;
  pay_closed := null;
  pay_block := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := shp_summ_itog;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  itog_line := 1;

  RETURN NEXT;
  END IF;
  END LOOP;

  if ( include_other_pay_shp is not null ) THEN
  itog_line := null;
  rest_doc_line := 1;

  pay_count := 0;
  shp_count := 0;

  SELECT count(pay.pay_id)
    INTO pay_count
    from
dcl_payment pay
where
pay.ctr_id = ctr_id_local and
( ( pay.pay_summ -
dNVL(cast( (
select sum(psum.lps_summ)
from  dcl_pay_list_summ psum
where psum.pay_id = pay.pay_id
) as double precision), 0)
) != 0
) and
(p_cur_id is null or pay.cur_id = p_cur_id) and
(select is_pay_closed from dcl_is_pay_closed(pay.pay_id)) is null;

  SELECT count(shp.shp_id)
    INTO shp_count
    from
dcl_shipping shp
where
shp.ctr_id = ctr_id_local and
shp.spc_id is null and
(p_cur_id is null or shp.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and shp.shp_summ_plus_nds != 0) ) and
not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id );

  dates_for_produce_on_storage := null;
  SELECT dates_for_produce_on_storage
    INTO dates_for_produce_on_storage
    from get_prc_dates_on_storage(ctr_id_local, null, null);
  dates_for_produce_on_storage_saved := dates_for_produce_on_storage;

  if ( p_ctr_id = -1 and (pay_count != 0 or shp_count != 0 or dates_for_produce_on_storage != '' ) and ctr_name_check != ctr_name ) THEN
  ctr_name_check := ctr_name;

  con_id := null;
  con_number := ctr_name;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_delivery_date_math := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  dates_for_produce_on_storage := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_closed := null;
  pay_block := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  itog_line := null;
  ctr_line := 1;

  RETURN NEXT;

  ctr_line := null;
  END IF;
  max_doc_for_spc_count := 0;
  if ( pay_count > shp_count ) THEN
  max_doc_for_spc_count := pay_count;
  ELSE
  max_doc_for_spc_count := shp_count;
  END IF;

  if ( max_doc_for_spc_count != 0 ) THEN
  con_id := null;
  con_number := null;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_delivery_date_math := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  dates_for_produce_on_storage := null;

  idx := 0;
  curr_pay := 0;
  curr_shp := 0;

  WHILE (idx < max_doc_for_spc_count) LOOP
  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_closed := null;
  pay_block := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_summ := null;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_comment := null;
  shp_original := null;

  if ( curr_pay != -1 ) THEN
  SELECT pay.pay_id,
pay.pay_id,
pay.pay_date,
pay.pay_block,
( pay.pay_summ -
dNVL(cast( (
select sum(psum.lps_summ)
from  dcl_pay_list_summ psum
where psum.pay_id = pay.pay_id
) as double precision), 0)
),
cur.cur_name,
pay.pay_comment
    INTO curr_pay,
pay_id,
pay_date,
pay_block,
pay_summ,
pay_currency,
pay_comment
    from
dcl_payment pay,
dcl_currency cur
where
pay.pay_id > curr_pay and
pay.ctr_id = ctr_id_local and
( ( pay.pay_summ -
dNVL(cast( (
select sum(psum.lps_summ)
from  dcl_pay_list_summ psum
where psum.pay_id = pay.pay_id
) as double precision), 0)
) != 0
) and
cur.cur_id = pay.cur_id and
(p_cur_id is null or cur.cur_id = p_cur_id) and
(select is_pay_closed from dcl_is_pay_closed(pay.pay_id)) is null
order by pay.pay_id;
  END IF;
  if ( pay_date is null ) THEN
  curr_pay := -1;
  END IF;
  if ( curr_shp != -1 ) THEN
  SELECT shp_id,
shp_id,
shp_date,
shp_date_expiration,
shp_number,
shp_summ_plus_nds,
cur.cur_name,
(select count_day from dcl_get_count_day((select CURRENT_DATE ), shp.shp_date_expiration)),
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id
    INTO curr_shp,
shp_id,
shp_date_expiration,
shp_date,
shp_number,
shp_summ,
shp_currency,
count_day,
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id_shp

    from
dcl_shipping shp,
dcl_currency cur
where
shp.shp_id > curr_shp and
shp.ctr_id = ctr_id_local and
shp.spc_id is null and
cur.cur_id = shp.cur_id and
(p_cur_id is null or cur.cur_id = p_cur_id) and
(p_not_include_zero is null or (p_not_include_zero is not null and shp.shp_summ_plus_nds != 0) ) and
not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id )
order by shp.shp_id;

  SELECT usr_id_list
    INTO usr_id_list_shp
    from dcl_get_usr_id_list_shp(shp_id, spc_id_shp);

  SELECT manager_list
    INTO managers
    from DCL_GET_MANAGER_LIST_BY_SHP_ID(shp_id);
  SELECT product_list
    INTO stuff_categories
    from DCL_GET_PRODUCT_LIST_BY_SHP_ID(shp_id);
  shp_no_act := null;
  if ( shp_montage is not null ) THEN
  SELECT count(lps.lps_id)
    INTO shp_no_act
    from dcl_shp_list_produce lps
where lps.shp_id = shp_id and
lps.lps_enter_in_use_date is null and
lps.lps_montage_off is null;
  END IF;
  SELECT distinct shp_id
    INTO shp_closed_correct
    from dcl_ctc_shp ctc_shp where ctc_shp.shp_id = shp_id;
  END IF;
  alone_shipping := 1;
  if ( shp_date is null ) THEN
  curr_shp := -1;
  alone_shipping := null;
  END IF;
  RETURN NEXT;

  idx := idx + 1;
  END LOOP;
  END IF;
  con_id := null;
  con_number := null;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_delivery_cond := null;
  spc_delivery_date := null;
  spc_delivery_date_math := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_closed := null;
  pay_block := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_summ := null;
  shp_closed := null;
  shp_closed_correct := null;
  get_pay_expiration_from_proc := null;
  shp_comment := null;
  shp_original := null;

  dates_for_produce_on_storage := dates_for_produce_on_storage_saved;
  if ( dates_for_produce_on_storage != '' ) THEN
  RETURN NEXT;
  END IF;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_calculation_state_debet(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_calculation_state_debet(p_ctr_id integer, p_cur_id integer, p_sln_id integer, p_usr_id integer, p_dep_id integer) RETURNS TABLE(con_id integer, con_number character varying, con_date date, con_currency character varying, con_annul smallint, con_annul_date date, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_annul smallint, spc_annul_date date, pay_id integer, pay_date date, pay_summ numeric, shp_id integer, shp_number character, shp_date date, shp_summ numeric, itog_line smallint, rest_doc_line smallint, shp_currency character varying, ctr_name character varying, ctr_line smallint, spc_add_pay_cond character varying, managers character varying, stuff_categories character varying, count_day integer, shp_date_expiration date, shp_letter1_date date, shp_letter2_date date, shp_letter3_date date, shp_complaint_in_court_date date, shp_comment character varying, shp_original smallint, pay_comment character varying, shp_no_act smallint, con_comment_flag integer, spc_comment_flag integer, spc_letter1_date date, spc_letter2_date date, spc_letter3_date date, spc_complaint_in_court_date date, spc_whose_id integer, spc_whose character varying, usr_id_list_con character varying, dep_id_list_con character varying, usr_id_list_shp character varying, con_final_date date, con_day_before_final integer, con_incorrect_final_date smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  max_doc_for_spc_count integer;
  shp_count integer;
  pay_count integer;
  idx integer;
  curr_pay integer;
  curr_shp integer;
  spc_summ_itog decimal(15,2);
  pay_summ_itog decimal(15,2);
  shp_summ_itog decimal(15,2);
  cur_itog varchar(10);
  ctr_name_check varchar(200);
  con_id_saved integer;
  con_number_saved varchar(200);
  con_date_saved date;
  con_currency_saved varchar(10);
  con_annul_saved smallint;
  con_annul_date_saved date;
  spc_id_saved integer;
  spc_number_saved varchar(50);
  spc_date_saved date;
  spc_summ_saved decimal(15,2);
  ctr_id_local integer;
  spc_add_pay_cond_saved varchar(5000);
  spc_annul_saved smallint;
  spc_annul_date_saved date;
  shp_montage integer;
  con_comment_flag_saved integer;
  spc_comment_flag_saved integer;
  contractor_sort varchar(200);
  include_other_pay_shp smallint;
  spc_letter1_date_saved date;
  spc_letter2_date_saved date;
  spc_letter3_date_saved date;
  spc_complaint_in_court_date_saved date;
  usr_id_list_con_saved varchar(200);
  dep_id_list_con_saved varchar(200);
  spc_id_shp integer;
  con_final_date_saved date;
  con_day_before_final_saved integer;
  con_incorrect_final_date_saved integer;
  _rec RECORD;
  _rec2 RECORD;
  _rec3 RECORD;
BEGIN
  -- not include payments and shipping without specification
  include_other_pay_shp := 1;
  if ( ( p_usr_id is not null and p_usr_id != -1 ) or ( p_dep_id is not null and p_dep_id != -1 ) ) THEN
  include_other_pay_shp := null;
  END IF;
  ctr_name_check := 'FirstCheckContractor';
  FOR _rec IN select p_ctr_id, ctr_name, upper(ctr_name) as contractor_sort from dcl_contractor where p_ctr_id = p_ctr_id or p_ctr_id = -1 order by contractor_sort
  LOOP
    ctr_id_local := _rec.p_ctr_id;
    ctr_name := _rec.ctr_name;
    contractor_sort := _rec.contractor_sort;
  FOR _rec2 IN select con.con_id, con.con_number, con.con_date, con.con_annul, con.con_annul_date, con.con_final_date, LENGTH(con.con_comment), cur.cur_name, spc.spc_id, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_add_pay_cond, spc.spc_annul, spc.spc_annul_date, spc.spc_letter1_date, spc.spc_letter2_date, spc.spc_letter3_date, spc.spc_complaint_in_court_date, LENGTH(spc.spc_comment), spc.usr_id from dcl_contract con, dcl_con_list_spec spc, dcl_currency cur where con.ctr_id = ctr_id_local and spc.con_id = con.con_id and cur.cur_id = con.cur_id and (p_cur_id is null or cur.cur_id = p_cur_id) and (con.sln_id is null or con.sln_id = p_sln_id ) and ( p_usr_id = -1 or p_usr_id is null or spc.usr_id = p_usr_id ) and ( p_dep_id = -1 or p_dep_id is null or p_dep_id = ( select p_dep_id from dcl_user where p_usr_id = spc.usr_id ) )
  LOOP
    con_id := _rec2.con_id;
    con_number := _rec2.con_number;
    con_date := _rec2.con_date;
    con_annul := _rec2.con_annul;
    con_annul_date := _rec2.con_annul_date;
    con_final_date := _rec2.con_final_date;
    con_comment_flag := _rec2.cur_name;
    con_currency := _rec2.spc_id;
    spc_id := _rec2.spc_number;
    spc_number := _rec2.spc_date;
    spc_date := _rec2.spc_summ;
    spc_summ := _rec2.spc_add_pay_cond;
    spc_add_pay_cond := _rec2.spc_annul;
    spc_annul := _rec2.spc_annul_date;
    spc_annul_date := _rec2.spc_letter1_date;
    spc_letter1_date := _rec2.spc_letter2_date;
    spc_letter2_date := _rec2.spc_letter3_date;
    spc_letter3_date := _rec2.spc_complaint_in_court_date;
    spc_complaint_in_court_date := _rec2.usr_id;
    spc_comment_flag := _rec2.spc_comment_flag;
    spc_whose_id := _rec2.spc_whose_id;
  con_incorrect_final_date := null;
  con_day_before_final := 0;
  if ( con_final_date is not null) THEN
  SELECT count_day
    INTO con_day_before_final
    from dcl_get_count_day(con_final_date, (select CURRENT_DATE ));
  if (con_day_before_final <= 35) THEN
  con_incorrect_final_date := 1;
  END IF;
  END IF;
  SELECT usr_id_list,
dep_id_list
    INTO usr_id_list_con,
dep_id_list_con

    from dcl_get_usr_dep_list_con(con_id);

  itog_line := null;
  rest_doc_line := null;
  pay_count := 0;
  shp_count := 0;

  spc_summ_itog := spc_summ;
  cur_itog := con_currency;

  SELECT count(lps_id)
    INTO pay_count
    from
dcl_pay_list_summ psum
where
spc_id = spc_id and
not exists ( select distinct lps_id from dcl_ctc_pay where lps_id = psum.lps_id );

  SELECT count(shp_id)
    INTO shp_count
    from
dcl_shipping shp
where
spc_id = spc_id and
not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id );

  if ( p_ctr_id = -1 and shp_count != 0 and ctr_name_check != ctr_name ) THEN
  ctr_name_check := ctr_name;

  con_id_saved := con_id;
  con_number_saved := con_number;
  con_date_saved := con_date;
  con_currency_saved := con_currency;
  con_annul_saved := con_annul;
  con_annul_date_saved := con_annul_date;
  con_final_date_saved := con_final_date;
  con_day_before_final_saved := con_day_before_final;
  con_incorrect_final_date_saved := con_incorrect_final_date;
  con_comment_flag_saved := con_comment_flag;
  usr_id_list_con_saved := usr_id_list_con;
  dep_id_list_con_saved := dep_id_list_con;
  spc_id_saved := spc_id;
  spc_number_saved := spc_number;
  spc_date_saved := spc_date;
  spc_summ_saved := spc_summ;
  spc_add_pay_cond_saved := spc_add_pay_cond;
  spc_annul_saved := spc_annul;
  spc_annul_date_saved := spc_annul_date;
  spc_letter1_date_saved := spc_letter1_date;
  spc_letter2_date_saved := spc_letter2_date;
  spc_letter3_date_saved := spc_letter3_date;
  spc_complaint_in_court_date_saved := spc_complaint_in_court_date;
  spc_comment_flag_saved := spc_comment_flag;

  con_id := null;
  con_number := ctr_name;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;
  itog_line := null;
  ctr_line := 1;

  RETURN NEXT;

  ctr_line := null;
  con_id := con_id_saved;
  con_number := con_number_saved;
  con_date := con_date_saved;
  con_currency := con_currency_saved;
  con_annul := con_annul_saved;
  con_annul_date := con_annul_date_saved;
  con_final_date := con_final_date_saved;
  con_day_before_final := con_day_before_final_saved;
  con_incorrect_final_date := con_incorrect_final_date_saved;
  con_comment_flag := con_comment_flag_saved;
  usr_id_list_con := usr_id_list_con_saved;
  dep_id_list_con := dep_id_list_con_saved;
  spc_id := spc_id_saved;
  spc_number := spc_number_saved;
  spc_date := spc_date_saved;
  spc_summ := spc_summ_saved;
  spc_add_pay_cond := spc_add_pay_cond_saved;
  spc_annul := spc_annul_saved;
  spc_annul_date := spc_annul_date_saved;
  spc_letter1_date := spc_letter1_date_saved;
  spc_letter2_date := spc_letter2_date_saved;
  spc_letter3_date := spc_letter3_date_saved;
  spc_complaint_in_court_date := spc_complaint_in_court_date_saved;
  spc_comment_flag := spc_comment_flag_saved;
  END IF;
  max_doc_for_spc_count := 0;
  if ( pay_count > shp_count ) THEN
  max_doc_for_spc_count := pay_count;
  ELSE
  max_doc_for_spc_count := shp_count;
  END IF;

  if ( max_doc_for_spc_count != 0 and shp_count !=0 ) THEN
  idx := 0;
  curr_pay := 0;
  curr_shp := 0;

  pay_summ_itog := 0;
  shp_summ_itog := 0;

  WHILE (idx < max_doc_for_spc_count) LOOP
  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  if ( curr_pay != -1 ) THEN
  SELECT psum.lps_id,
pay.pay_id,
pay.pay_date,
pay.pay_comment,
psum.lps_summ
    INTO curr_pay,
pay_id,
pay_date,
pay_comment,
pay_summ
    from
dcl_payment pay,
dcl_pay_list_summ psum
where
psum.lps_id > curr_pay and
psum.spc_id = spc_id and
pay.pay_id = psum.pay_id and
not exists ( select distinct lps_id from dcl_ctc_pay where lps_id = psum.lps_id )
order by psum.lps_id;
  END IF;
  if ( pay_date is null ) THEN
  curr_pay := -1;
  ELSE
  pay_summ_itog := pay_summ_itog + pay_summ;
  END IF;

  if ( curr_shp != -1 ) THEN
  SELECT shp_id,
shp_id,
shp_date,
shp_date_expiration,
shp_number,
shp_summ_plus_nds,
(select count_day from dcl_get_count_day((select CURRENT_DATE ), shp.shp_date_expiration)) as count_day,
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id
    INTO curr_shp,
shp_id,
shp_date,
shp_date_expiration,
shp_number,
shp_summ,
count_day,
shp_letter1_date,
shp_letter2_date,
shp_letter3_date,
shp_complaint_in_court_date,
shp_comment,
shp_original,
shp_montage,
spc_id_shp
    from
dcl_shipping shp
where
shp_id > curr_shp and
spc_id = spc_id and
not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id )
order by shp.shp_id;

  SELECT usr_id_list
    INTO usr_id_list_shp
    from dcl_get_usr_id_list_shp(shp_id, spc_id_shp);

  SELECT manager_list
    INTO managers
    from DCL_GET_MANAGER_LIST_BY_SHP_ID(shp_id);
  SELECT product_list
    INTO stuff_categories
    from DCL_GET_PRODUCT_LIST_BY_SHP_ID(shp_id);
  shp_no_act := null;
  if ( shp_montage is not null ) THEN
  SELECT count(lps.lps_id)
    INTO shp_no_act
    from dcl_shp_list_produce lps
where lps.shp_id = shp_id and
lps.lps_enter_in_use_date is null and
lps.lps_montage_off is null;
  END IF;
  END IF;
  if ( shp_date is null ) THEN
  curr_shp := -1;
  ELSE
  shp_summ_itog := shp_summ_itog + shp_summ;
  END IF;

  spc_whose := null;
  if ( spc_whose_id is not null ) THEN
  SELECT usr_lng_shp.usr_surname || ' ' || usr_lng_shp.usr_name
    INTO spc_whose
    from dcl_user_language usr_lng_shp
where usr_lng_shp.usr_id = spc_whose_id and
usr_lng_shp.lng_id = 1;
  END IF;
  RETURN NEXT;

  spc_whose_id := null;
  spc_whose := null;

  idx := idx + 1;
  if ( idx = 1 ) THEN
  con_number := null;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  END IF;
  END LOOP;

  con_id := null;
  con_number := null;
  con_date := null;
  con_currency := cur_itog;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := spc_summ_itog;
  spc_add_pay_cond := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;

  pay_id := null;
  pay_date := null;
  pay_comment := null;
  pay_summ := pay_summ_itog;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := shp_summ_itog;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;
  itog_line := 1;

  RETURN NEXT;
  END IF;
  END LOOP;

  if ( include_other_pay_shp is not null ) THEN
  itog_line := null;
  rest_doc_line := 1;

  shp_count := 0;

  SELECT count(shp_id)
    INTO shp_count
    from
dcl_shipping shp
where
shp.ctr_id = ctr_id_local and
shp.spc_id is null and
shp.shp_summ_plus_nds > 0 and
(p_cur_id is null or shp.cur_id = p_cur_id);

  if ( p_ctr_id = -1 and shp_count != 0 and ctr_name_check != ctr_name ) THEN
  ctr_name_check := ctr_name;

  con_id := null;
  con_number := ctr_name;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_comment := null;

  shp_id := null;
  shp_date := null;
  shp_date_expiration := null;
  shp_number := null;
  shp_summ := null;
  shp_letter1_date := null;
  shp_letter2_date := null;
  shp_letter3_date := null;
  shp_complaint_in_court_date := null;
  shp_comment := null;
  shp_original := null;
  shp_no_act := null;
  managers := null;
  stuff_categories := null;

  itog_line := null;
  ctr_line := 1;

  RETURN NEXT;

  ctr_line := null;
  END IF;
  if ( shp_count != 0 ) THEN
  con_id := null;
  con_number := null;
  con_date := null;
  con_currency := null;
  con_annul := null;
  con_annul_date := null;
  con_final_date := null;
  con_day_before_final := null;
  con_incorrect_final_date := null;
  con_comment_flag := null;
  usr_id_list_con := null;
  dep_id_list_con := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_add_pay_cond := null;
  spc_annul := null;
  spc_annul_date := null;
  spc_letter1_date := null;
  spc_letter2_date := null;
  spc_letter3_date := null;
  spc_complaint_in_court_date := null;
  spc_comment_flag := null;
  managers := null;
  stuff_categories := null;

  pay_id := null;
  pay_date := null;
  pay_summ := null;
  pay_comment := null;

  FOR _rec3 IN select shp_id, shp_id, shp_date, shp_date_expiration, shp_number, shp_summ_plus_nds, cur.cur_name, (select count_day from dcl_get_count_day((select CURRENT_DATE ), shp.shp_date_expiration)) as count_day, shp_letter1_date, shp_letter2_date, shp_letter3_date, shp_complaint_in_court_date, shp_comment, shp_original, shp_montage, spc_id from dcl_shipping shp, dcl_currency cur where shp.ctr_id = ctr_id_local and shp.spc_id is null and shp.shp_summ_plus_nds > 0 and cur.cur_id = shp.cur_id and (p_cur_id is null or cur.cur_id = p_cur_id) order by shp.shp_id
  LOOP
    curr_shp := _rec3.shp_id;
    shp_id := _rec3.shp_id;
    shp_date := _rec3.shp_date;
    shp_date_expiration := _rec3.shp_date_expiration;
    shp_number := _rec3.shp_number;
    shp_summ := _rec3.shp_summ_plus_nds;
    shp_currency := _rec3.cur_name;
    count_day := _rec3.count_day;
    shp_letter1_date := _rec3.shp_letter1_date;
    shp_letter2_date := _rec3.shp_letter2_date;
    shp_letter3_date := _rec3.shp_letter3_date;
    shp_complaint_in_court_date := _rec3.shp_complaint_in_court_date;
    shp_comment := _rec3.shp_comment;
    shp_original := _rec3.shp_original;
    shp_montage := _rec3.shp_montage;
    spc_id_shp := _rec3.spc_id;
  SELECT usr_id_list
    INTO usr_id_list_shp
    from dcl_get_usr_id_list_shp(shp_id, spc_id_shp);
  con_currency := shp_currency;
  SELECT manager_list
    INTO managers
    from DCL_GET_MANAGER_LIST_BY_SHP_ID(shp_id);
  SELECT product_list
    INTO stuff_categories
    from DCL_GET_PRODUCT_LIST_BY_SHP_ID(shp_id);
  shp_no_act := null;
  if ( shp_montage is not null ) THEN
  SELECT count(lps.lps_id)
    INTO shp_no_act
    from dcl_shp_list_produce lps
where lps.shp_id = shp_id and
lps.lps_enter_in_use_date is null and
lps.lps_montage_off is null;
  END IF;
  RETURN NEXT;
  END LOOP;
  END IF;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_can_spc_block(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_can_spc_block(p_spc_id integer) RETURNS TABLE(can_bloc smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spc_summ decimal(15,2);
  spc_group_delivery smallint;
  spc_pay_summ decimal(15,2);
  spc_shp_summ decimal(15,2);
BEGIN
  can_bloc = null;
  select
    spc_summ,
    spc_group_delivery
  from dcl_con_list_spec
  where p_spc_id = p_spc_id
  into
    spc_summ,
    spc_group_delivery;

  if ( spc_group_delivery is null ) then
    can_bloc = 1;
  else
    SELECT dNVL(cast(sum(lps.lps_summ) as double precision), 0)
      INTO spc_pay_summ
      from dcl_pay_list_summ lps
    where lps.p_spc_id = p_spc_id and
          lps.lps_id in ( select distinct lps_id from dcl_ctc_pay );

    SELECT dNVL(cast(sum(lps.lps_summ_plus_nds) as double precision), 0)
      INTO spc_shp_summ
      from dcl_shp_list_produce lps,
         dcl_shipping shp
    where lps.shp_id = shp.shp_id and
          shp.p_spc_id = p_spc_id and
          shp.shp_id in ( select distinct shp_id from dcl_ctc_shp );

    if ( spc_summ = spc_pay_summ and spc_summ = spc_shp_summ and spc_summ > 0 ) then
      can_bloc = 1;
  END IF;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_catalog_number_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_catalog_number_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CTN_ID IS NULL) THEN
    NEW.CTN_ID = nextval('gen_dcl_catalog_number_id');
  ELSE
        ID = nextval('gen_dcl_catalog_number_id');
        IF ( ID < NEW.CTN_ID ) THEN
          ID = nextval('gen_dcl_catalog_number_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_catalog_number_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_catalog_number_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  update dcl_assemble set stf_id = new.stf_id where stf_id = old.stf_id and stf_id != new.stf_id and prd_id = old.prd_id;
  update dcl_cfc_list_produce set stf_id = new.stf_id where stf_id = old.stf_id and stf_id != new.stf_id and prd_id = old.prd_id;
  update dcl_cpr_list_produce set stf_id = new.stf_id where stf_id = old.stf_id and stf_id != new.stf_id and prd_id = old.prd_id;
  update dcl_dlr_list_produce set stf_id = new.stf_id where stf_id = old.stf_id and stf_id != new.stf_id and prd_id = old.prd_id;
  update dcl_prc_list_produce set stf_id = new.stf_id where stf_id = old.stf_id and stf_id != new.stf_id and prd_id = old.prd_id;
RETURN NEW;
END
$$;


--
-- Name: dcl_category_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_category_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CAT_ID IS NULL) THEN
    NEW.CAT_ID = nextval('gen_dcl_category_id');
  ELSE
        ID = nextval('gen_dcl_category_id');
        IF ( ID < NEW.CAT_ID ) THEN
          ID = nextval('gen_dcl_category_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cfc_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cfc_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CCP_ID IS NULL) THEN
    NEW.CCP_ID = nextval('gen_dcl_cfc_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_cfc_list_produce_id');
        IF ( ID < NEW.CCP_ID ) THEN
          ID = nextval('gen_dcl_cfc_list_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cfc_message_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cfc_message_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CCM_ID IS NULL) THEN
    NEW.CCM_ID = nextval('gen_dcl_cfc_message_id');
  ELSE
        ID = nextval('gen_dcl_cfc_message_id');
        IF ( ID < NEW.CCM_ID ) THEN
          ID = nextval('gen_dcl_cfc_message_id');
  END IF;
  END IF;

  new.ccm_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_cfc_messages_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cfc_messages_load(p_usr_id_in integer) RETURNS TABLE(ccm_id integer, ccm_create_date timestamp without time zone, ccm_message character varying, ctr_id integer, ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select ccm_id, ccm_create_date, ccm_message, ctr_id from dcl_cfc_message ccm where ccm.usr_id = p_usr_id_in order by ccm_create_date DESC
  LOOP
    ccm_id := _rec.ccm_id;
    ccm_create_date := _rec.ccm_create_date;
    ccm_message := _rec.ccm_message;
    ctr_id := _rec.ctr_id;
    ctr_name := null;
    if (ctr_id is not null) then
      select ctr_name from dcl_contractor where ctr_id = ctr_id into ctr_name;
  END IF;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_cfc_produces_select(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cfc_produces_select(p_cfc_id_in integer) RETURNS TABLE(ccp_id integer, cfc_id integer, stf_id integer, stf_name character varying, prd_id integer, ccp_price numeric, ccp_count numeric, ccp_nds_rate numeric, cpr_id integer, cpr_number character varying, cpr_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE _rec RECORD;
BEGIN
  FOR _rec IN SELECT ccp.ccp_id, ccp.cfc_id, stf.stf_id, stf.stf_name,
      ccp.prd_id, ccp.ccp_price, ccp.ccp_count, ccp.ccp_nds_rate, ccp.cpr_id
    FROM dcl_cfc_list_produce ccp, dcl_stuff_category stf
    WHERE ccp.cfc_id = p_cfc_id_in AND stf.stf_id = ccp.stf_id
    ORDER BY ccp.ccp_id
  LOOP
    ccp_id := _rec.ccp_id; cfc_id := _rec.cfc_id; stf_id := _rec.stf_id;
    stf_name := _rec.stf_name; prd_id := _rec.prd_id; ccp_price := _rec.ccp_price;
    ccp_count := _rec.ccp_count; ccp_nds_rate := _rec.ccp_nds_rate; cpr_id := _rec.cpr_id;
    cpr_number := NULL; cpr_date := NULL;
    IF (cpr_id IS NOT NULL) THEN
      SELECT cp.cpr_number, cp.cpr_date INTO cpr_number, cpr_date
        FROM dcl_commercial_proposal cp WHERE cp.cpr_id = _rec.cpr_id;
    END IF;
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_close_contract(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_close_contract(IN p_spc_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_con_id integer;
  v_spc_count_not_executed integer;
BEGIN
  UPDATE dcl_con_list_spec SET spc_executed = 1
  WHERE spc_id = p_spc_id
    AND spc_executed IS NULL
    AND (SELECT can_bloc FROM dcl_can_spc_block(p_spc_id)) IS NOT NULL;

  SELECT con_id INTO v_con_id FROM dcl_con_list_spec WHERE spc_id = p_spc_id;
  
  SELECT COUNT(spc_id) INTO v_spc_count_not_executed 
  FROM dcl_con_list_spec WHERE con_id = v_con_id AND spc_executed IS NULL AND spc_annul IS NULL;
  
  IF (v_spc_count_not_executed = 0) THEN
    UPDATE dcl_contract SET con_executed = 1 WHERE con_id = v_con_id;
  END IF;
END
$$;


--
-- Name: dcl_close_reserved_in_cpr(); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_close_reserved_in_cpr()
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_cpr_id integer;
  v_count_day_for_wait integer;
  _rec RECORD;
BEGIN
  FOR v_cpr_id IN SELECT cpr.cpr_id FROM dcl_commercial_proposal cpr 
    WHERE cpr.cpr_assemble_minsk_store IS NOT NULL 
    AND cpr.cpr_block IS NULL 
    AND cpr.cpr_proposal_received_flag = 0 
    AND (cpr.cpr_final_date + INTERVAL '1 day') <= CURRENT_DATE
  LOOP
    UPDATE dcl_commercial_proposal SET cpr_block = 1, cpr_no_reservation = 1 WHERE cpr_id = v_cpr_id;
  END LOOP;
  
  SELECT CAST(stn_value AS INTEGER) INTO v_count_day_for_wait FROM dcl_setting WHERE stn_name = 'dayCountWaitReservedForShipping';
  
  IF v_count_day_for_wait IS NULL THEN
    v_count_day_for_wait := 0;
  END IF;
  
  FOR v_cpr_id IN SELECT cpr.cpr_id FROM dcl_commercial_proposal cpr 
    WHERE cpr.cpr_assemble_minsk_store IS NOT NULL 
    AND cpr.cpr_block IS NULL 
    AND cpr.cpr_proposal_received_flag = 1 
    AND (cpr.cpr_final_date + (v_count_day_for_wait || ' days')::INTERVAL) <= CURRENT_DATE
  LOOP
    UPDATE dcl_commercial_proposal SET cpr_block = 1, cpr_no_reservation = 1 WHERE cpr_id = v_cpr_id;
  END LOOP;
END
$$;


--
-- Name: dcl_closed_record_insert(integer, integer, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_closed_record_insert(p_ctc_id integer, p_spc_id integer, p_lcc_charges numeric, p_lcc_montage numeric, p_lcc_transport numeric, p_lcc_update_sum numeric) RETURNS TABLE(lcc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_ctc_list (
     p_ctc_id,
     p_spc_id,
     p_lcc_charges,
     p_lcc_montage,
     p_lcc_transport,
     p_lcc_update_sum
    )
    values (
     p_ctc_id,
     p_spc_id,
     p_lcc_charges,
     p_lcc_montage,
     p_lcc_transport,
     p_lcc_update_sum
    )
    returning lcc_id into lcc_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_commercial_proposal_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_commercial_proposal_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  usr_count integer;
BEGIN
  select count(usr_id) from dcl_contractor_user t where t.usr_id = new.usr_id_create and t.ctr_id = new.ctr_id into usr_count;
  if (usr_count = 0) then
    insert into dcl_contractor_user (ctr_id, usr_id) values (new.ctr_id, new.usr_id_create);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_commercial_proposal_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_commercial_proposal_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CPR_ID IS NULL) THEN
    NEW.CPR_ID = nextval('gen_dcl_commercial_proposal_id');
  ELSE
        ID = nextval('gen_dcl_commercial_proposal_id');
        IF ( ID < NEW.CPR_ID ) THEN
          ID = nextval('gen_dcl_commercial_proposal_id');
  END IF;
  END IF;
  new.cpr_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.cpr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_commercial_proposal_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_commercial_proposal_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.cpr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_commercial_proposal_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_commercial_proposal_filter(cpr_number_in character varying, cpr_contractor_in character varying, cpr_date_begin_in character varying, cpr_date_end_in character varying, cpr_summ_min_in character varying, cpr_summ_max_in character varying, cpr_user_in character varying, cpr_department_in character varying, cpr_stf_name_in character varying, cpr_proposal_received_flag_in character varying, cpr_proposal_declined_in character varying) RETURNS TABLE(cpr_id integer, cpr_number character varying, cpr_date date, cpr_contractor character varying, cpr_summ numeric, cpr_currency character varying, cpr_stf_name character varying, cpr_proposal_received_flag smallint, cpr_proposal_declined character, cpr_block smallint, cpr_user character varying, cpr_department character varying, usr_id_create integer, cpr_check_price smallint, cpr_check_price_date timestamp without time zone, cpr_check_price_user character varying, cpr_final_date date, cpr_assemble_minsk_store smallint, cpr_no_reservation smallint, dep_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_number_in VARCHAR := UPPER(cpr_number_in);
  v_contractor_in VARCHAR := UPPER(cpr_contractor_in);
  v_user_in VARCHAR := UPPER(cpr_user_in);
  v_department_in VARCHAR := UPPER(cpr_department_in);
  v_stf_name_in VARCHAR := UPPER(cpr_stf_name_in);
  v_date_begin DATE := CASE WHEN cpr_date_begin_in IS NOT NULL AND cpr_date_begin_in != '' THEN cpr_date_begin_in::DATE ELSE NULL END;
  v_date_end DATE := CASE WHEN cpr_date_end_in IS NOT NULL AND cpr_date_end_in != '' THEN cpr_date_end_in::DATE ELSE NULL END;
  v_summ_min DECIMAL(15,2) := CASE WHEN cpr_summ_min_in IS NOT NULL AND cpr_summ_min_in != '' THEN cpr_summ_min_in::DECIMAL(15,2) ELSE NULL END;
  v_summ_max DECIMAL(15,2) := CASE WHEN cpr_summ_max_in IS NOT NULL AND cpr_summ_max_in != '' THEN cpr_summ_max_in::DECIMAL(15,2) ELSE NULL END;
  v_received_flag SMALLINT := CASE WHEN cpr_proposal_received_flag_in IS NOT NULL AND cpr_proposal_received_flag_in != '' THEN cpr_proposal_received_flag_in::SMALLINT ELSE NULL END;
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT
      cpr.cpr_id,
      cpr.cpr_number,
      cpr.cpr_date,
      ctr.ctr_name,
      cpr.cpr_summ,
      cur.cur_name,
      cpr.cpr_proposal_received_flag,
      cpr.cpr_proposal_declined,
      cpr.cpr_block,
      (ul.usr_surname || ' ' || ul.usr_name)::VARCHAR(50) AS cpr_user_val,
      cpr.usr_id_create,
      cpr.cpr_check_price,
      cpr.cpr_check_price_date,
      (ulcp.usr_surname || ' ' || ulcp.usr_name)::VARCHAR(50) AS cpr_check_price_user_val,
      cpr.cpr_final_date,
      cpr.cpr_assemble_minsk_store,
      cpr.cpr_no_reservation,
      dep.dep_name,
      STRING_AGG(DISTINCT stf.stf_name, ', ')::VARCHAR(2000) AS stf_names
    FROM dcl_commercial_proposal cpr
      LEFT JOIN dcl_contractor ctr ON ctr.ctr_id = cpr.ctr_id
      LEFT JOIN dcl_currency cur ON cur.cur_id = cpr.cur_id
      LEFT JOIN dcl_user_language ul ON ul.usr_id = cpr.usr_id_create AND ul.lng_id = 1
      LEFT JOIN dcl_user_language ulcp ON ulcp.usr_id = cpr.usr_id_check_price AND ulcp.lng_id = 1
      LEFT JOIN dcl_user u ON u.usr_id = cpr.usr_id_create
      LEFT JOIN dcl_department dep ON dep.dep_id = u.dep_id
      LEFT JOIN dcl_cpr_list_produce lpr ON lpr.cpr_id = cpr.cpr_id
      LEFT JOIN dcl_stuff_category stf ON stf.stf_id = lpr.stf_id
    WHERE
          (v_contractor_in IS NULL OR v_contractor_in = '' OR UPPER(ctr.ctr_name) LIKE('%' || v_contractor_in || '%'))
     AND  (v_date_begin IS NULL OR cpr.cpr_date >= v_date_begin)
     AND  (v_date_end IS NULL OR cpr.cpr_date <= v_date_end)
     AND  (v_summ_min IS NULL OR cpr.cpr_summ >= v_summ_min)
     AND  (v_summ_max IS NULL OR cpr.cpr_summ <= v_summ_max)
     AND  (v_user_in IS NULL OR v_user_in = '' OR UPPER(ul.usr_surname || ' ' || ul.usr_name) LIKE('%' || v_user_in || '%'))
     AND  (v_department_in IS NULL OR v_department_in = '' OR UPPER(dep.dep_name) LIKE('%' || v_department_in || '%'))
     AND  (v_stf_name_in IS NULL OR v_stf_name_in = '' OR EXISTS (
            SELECT 1
            FROM dcl_cpr_list_produce lpr2
              JOIN dcl_stuff_category stf2 ON stf2.stf_id = lpr2.stf_id
            WHERE lpr2.cpr_id = cpr.cpr_id
              AND UPPER(stf2.stf_name) LIKE('%' || v_stf_name_in || '%')
          ))
     AND  (cpr_proposal_declined_in IS NULL OR cpr_proposal_declined_in = '' OR cpr.cpr_proposal_declined = cpr_proposal_declined_in)
     AND  (v_received_flag IS NULL OR cpr.cpr_proposal_received_flag = v_received_flag)
     AND  (v_number_in IS NULL OR v_number_in = '' OR UPPER(cpr.cpr_number) LIKE('%' || v_number_in || '%'))
    GROUP BY
      cpr.cpr_id, cpr.cpr_number, cpr.cpr_date, ctr.ctr_name, cpr.cpr_summ, cur.cur_name,
      cpr.cpr_proposal_received_flag, cpr.cpr_proposal_declined, cpr.cpr_block,
      ul.usr_surname, ul.usr_name, cpr.usr_id_create, cpr.cpr_check_price,
      cpr.cpr_check_price_date, ulcp.usr_surname, ulcp.usr_name,
      cpr.cpr_final_date, cpr.cpr_assemble_minsk_store, cpr.cpr_no_reservation, dep.dep_name
    ORDER BY cpr.cpr_date DESC, cpr.cpr_number DESC
  LOOP
    cpr_id := rec.cpr_id;
    cpr_number := rec.cpr_number;
    cpr_date := rec.cpr_date;
    cpr_contractor := rec.ctr_name;
    cpr_summ := rec.cpr_summ;
    cpr_currency := rec.cur_name;
    cpr_stf_name := rec.stf_names;
    cpr_proposal_received_flag := rec.cpr_proposal_received_flag;
    cpr_proposal_declined := rec.cpr_proposal_declined;
    cpr_block := rec.cpr_block;
    cpr_user := rec.cpr_user_val;
    cpr_department := rec.dep_name;
    usr_id_create := rec.usr_id_create;
    cpr_check_price := rec.cpr_check_price;
    cpr_check_price_date := rec.cpr_check_price_date;
    cpr_check_price_user := rec.cpr_check_price_user_val;
    cpr_final_date := rec.cpr_final_date;
    cpr_assemble_minsk_store := rec.cpr_assemble_minsk_store;
    cpr_no_reservation := rec.cpr_no_reservation;
    dep_id := NULL;
    SELECT u2.dep_id FROM dcl_user u2 WHERE u2.usr_id = rec.usr_id_create INTO dep_id;
    RETURN NEXT;
  END LOOP;
END;
$$;


--
-- Name: dcl_commercial_proposal_insert(date, character varying, integer, integer, character varying, character varying, character varying, integer, numeric, numeric, integer, character varying, character varying, character varying, integer, character varying, numeric, smallint, character varying, character varying, character varying, date, character varying, integer, integer, smallint, date, integer, character varying, smallint, smallint, numeric, smallint, numeric, smallint, integer, smallint, smallint, smallint, character varying, integer, smallint, integer, integer, integer, numeric, numeric, integer, smallint, smallint, character varying, integer, smallint, integer, integer, integer, smallint, integer, character varying, character, character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_commercial_proposal_insert(p_cpr_date date, p_cpr_number character varying, p_ctr_id integer, p_cps_id integer, p_cpr_concerning character varying, p_cpr_concerning_invoice character varying, p_cpr_preamble character varying, p_cur_id integer, p_cpr_course numeric, p_cpr_nds numeric, p_trm_id_price_condition integer, p_cpr_country character varying, p_cpr_pay_condition character varying, p_cpr_pay_condition_invoice character varying, p_trm_id_delivery_condition integer, p_cpr_delivery_address character varying, p_cpr_sum_transport numeric, p_cpr_all_transport smallint, p_cpr_delivery_term character varying, p_cpr_delivery_term_invoice character varying, p_cpr_add_info character varying, p_cpr_final_date date, p_cpr_final_date_invoice character varying, p_usr_id integer, p_executor_id integer, p_cpr_executor_flag smallint, p_cpr_date_accept date, p_bln_id integer, p_cpr_img_name character varying, p_cpr_proposal_received_flag smallint, p_cpr_block smallint, p_cpr_summ numeric, p_cpr_nds_by_string smallint, p_cpr_sum_assembling numeric, p_cpr_old_version smallint, p_cur_id_table integer, p_cpr_assemble_minsk_store smallint, p_cpr_free_prices smallint, p_cpr_can_edit_invoice smallint, p_cpr_comment character varying, p_pps_id integer, p_cpr_reverse_calc smallint, p_cps_id_seller integer, p_cps_id_customer integer, p_cpr_guaranty_in_month integer, p_cpr_prepay_percent numeric, p_cpr_prepay_sum numeric, p_cpr_delay_days integer, p_cpr_no_reservation smallint, p_cpr_provider_delivery smallint, p_cpr_provider_delivery_address character varying, p_cpr_delivery_count_day integer, p_cpr_donot_calculate_netto smallint, p_cpr_print_scale integer, p_cpr_contract_scale integer, p_cpr_invoice_scale integer, p_cpr_final_date_above smallint, p_ctr_id_consignee integer, p_cpr_tender_number character varying, p_cpr_tender_number_editable character, p_cpr_proposal_declined character) RETURNS TABLE(cpr_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN

  insert into dcl_commercial_proposal (
      p_cpr_number,
      p_cpr_date,
      p_ctr_id,
      p_cps_id,
      p_cpr_concerning,
      p_cpr_concerning_invoice,
      p_cpr_preamble,
      p_cur_id,
      p_cpr_course,
      p_cpr_nds,
      p_trm_id_price_condition,
      p_cpr_country,
      p_cpr_pay_condition,
      p_cpr_pay_condition_invoice,
      p_trm_id_delivery_condition,
      p_cpr_delivery_address,
      p_cpr_sum_transport,
      p_cpr_all_transport,
      p_cpr_delivery_term,
      p_cpr_delivery_term_invoice,
      p_cpr_add_info,
      p_cpr_final_date,
      p_cpr_final_date_invoice,
      p_usr_id,
      p_executor_id,
      p_cpr_executor_flag,
      p_cpr_date_accept,
      p_bln_id,
      p_cpr_img_name,
      p_cpr_proposal_received_flag,
      p_cpr_block,
      p_cpr_summ,
      p_cpr_nds_by_string,
      p_cpr_sum_assembling,
      p_cpr_old_version,
      p_cur_id_table,
      p_cpr_assemble_minsk_store,
      p_cpr_free_prices,
      p_cpr_can_edit_invoice,
      p_cpr_comment,
      p_pps_id,
      p_cpr_reverse_calc,
      p_cps_id_seller,
      p_cps_id_customer,
      p_cpr_guaranty_in_month,
      p_cpr_prepay_percent,
      p_cpr_prepay_sum,
      p_cpr_delay_days,
      p_cpr_no_reservation,
      p_cpr_provider_delivery,
      p_cpr_provider_delivery_address,
      p_cpr_delivery_count_day,
      p_cpr_donot_calculate_netto,
      p_cpr_print_scale,
      p_cpr_contract_scale,
      p_cpr_invoice_scale,
      p_cpr_final_date_above,
      p_ctr_id_consignee,
      p_cpr_tender_number,
      p_cpr_tender_number_editable,
      p_cpr_proposal_declined
    )
    values (
      p_cpr_number,
      p_cpr_date,
      p_ctr_id,
      p_cps_id,
      p_cpr_concerning,
      p_cpr_concerning_invoice,
      p_cpr_preamble,
      p_cur_id,
      p_cpr_course,
      p_cpr_nds,
      p_trm_id_price_condition,
      p_cpr_country,
      p_cpr_pay_condition,
      p_cpr_pay_condition_invoice,
      p_trm_id_delivery_condition,
      p_cpr_delivery_address,
      p_cpr_sum_transport,
      p_cpr_all_transport,
      p_cpr_delivery_term,
      p_cpr_delivery_term_invoice,
      p_cpr_add_info,
      p_cpr_final_date,
      p_cpr_final_date_invoice,
      p_usr_id,
      p_executor_id,
      p_cpr_executor_flag,
      p_cpr_date_accept,
      p_bln_id,
      p_cpr_img_name,
      p_cpr_proposal_received_flag,
      p_cpr_block,
      p_cpr_summ,
      p_cpr_nds_by_string,
      p_cpr_sum_assembling,
      p_cpr_old_version,
      p_cur_id_table,
      p_cpr_assemble_minsk_store,
      p_cpr_free_prices,
      p_cpr_can_edit_invoice,
      p_cpr_comment,
      p_pps_id,
      p_cpr_reverse_calc,
      p_cps_id_seller,
      p_cps_id_customer,
      p_cpr_guaranty_in_month,
      p_cpr_prepay_percent,
      p_cpr_prepay_sum,
      p_cpr_delay_days,
      p_cpr_no_reservation,
      p_cpr_provider_delivery,
      p_cpr_provider_delivery_address,
      p_cpr_delivery_count_day,
      p_cpr_donot_calculate_netto,
      p_cpr_print_scale,
      p_cpr_contract_scale,
      p_cpr_invoice_scale,
      p_cpr_final_date_above,
      p_ctr_id_consignee,
      p_cpr_tender_number,
      p_cpr_tender_number_editable,
      p_cpr_proposal_declined
    )
    returning cpr_id into cpr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_con_list_spec_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_list_spec_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.spc_id and att.att_parent_table = 'DCL_CON_LIST_SPEC';
RETURN OLD;
END
$$;


--
-- Name: dcl_con_list_spec_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_list_spec_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SPC_ID IS NULL) THEN
    NEW.SPC_ID = nextval('gen_dcl_con_list_spec_id');
  ELSE
        ID = nextval('gen_dcl_con_list_spec_id');
        IF ( ID < NEW.SPC_ID ) THEN
          ID = nextval('gen_dcl_con_list_spec_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_con_list_spec_insert(integer, character varying, date, numeric, numeric, numeric, smallint, date, character varying, smallint, smallint, numeric, numeric, character varying, smallint, smallint, smallint, smallint, smallint, date, character varying, integer, date, date, date, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_list_spec_insert(p_con_id integer, p_spc_number character varying, p_spc_date date, p_spc_summ numeric, p_spc_summ_nds numeric, p_spc_nds_rate numeric, p_spc_executed smallint, p_spc_delivery_date date, p_spc_delivery_cond character varying, p_spc_delivery_term_type smallint, p_spc_percent_or_sum smallint, p_spc_delivery_percent numeric, p_spc_delivery_sum numeric, p_spc_add_pay_cond character varying, p_spc_original smallint, p_spc_montage smallint, p_spc_pay_after_montage smallint, p_spc_group_delivery smallint, p_spc_annul smallint, p_spc_annul_date date, p_spc_comment character varying, p_usr_id integer, p_spc_letter1_date date, p_spc_letter2_date date, p_spc_letter3_date date, p_spc_complaint_in_court_date date, p_spc_additional_days_count integer) RETURNS TABLE(spc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_con_list_spec (
      p_con_id,
      p_spc_number,
      p_spc_date,
      p_spc_summ,
      p_spc_summ_nds,
      p_spc_nds_rate,
      p_spc_executed,
      p_spc_delivery_date,
      p_spc_delivery_cond,
      p_spc_delivery_term_type,
      p_spc_percent_or_sum,
      p_spc_delivery_percent,
      p_spc_delivery_sum,
      p_spc_add_pay_cond,
      p_spc_original,
      p_spc_montage,
      p_spc_pay_after_montage,
      p_spc_group_delivery,
      p_spc_annul,
      p_spc_annul_date,
      p_spc_comment,
      p_usr_id,
      p_spc_letter1_date,
      p_spc_letter2_date,
      p_spc_letter3_date,
      p_spc_complaint_in_court_date,
      p_spc_additional_days_count
  )
  values (
      p_con_id,
      p_spc_number,
      p_spc_date,
      p_spc_summ,
      p_spc_summ_nds,
      p_spc_nds_rate,
      p_spc_executed,
      p_spc_delivery_date,
      p_spc_delivery_cond,
      p_spc_delivery_term_type,
      p_spc_percent_or_sum,
      p_spc_delivery_percent,
      p_spc_delivery_sum,
      p_spc_add_pay_cond,
      p_spc_original,
      p_spc_montage,
      p_spc_pay_after_montage,
      p_spc_group_delivery,
      p_spc_annul,
      p_spc_annul_date,
      p_spc_comment,
      p_usr_id,
      p_spc_letter1_date,
      p_spc_letter2_date,
      p_spc_letter3_date,
      p_spc_complaint_in_court_date,
      p_spc_additional_days_count
  )   
  returning spc_id into spc_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_con_list_spec_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_list_spec_load(p_spc_id_in integer) RETURNS TABLE(spc_id integer, con_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_summ_nds numeric, spc_executed smallint, spc_nds_rate numeric, spc_delivery_date date, spc_add_pay_cond character varying, spc_original smallint, spc_montage smallint, spc_group_delivery smallint, spc_delivery_cond character varying, spc_delivery_term_type smallint, spc_percent_or_sum smallint, spc_delivery_percent numeric, spc_delivery_sum numeric, spc_pay_after_montage smallint, spc_annul smallint, spc_annul_date date, spc_comment character varying, usr_id integer, usr_name character varying, spc_occupied integer, spc_occupied_in_pay_shp integer, spc_in_ctc integer, payed_summ numeric, payed_date date, attachments_count integer, spc_letter1_date date, spc_letter2_date date, spc_letter3_date date, spc_complaint_in_court_date date, spc_additional_days_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  spc_id = null;
  con_id = null;
  spc_number = null;
  spc_date = null;
  spc_summ = null;
  spc_summ_nds = null;
  spc_executed = null;
  spc_nds_rate = null;
  spc_delivery_date = null;
  spc_add_pay_cond = null;
  spc_original = null;
  spc_montage = null;
  spc_group_delivery = null;
  spc_delivery_cond = null;
  spc_delivery_term_type = null;
  spc_percent_or_sum = null;
  spc_delivery_percent = null;
  spc_delivery_sum = null;
  spc_pay_after_montage = null;
  spc_annul = null;
  spc_annul_date = null;
  spc_comment = null;
  usr_id = null;
  usr_name = null;
  spc_occupied = null;
  spc_occupied_in_pay_shp = null;
  spc_in_ctc = null;
  payed_summ = null;
  payed_date = null;
  attachments_count = null;
  spc_letter1_date = null;
  spc_letter2_date = null;
  spc_letter3_date = null;
  spc_complaint_in_court_date = null;
  spc_additional_days_count = null;

  select
      spc_id,
      con_id,
      spc_number,
      spc_date,
      spc_summ,
      spc_summ_nds,
      spc_executed,
      spc_nds_rate,
      spc_delivery_date,
      spc_add_pay_cond,
      spc_delivery_cond,
      spc_delivery_term_type,
      spc_percent_or_sum,
      spc_delivery_percent,
      spc_delivery_sum,
      spc_original,
      spc_montage,
      spc_pay_after_montage,
      spc_group_delivery,
      spc_annul,
      spc_annul_date,
      spc_comment,
      usr_id,
      (select usr_surname || ' ' || usr_name from dcl_user_language where usr_id = spc.usr_id and lng_id = 1),
      spc_letter1_date,
      spc_letter2_date,
      spc_letter3_date,
      spc_complaint_in_court_date,
      spc_additional_days_count
  from dcl_con_list_spec spc
  where spc_id = p_spc_id_in
  into
      spc_id,
      con_id,
      spc_number,
      spc_date,
      spc_summ,
      spc_summ_nds,
      spc_executed,
      spc_nds_rate,
      spc_delivery_date,
      spc_add_pay_cond,
      spc_delivery_cond,
      spc_delivery_term_type,
      spc_percent_or_sum,
      spc_delivery_percent,
      spc_delivery_sum,
      spc_original,
      spc_montage,
      spc_pay_after_montage,
      spc_group_delivery,
      spc_annul,
      spc_annul_date,
      spc_comment,
      usr_id,
      usr_name,
      spc_letter1_date,
      spc_letter2_date,
      spc_letter3_date,
      spc_complaint_in_court_date,
      spc_additional_days_count
  ;

  select spc_id from DCL_OCCUPIED_SPEC_V where spc_id = spc_id into spc_occupied;
  select spc_id from DCL_OCCUPIED_SPEC_IN_PAY_SHP_V where spc_id = spc_id into spc_occupied_in_pay_shp;
  select spc_id from DCL_SPEC_IN_CTC_V where spc_id = spc_id into spc_in_ctc;
  select sum(lps_summ) from dcl_pay_list_summ where spc_id = spc_id into payed_summ;
  select payed_date from dcl_get_payed_date(spc_id, spc_summ, spc_percent_or_sum, spc_delivery_percent, spc_delivery_sum) into payed_date;
  select attachmentsCount from dcl_get_att_count_for_spc(spc_id) into attachments_count;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_con_list_specs_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_list_specs_load(p_con_id_in integer) RETURNS TABLE(spc_id integer, con_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_summ_nds numeric, spc_executed smallint, spc_nds_rate numeric, spc_delivery_date date, spc_add_pay_cond character varying, spc_original smallint, spc_montage smallint, spc_group_delivery smallint, spc_delivery_cond character varying, spc_delivery_term_type smallint, spc_percent_or_sum smallint, spc_delivery_percent numeric, spc_delivery_sum numeric, spc_pay_after_montage smallint, spc_annul smallint, spc_annul_date date, spc_comment character varying, usr_id integer, usr_name character varying, spc_occupied integer, spc_occupied_in_pay_shp integer, spc_in_ctc integer, payed_summ numeric, payed_date date, attachments_count integer, spc_letter1_date date, spc_letter2_date date, spc_letter3_date date, spc_complaint_in_court_date date, spc_additional_days_count integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  con_id = p_con_id_in;

  FOR spc_id IN select spc_id from dcl_con_list_spec spc where spc.con_id = p_con_id_in order by spc_date DESC
  LOOP
    select
      spc_id,
      con_id,
      spc_number,
      spc_date,
      spc_summ,
      spc_summ_nds,
      spc_executed,
      spc_nds_rate,
      spc_delivery_date,
      spc_add_pay_cond,
      spc_delivery_cond,
      spc_delivery_term_type,
      spc_percent_or_sum,
      spc_delivery_percent,
      spc_delivery_sum,
      spc_original,
      spc_montage,
      spc_pay_after_montage,
      spc_group_delivery,
      spc_annul,
      spc_annul_date,
      spc_comment,
      usr_id,
      usr_name,
      spc_occupied,
      spc_occupied_in_pay_shp,
      spc_in_ctc,
      payed_summ,
      payed_date,
      attachments_count,
      spc_letter1_date,
      spc_letter2_date,
      spc_letter3_date,
      spc_complaint_in_court_date,
      spc_additional_days_count
    from dcl_con_list_spec_load(spc_id)
    into
      spc_id,
      con_id,
      spc_number,
      spc_date,
      spc_summ,
      spc_summ_nds,
      spc_executed,
      spc_nds_rate,
      spc_delivery_date,
      spc_add_pay_cond,
      spc_delivery_cond,
      spc_delivery_term_type,
      spc_percent_or_sum,
      spc_delivery_percent,
      spc_delivery_sum,
      spc_original,
      spc_montage,
      spc_pay_after_montage,
      spc_group_delivery,
      spc_annul,
      spc_annul_date,
      spc_comment,
      usr_id,
      usr_name,
      spc_occupied,
      spc_occupied_in_pay_shp,
      spc_in_ctc,
      payed_summ,
      payed_date,
      attachments_count,
      spc_letter1_date,
      spc_letter2_date,
      spc_letter3_date,
      spc_complaint_in_court_date,
      spc_additional_days_count
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_con_message_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_message_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CMS_ID IS NULL) THEN
    NEW.CMS_ID = nextval('gen_dcl_con_message_id');
  ELSE
        ID = nextval('gen_dcl_con_message_id');
        IF ( ID < NEW.CMS_ID ) THEN
          ID = nextval('gen_dcl_con_message_id');
  END IF;
  END IF;

  new.cms_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_con_messages_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_con_messages_load(p_usr_id_in integer) RETURNS TABLE(cms_id integer, cms_create_date timestamp without time zone, cms_message character varying, ctr_id integer, ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select cms_id, cms_create_date, cms_message, ctr_id from dcl_con_message cms where cms.usr_id = p_usr_id_in order by cms_create_date DESC
  LOOP
    cms_id := _rec.cms_id;
    cms_create_date := _rec.cms_create_date;
    cms_message := _rec.cms_message;
    ctr_id := _rec.ctr_id;
    ctr_name := null;
    if (ctr_id is not null) then
      select ctr_name from dcl_contractor where ctr_id = ctr_id into ctr_name;
  END IF;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_cond_for_contract_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  usr_count integer;
BEGIN
  select count(usr_id) from dcl_contractor_user t where t.usr_id = new.usr_id_create and t.ctr_id = new.ctr_id into usr_count;
  if (usr_count = 0) then
    insert into dcl_contractor_user (ctr_id, usr_id) values (new.ctr_id, new.usr_id_create);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cond_for_contract_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.cfc_id and att.att_parent_table = 'DCL_COND_FOR_CONTRACT';
RETURN OLD;
END
$$;


--
-- Name: dcl_cond_for_contract_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CFC_ID IS NULL) THEN
    NEW.CFC_ID = nextval('gen_dcl_cond_for_contract_id');
  ELSE
        ID = nextval('gen_dcl_cond_for_contract_id');
        IF ( ID < NEW.CFC_ID ) THEN
          ID = nextval('gen_dcl_cond_for_contract_id');
  END IF;
  END IF;

  new.cfc_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.cfc_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
  if ( new.cfc_place is not null ) then
    new.cfc_place_date = CURRENT_TIMESTAMP;
    new.usr_id_place = get_context('usr_id');
  END IF;
  if ( new.cfc_execute is not null ) then
    new.cfc_execute_date = CURRENT_TIMESTAMP;
    new.usr_id_execute = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cond_for_contract_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.cfc_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');

  if ( new.cfc_place is not null and old.cfc_place is null ) then -- установка размещения
    new.cfc_place_date = CURRENT_TIMESTAMP;
    new.usr_id_place = get_context('usr_id');
  END IF;
  if ( old.cfc_place is not null and new.cfc_place is null ) then -- установка размещения
    new.cfc_place_date = null;
    new.usr_id_place = null;
  END IF;

  if ( new.cfc_execute is not null and old.cfc_execute is null ) then
    new.cfc_execute_date = CURRENT_TIMESTAMP;
    new.usr_id_execute = get_context('usr_id');
  END IF;

  if ( new.cfc_annul is not null and old.cfc_annul is null ) then -- установка аннулирования
    new.cfc_edit_annul_date = CURRENT_TIMESTAMP;
    new.usr_id_edit_annul = get_context('usr_id');
  END IF;
  if ( new.cfc_annul is null and old.cfc_annul is not null ) then -- снятие аннулирования
    new.cfc_edit_annul_date = null;
    new.usr_id_edit_annul = null;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cond_for_contract_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_filter(cfc_contractor_in character varying, cfc_user_in character varying, cfc_date_begin_in character varying, cfc_date_end_in character varying, sln_seller_in character varying, cfc_not_executed_in character varying, annul_exclude_in character varying, cfc_not_placed_in character varying) RETURNS TABLE(cfc_id integer, cfc_place_date timestamp without time zone, cfc_contractor character varying, cfc_user character varying, cfc_execute smallint, cfc_seller character varying, executed_and_placed smallint, usr_id integer, dep_id integer, cfc_check_price smallint, cfc_check_price_date timestamp without time zone, cfc_check_price_user character varying, cfc_annul smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_contractor_in VARCHAR := UPPER(cfc_contractor_in);
  v_user_in VARCHAR := UPPER(cfc_user_in);
  v_seller_in VARCHAR := UPPER(sln_seller_in);
  v_date_begin TIMESTAMP := CASE WHEN cfc_date_begin_in IS NOT NULL AND cfc_date_begin_in != '' THEN cfc_date_begin_in::TIMESTAMP ELSE NULL END;
  v_date_end TIMESTAMP := CASE WHEN cfc_date_end_in IS NOT NULL AND cfc_date_end_in != '' THEN cfc_date_end_in::TIMESTAMP ELSE NULL END;
  v_not_executed SMALLINT := CASE WHEN cfc_not_executed_in IS NOT NULL AND cfc_not_executed_in != '' THEN cfc_not_executed_in::SMALLINT ELSE NULL END;
  v_annul_exclude SMALLINT := CASE WHEN annul_exclude_in IS NOT NULL AND annul_exclude_in != '' THEN annul_exclude_in::SMALLINT ELSE NULL END;
  v_not_placed SMALLINT := CASE WHEN cfc_not_placed_in IS NOT NULL AND cfc_not_placed_in != '' THEN cfc_not_placed_in::SMALLINT ELSE NULL END;
  rec RECORD;
  cfc_place_val SMALLINT;
BEGIN
  IF v_date_end IS NOT NULL THEN
    v_date_end := v_date_end + INTERVAL '1 day';
  END IF;

  FOR rec IN
    SELECT cfc.cfc_id,
           cfc.cfc_place_date,
           (SELECT ctr_name FROM dcl_contractor WHERE ctr_id = cfc.ctr_id) AS cfc_contractor_val,
           (SELECT usr_surname || ' ' || usr_name FROM dcl_user_language WHERE usr_id = cfc.usr_id_create AND lng_id = 1) AS cfc_user_val,
           cfc.cfc_execute,
           (SELECT sln_name FROM dcl_seller WHERE sln_id = cfc.sln_id) AS cfc_seller_val,
           cfc.cfc_check_price,
           cfc.cfc_check_price_date,
           (SELECT usr_surname || ' ' || usr_name FROM dcl_user_language WHERE usr_id = cfc.usr_id_check_price AND lng_id = 1) AS cfc_check_price_user_val,
           cfc.cfc_place,
           cfc.usr_id_create,
           cfc.cfc_annul
    FROM dcl_cond_for_contract cfc
    WHERE
          (v_not_executed IS NULL OR (v_not_executed IS NOT NULL AND cfc.cfc_execute IS NULL))
     AND  (v_annul_exclude IS NULL OR (v_annul_exclude IS NOT NULL AND cfc.cfc_annul IS NULL))
     AND  (v_not_placed IS NOT NULL OR (v_not_placed IS NULL AND cfc.cfc_place IS NOT NULL))
     AND  (v_date_begin IS NULL OR cfc.cfc_execute IS NULL OR cfc.cfc_place_date >= v_date_begin)
     AND  (v_date_end IS NULL OR cfc.cfc_execute IS NULL OR cfc.cfc_place_date <= v_date_end)
     AND  (v_contractor_in IS NULL OR v_contractor_in = '' OR (SELECT UPPER(ctr.ctr_name) FROM dcl_contractor ctr WHERE ctr_id = cfc.ctr_id) LIKE('%' || v_contractor_in || '%'))
     AND  (v_user_in IS NULL OR v_user_in = '' OR (SELECT UPPER(usr.usr_surname || ' ' || usr.usr_name) FROM dcl_user_language usr WHERE usr_id = cfc.usr_id_create AND lng_id = 1) LIKE('%' || v_user_in || '%'))
     AND  (v_seller_in IS NULL OR v_seller_in = '' OR (SELECT UPPER(sln.sln_name) FROM dcl_seller sln WHERE sln_id = cfc.sln_id) LIKE('%' || v_seller_in || '%'))
    ORDER BY cfc.cfc_place, cfc.cfc_place_date DESC
  LOOP
    cfc_id := rec.cfc_id;
    cfc_place_date := rec.cfc_place_date;
    cfc_contractor := rec.cfc_contractor_val;
    cfc_user := rec.cfc_user_val;
    cfc_execute := rec.cfc_execute;
    cfc_seller := rec.cfc_seller_val;
    cfc_check_price := rec.cfc_check_price;
    cfc_check_price_date := rec.cfc_check_price_date;
    cfc_check_price_user := rec.cfc_check_price_user_val;
    cfc_annul := rec.cfc_annul;
    usr_id := rec.usr_id_create;

    executed_and_placed := 1;
    IF rec.cfc_place IS NULL AND rec.cfc_execute IS NULL THEN
      executed_and_placed := NULL;
    END IF;

    dep_id := NULL;
    IF rec.usr_id_create IS NOT NULL THEN
      SELECT u.dep_id FROM dcl_user u WHERE u.usr_id = rec.usr_id_create INTO dep_id;
    END IF;

    RETURN NEXT;
  END LOOP;
END;
$$;


--
-- Name: dcl_cond_for_contract_insert(smallint, smallint, integer, integer, smallint, character varying, date, integer, integer, character varying, date, character varying, character varying, character varying, character varying, character varying, date, character varying, integer, integer, smallint, integer, character varying, smallint, smallint, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cond_for_contract_insert(p_cfc_place smallint, p_cfc_execute smallint, p_sln_id integer, p_ctr_id integer, p_cfc_doc_type smallint, p_cfc_con_number_txt character varying, p_cfc_con_date date, p_cur_id integer, p_con_id integer, p_cfc_spc_number_txt character varying, p_cfc_spc_date date, p_cfc_pay_cond character varying, p_cfc_custom_point character varying, p_cfc_delivery_cond character varying, p_cfc_guarantee_cond character varying, p_cfc_montage_cond character varying, p_cfc_date_con_to date, p_cfc_count_delivery character varying, p_cps_id_sign integer, p_cps_id integer, p_cfc_delivery_count smallint, p_pps_id integer, p_cfc_comment character varying, p_cfc_need_invoice smallint, p_cfc_annul smallint, p_cfc_annul_date date) RETURNS TABLE(cfc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_cond_for_contract(
      p_cfc_place,
      p_cfc_execute,
      p_sln_id,
      p_ctr_id,
      p_cfc_doc_type,
      p_cfc_con_number_txt,
      p_cfc_con_date,
      p_cur_id,
      p_con_id,
      p_cfc_spc_number_txt,
      p_cfc_spc_date,
      p_cfc_pay_cond,
      p_cfc_custom_point,
      p_cfc_delivery_cond,
      p_cfc_guarantee_cond,
      p_cfc_montage_cond,
      p_cfc_date_con_to,
      p_cfc_count_delivery,
      p_cps_id_sign,
      p_cps_id,
      p_cfc_delivery_count,
      p_pps_id,
      p_cfc_comment,
      p_cfc_need_invoice,
      p_cfc_annul,
      p_cfc_annul_date
    )
    values(
     p_cfc_place,
     p_cfc_execute,
     p_sln_id,
     p_ctr_id,
     p_cfc_doc_type,
     p_cfc_con_number_txt,
     p_cfc_con_date,
     p_cur_id,
     p_con_id,
     p_cfc_spc_number_txt,
     p_cfc_spc_date,
     p_cfc_pay_cond,
     p_cfc_custom_point,
     p_cfc_delivery_cond,
     p_cfc_guarantee_cond,
     p_cfc_montage_cond,
     p_cfc_date_con_to,
     p_cfc_count_delivery,
     p_cps_id_sign,
     p_cps_id,
     p_cfc_delivery_count,
     p_pps_id,
     p_cfc_comment,
     p_cfc_need_invoice,
     p_cfc_annul,
     p_cfc_annul_date
    )
    returning cfc_id into cfc_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contact_person_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contact_person_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CPS_ID IS NULL) THEN
    NEW.CPS_ID = nextval('gen_dcl_contact_person_id');
  ELSE
        ID = nextval('gen_dcl_contact_person_id');
        IF ( ID < NEW.CPS_ID ) THEN
          ID = nextval('gen_dcl_contact_person_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_contact_person_insert(integer, character varying, character varying, character varying, character varying, smallint, character varying, character varying, character varying, character varying, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contact_person_insert(p_ctr_id integer, p_cps_name character varying, p_cps_phone character varying, p_cps_mob_phone character varying, p_cps_fax character varying, p_cps_block smallint, p_cps_position character varying, p_cps_on_reason character varying, p_cps_email character varying, p_cps_contract_comment character varying, p_cps_fire smallint) RETURNS TABLE(cps_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_contact_person (
     p_ctr_id,
     p_cps_name,
     p_cps_phone,
     p_cps_mob_phone,
     p_cps_fax,
     p_cps_block,
     p_cps_position,
     p_cps_on_reason,
     p_cps_email,
     p_cps_contract_comment,
     p_cps_fire
  )
  values(
     p_ctr_id,
     p_cps_name,
     p_cps_phone,
     p_cps_mob_phone,
     p_cps_fax,
     p_cps_block,
     p_cps_position,
     p_cps_on_reason,
     p_cps_email,
     p_cps_contract_comment,
     p_cps_fire
  )
  returning cps_id into cps_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contract_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.con_id and att.att_parent_table = 'DCL_CONTRACT';
RETURN OLD;
END
$$;


--
-- Name: dcl_contract_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CON_ID IS NULL) THEN
    NEW.CON_ID = nextval('gen_dcl_contract_id');
  ELSE
        ID = nextval('gen_dcl_contract_id');
        IF ( ID < NEW.CON_ID ) THEN
          ID = nextval('gen_dcl_contract_id');
  END IF;
  END IF;

  new.con_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.con_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contract_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.con_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contract_closed_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_closed_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CTC_ID IS NULL) THEN
    NEW.CTC_ID = nextval('gen_dcl_contract_closed_id');
  ELSE
        ID = nextval('gen_dcl_contract_closed_id');
        IF ( ID < NEW.CTC_ID ) THEN
          ID = nextval('gen_dcl_contract_closed_id');
  END IF;
  END IF;
    select max(ctc_number) from DCL_CONTRACT_CLOSED into NEW.ctc_number;
    if (NEW.ctc_number is null) then
        NEW.ctc_number = 0;
  END IF;
    new.ctc_number = NEW.ctc_number + 1;
    new.ctc_create_date = CURRENT_TIMESTAMP;
    new.usr_id_create = get_context('usr_id');
    new.ctc_edit_date = CURRENT_TIMESTAMP;
    new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contract_closed_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_closed_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.ctc_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contract_closed_filter(character varying, character varying, date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_closed_filter(p_ctc_number_in character varying, p_ctc_contractor_in character varying, p_ctc_date_begin_in date, p_ctc_date_end_in date, p_ctc_not_block_in smallint) RETURNS TABLE(ctc_id integer, ctc_number character varying, ctc_contractor character varying, ctc_date date, ctc_block smallint, usr_id_create integer, con_number character varying, con_date date, show_warn smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ctc_number_in VARCHAR(50);
  v_ctc_contractor_in VARCHAR(200);
  v_ctr_count INTEGER;
  v_con_count INTEGER;
  v_found_rec_ctr INTEGER;
  v_found_rec_con INTEGER;
  v_ctc_contractor_filter VARCHAR(200);
  v_con_number_filter VARCHAR(50);
  v_copy_project_count INTEGER;
  v_unblocked_prc_count INTEGER;
  v_shp_count INTEGER;
  rec RECORD;
  crec RECORD;
BEGIN
  v_ctc_number_in := upper(p_ctc_number_in);
  v_ctc_contractor_in := upper(p_ctc_contractor_in);

  FOR rec IN
    SELECT c.ctc_id, c.ctc_number, c.ctc_date, c.ctc_block, c.usr_id_create
    FROM dcl_contract_closed c
    WHERE (p_ctc_date_begin_in IS NULL OR c.ctc_date >= p_ctc_date_begin_in)
      AND (p_ctc_date_end_in IS NULL OR c.ctc_date <= p_ctc_date_end_in)
      AND ((p_ctc_not_block_in IS NULL) OR (p_ctc_not_block_in IS NOT NULL AND c.ctc_block IS NULL))
    ORDER BY c.ctc_date DESC
  LOOP
    ctc_id := rec.ctc_id;
    ctc_number := rec.ctc_number;
    ctc_date := rec.ctc_date;
    ctc_block := rec.ctc_block;
    usr_id_create := rec.usr_id_create;

    v_found_rec_ctr := 0;
    v_ctr_count := 0;

    SELECT count(ctr.ctr_id) INTO v_ctr_count
    FROM dcl_contractor ctr
    JOIN dcl_contract con2 ON ctr.ctr_id = con2.ctr_id
    JOIN dcl_con_list_spec spc ON spc.con_id = con2.con_id
    JOIN dcl_ctc_list lcc ON spc.spc_id = lcc.spc_id
    WHERE lcc.ctc_id = rec.ctc_id;

    IF v_ctr_count > 1 THEN
      ctc_contractor := '';
      IF v_ctc_contractor_in IS NULL OR v_ctc_contractor_in = '' THEN
        v_found_rec_ctr := 1;
      ELSE
        FOR crec IN
          SELECT upper(ctr.ctr_name) AS ctr_name_upper
          FROM dcl_contractor ctr
          JOIN dcl_contract con2 ON ctr.ctr_id = con2.ctr_id
          JOIN dcl_con_list_spec spc ON spc.con_id = con2.con_id
          JOIN dcl_ctc_list lcc ON spc.spc_id = lcc.spc_id
          WHERE lcc.ctc_id = rec.ctc_id
        LOOP
          IF v_ctc_contractor_in IS NULL OR crec.ctr_name_upper LIKE '%' || v_ctc_contractor_in || '%' THEN
            v_found_rec_ctr := 1;
            EXIT;
          END IF;
        END LOOP;
      END IF;
    ELSE
      SELECT ctr.ctr_name, upper(ctr.ctr_name)
      INTO ctc_contractor, v_ctc_contractor_filter
      FROM dcl_contractor ctr
      JOIN dcl_contract con2 ON ctr.ctr_id = con2.ctr_id
      JOIN dcl_con_list_spec spc ON spc.con_id = con2.con_id
      JOIN dcl_ctc_list lcc ON spc.spc_id = lcc.spc_id
      WHERE lcc.ctc_id = rec.ctc_id
      LIMIT 1;

      IF v_ctc_contractor_in IS NULL OR v_ctc_contractor_filter LIKE '%' || v_ctc_contractor_in || '%' THEN
        v_found_rec_ctr := 1;
      END IF;
    END IF;

    IF v_found_rec_ctr = 1 THEN
      v_found_rec_con := 0;
      v_con_count := 0;

      SELECT count(con2.con_id) INTO v_con_count
      FROM dcl_ctc_list lcc
      JOIN dcl_con_list_spec spc ON spc.spc_id = lcc.spc_id
      JOIN dcl_contract con2 ON spc.con_id = con2.con_id
      WHERE lcc.ctc_id = rec.ctc_id;

      IF v_con_count > 1 THEN
        con_number := '';
        con_date := NULL;
        IF v_ctc_number_in IS NULL OR v_ctc_number_in = '' THEN
          v_found_rec_con := 1;
        ELSE
          FOR crec IN
            SELECT upper(con2.con_number) AS con_number_upper
            FROM dcl_ctc_list lcc
            JOIN dcl_con_list_spec spc ON spc.spc_id = lcc.spc_id
            JOIN dcl_contract con2 ON spc.con_id = con2.con_id
            WHERE lcc.ctc_id = rec.ctc_id
          LOOP
            IF v_ctc_number_in IS NULL OR crec.con_number_upper LIKE '%' || v_ctc_number_in || '%' THEN
              v_found_rec_con := 1;
              EXIT;
            END IF;
          END LOOP;
        END IF;
      ELSE
        SELECT con2.con_number, con2.con_date, upper(con2.con_number)
        INTO con_number, con_date, v_con_number_filter
        FROM dcl_ctc_list lcc
        JOIN dcl_con_list_spec spc ON spc.spc_id = lcc.spc_id
        JOIN dcl_contract con2 ON spc.con_id = con2.con_id
        WHERE lcc.ctc_id = rec.ctc_id
        LIMIT 1;

        IF v_ctc_number_in IS NULL OR v_con_number_filter LIKE '%' || v_ctc_number_in || '%' THEN
          v_found_rec_con := 1;
        END IF;
      END IF;
    END IF;

    IF v_found_rec_ctr = 1 AND v_found_rec_con = 1 THEN
      show_warn := NULL;

      SELECT count(spc.spc_id) INTO v_copy_project_count
      FROM dcl_ctc_list lcc
      JOIN dcl_con_list_spec spc ON spc.spc_id = lcc.spc_id
      JOIN dcl_contract con2 ON con2.con_id = spc.con_id
      WHERE lcc.ctc_id = rec.ctc_id
        AND (con2.con_original IS NULL OR con2.con_original = 0 OR spc.spc_original IS NULL OR spc.spc_original = 0);

      IF v_copy_project_count > 0 THEN
        show_warn := 1;
      END IF;

      IF show_warn IS NULL THEN
        SELECT coalesce(count(lps.lps_id), 0) INTO v_unblocked_prc_count
        FROM dcl_ctc_list lcc
        JOIN dcl_ctc_shp cshp ON cshp.lcc_id = lcc.lcc_id
        JOIN dcl_shp_list_produce lps ON lps.shp_id = cshp.shp_id
        JOIN dcl_prc_list_produce lpc ON lpc.lpc_id = lps.lpc_id
        JOIN dcl_produce_cost prc ON prc.prc_id = lpc.prc_id
        WHERE lcc.ctc_id = rec.ctc_id AND prc.prc_block IS NULL;

        IF v_unblocked_prc_count != 0 THEN
          show_warn := 1;
        END IF;
      END IF;

      IF show_warn IS NULL THEN
        SELECT coalesce(count(shp.shp_id), 0) INTO v_shp_count
        FROM dcl_ctc_list lcc
        JOIN dcl_ctc_shp cshp ON cshp.lcc_id = lcc.lcc_id
        JOIN dcl_shipping shp ON shp.shp_id = cshp.shp_id
        WHERE lcc.ctc_id = rec.ctc_id AND shp.shp_original IS NULL;

        IF v_shp_count != 0 THEN
          show_warn := 1;
        END IF;
      END IF;

      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_contract_closed_insert(date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_closed_insert(p_ctc_date date, p_ctc_block smallint) RETURNS TABLE(ctc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_contract_closed (
    p_ctc_date,
    p_ctc_block
  )
  values (
    p_ctc_date,
    p_ctc_block
  )
  returning ctc_id into ctc_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contract_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_filter(con_number_in character varying, con_contractor_in character varying, con_date_begin_in character varying, con_date_end_in character varying, con_summ_min_in character varying, con_summ_max_in character varying, con_user_in character varying, con_executed_in character varying, oridinal_absent_in character varying, sln_seller_in character varying) RETURNS TABLE(con_id integer, con_number character varying, con_date date, con_contractor character varying, con_summ numeric, con_currency character varying, con_executed smallint, con_user character varying, con_reminder smallint, con_annul smallint, spc_count integer, attach_idx integer, usr_id_list character varying, dep_id_list character varying, con_reusable smallint, con_final_date date, con_original smallint, spc_numbers_no_original character varying, day_before_final integer, no_delivery_date smallint, incorrect_final_date smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_number_in VARCHAR := UPPER(con_number_in);
  v_contractor_in VARCHAR := UPPER(con_contractor_in);
  v_user_in VARCHAR := UPPER(con_user_in);
  v_seller_in VARCHAR := UPPER(sln_seller_in);
  v_date_begin DATE := CASE WHEN con_date_begin_in IS NOT NULL AND con_date_begin_in != '' THEN con_date_begin_in::DATE ELSE NULL END;
  v_date_end DATE := CASE WHEN con_date_end_in IS NOT NULL AND con_date_end_in != '' THEN con_date_end_in::DATE ELSE NULL END;
  v_summ_min DECIMAL(15,2) := CASE WHEN con_summ_min_in IS NOT NULL AND con_summ_min_in != '' THEN con_summ_min_in::DECIMAL(15,2) ELSE NULL END;
  v_summ_max DECIMAL(15,2) := CASE WHEN con_summ_max_in IS NOT NULL AND con_summ_max_in != '' THEN con_summ_max_in::DECIMAL(15,2) ELSE NULL END;
  v_executed SMALLINT := CASE WHEN con_executed_in IS NOT NULL AND con_executed_in != '' THEN con_executed_in::SMALLINT ELSE NULL END;
  v_oridinal SMALLINT := CASE WHEN oridinal_absent_in IS NOT NULL AND oridinal_absent_in != '' THEN oridinal_absent_in::SMALLINT ELSE NULL END;
  rec RECORD;
  spc_rec RECORD;
  spc_summ_val DECIMAL(15,2);
  spc_delivery_date_val DATE;
  spc_delivery_term_type_val SMALLINT;
  spc_percent_or_sum_val SMALLINT;
  spc_delivery_percent_val DECIMAL(15,2);
  spc_delivery_sum_val DECIMAL(15,2);
  payed_summ_val DECIMAL(15,2);
  con_attach_count_val INTEGER;
  spc_id_val INTEGER;
  spc_have_no_attach SMALLINT;
  spc_have_some_attach SMALLINT;
  spc_have_all_attach SMALLINT;
  spc_attach_count_val INTEGER;
  spc_number_val VARCHAR(50);
  usr_dep_rec RECORD;
BEGIN
  FOR rec IN
    SELECT c.con_id, c.con_number, c.con_date,
           (SELECT ctr_name FROM dcl_contractor WHERE ctr_id = c.ctr_id) AS ctr_name,
           c.con_summ,
           (SELECT cur_name FROM dcl_currency WHERE cur_id = c.cur_id) AS cur_name,
           c.con_executed, c.con_annul, c.con_reusable, c.con_final_date, c.con_original
    FROM dcl_contract c
    WHERE
          (v_contractor_in IS NULL OR v_contractor_in = '' OR (SELECT UPPER(ctr.ctr_name) FROM dcl_contractor ctr WHERE ctr_id = c.ctr_id) LIKE('%' || v_contractor_in || '%'))
     AND  (v_executed IS NULL OR (v_executed = 1 AND c.con_executed = v_executed) OR (v_executed = 0 AND c.con_executed IS NULL))
     AND  (v_oridinal IS NULL OR
           (v_oridinal = 1 AND
            (c.con_original != 1 OR c.con_original IS NULL OR
             (SELECT COALESCE(COUNT(spc.spc_id), 0) FROM dcl_con_list_spec spc
              WHERE spc.con_id = c.con_id AND (spc.spc_original != 1 OR spc.spc_original IS NULL)
              AND (v_user_in IS NULL OR v_user_in = '' OR
                   (SELECT UPPER(usr.usr_surname || ' ' || usr.usr_name) FROM dcl_user_language usr WHERE usr.usr_id = spc.usr_id AND usr.lng_id = 1) LIKE('%' || v_user_in || '%'))
             ) > 0
            )
           )
          )
     AND  (v_seller_in IS NULL OR v_seller_in = '' OR (SELECT UPPER(sln.sln_name) FROM dcl_seller sln WHERE sln_id = c.sln_id) LIKE('%' || v_seller_in || '%'))
     AND  (v_date_begin IS NULL OR c.con_date >= v_date_begin)
     AND  (v_date_end IS NULL OR c.con_date <= v_date_end)
     AND  (v_summ_min IS NULL OR c.con_summ >= v_summ_min)
     AND  (v_summ_max IS NULL OR c.con_summ <= v_summ_max)
     AND  (v_number_in IS NULL OR v_number_in = '' OR UPPER(c.con_number) LIKE('%' || v_number_in || '%'))
  LOOP
    con_id := rec.con_id;
    con_number := rec.con_number;
    con_date := rec.con_date;
    con_contractor := rec.ctr_name;
    con_summ := rec.con_summ;
    con_currency := rec.cur_name;
    con_executed := rec.con_executed;
    con_annul := rec.con_annul;
    con_reusable := rec.con_reusable;
    con_final_date := rec.con_final_date;
    con_original := rec.con_original;

    SELECT ud.con_user, ud.usr_id_list, ud.dep_id_list
    FROM dcl_get_usr_dep_list_con(rec.con_id) ud
    INTO con_user, usr_id_list, dep_id_list;

    IF v_user_in IS NULL OR v_user_in = '' OR UPPER(con_user) LIKE('%' || v_user_in || '%') THEN
      con_reminder := NULL;
      no_delivery_date := NULL;
      incorrect_final_date := NULL;

      spc_have_no_attach := 1;
      spc_have_some_attach := 0;
      spc_have_all_attach := 1;

      FOR spc_rec IN
        SELECT spc.spc_id, spc.spc_summ, spc.spc_delivery_date,
               spc.spc_delivery_term_type, spc.spc_percent_or_sum,
               spc.spc_delivery_percent, spc.spc_delivery_sum,
               (SELECT SUM(lps_summ) FROM dcl_pay_list_summ psum WHERE psum.spc_id = spc.spc_id) AS payed
        FROM dcl_con_list_spec spc
        WHERE spc.con_id = rec.con_id
      LOOP
        IF spc_rec.spc_delivery_term_type = 2 AND spc_rec.spc_percent_or_sum IS NOT NULL AND spc_rec.spc_delivery_date IS NULL THEN
          IF spc_rec.spc_percent_or_sum = 0 AND spc_rec.spc_delivery_percent <= COALESCE(spc_rec.payed, 0) / NULLIF(spc_rec.spc_summ, 0) * 100 THEN
            con_reminder := 1;
            no_delivery_date := 1;
          END IF;
          IF spc_rec.spc_percent_or_sum = 1 AND spc_rec.spc_delivery_sum <= COALESCE(spc_rec.payed, 0) THEN
            con_reminder := 1;
            no_delivery_date := 1;
          END IF;
        END IF;

        SELECT ac.attachmentscount FROM dcl_get_att_count_for_spc(spc_rec.spc_id) ac INTO spc_attach_count_val;
        IF spc_attach_count_val > 0 THEN
          spc_have_no_attach := 0;
          spc_have_some_attach := 1;
        END IF;
        IF spc_attach_count_val = 0 THEN
          spc_have_all_attach := 0;
        END IF;
      END LOOP;

      SELECT COUNT(spc.spc_id)::INTEGER FROM dcl_con_list_spec spc WHERE spc.con_id = rec.con_id INTO spc_count;
      SELECT COUNT(*)::INTEGER FROM dcl_attachment WHERE att_parent_id = rec.con_id AND att_parent_table='DCL_CONTRACT' INTO con_attach_count_val;

      IF spc_count = 0 THEN
        spc_have_all_attach := 0;
      END IF;

      attach_idx := NULL;
      IF con_attach_count_val = 0 AND spc_have_no_attach = 1 THEN attach_idx := 1; END IF;
      IF con_attach_count_val = 0 AND spc_have_some_attach = 1 THEN attach_idx := 2; END IF;
      IF con_attach_count_val = 0 AND spc_have_all_attach = 1 THEN attach_idx := 3; END IF;
      IF con_attach_count_val > 0 AND spc_have_no_attach = 1 THEN attach_idx := 4; END IF;
      IF con_attach_count_val > 0 AND spc_have_some_attach = 1 THEN attach_idx := 5; END IF;
      IF con_attach_count_val > 0 AND spc_have_all_attach = 1 THEN attach_idx := 6; END IF;

      spc_numbers_no_original := '';
      FOR spc_number_val IN
        SELECT s.spc_number
        FROM dcl_con_list_spec s
        WHERE s.con_id = rec.con_id AND (s.spc_original = 0 OR s.spc_original IS NULL) AND s.spc_annul IS NULL
      LOOP
        spc_numbers_no_original := spc_numbers_no_original || spc_number_val || ', ';
      END LOOP;

      day_before_final := 0;
      IF rec.con_final_date IS NOT NULL THEN
        SELECT cd.count_day FROM dcl_get_count_day(rec.con_final_date, CURRENT_DATE) cd INTO day_before_final;
        IF day_before_final <= 35 AND rec.con_executed IS NULL THEN
          IF rec.con_annul IS NULL THEN
            con_reminder := 1;
          END IF;
          incorrect_final_date := 1;
        END IF;
      END IF;

      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_contract_for_cc_filter(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_for_cc_filter(p_ctr_id integer) RETURNS TABLE(con_id integer, con_number character varying, con_date date, cur_id integer, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
    if (p_ctr_id is null) then
  FOR _rec IN select con_id, con_number, con_date, cur.cur_id, cur.cur_name from dcl_contract con, dcl_currency cur where cur.cur_id = con.cur_id
  LOOP
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    cur_id := _rec.cur_id;
    cur_name := _rec.cur_name;
        RETURN NEXT;
  END LOOP;
    else
  FOR _rec IN select con.con_id, con.con_number, con.con_date, cur.cur_id, cur.cur_name from dcl_ctc_list lcc, dcl_contract con, dcl_con_list_spec spc, dcl_currency cur where con.p_ctr_id = p_ctr_id and spc.con_id = con.con_id and spc.spc_id = lcc.spc_id and cur.cur_id = con.cur_id
  LOOP
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    cur_id := _rec.cur_id;
    cur_name := _rec.cur_name;
        RETURN NEXT;
  END LOOP;
  END IF;
END
$$;


--
-- Name: dcl_contract_for_contractor(integer, integer, character varying, character varying, smallint, smallint, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_for_contractor(p_ctr_id integer, p_cur_id_in integer, p_con_number_in character varying, p_con_seller_in character varying, p_all_con smallint, p_only_reusable smallint, p_con_final_date_after date) RETURNS TABLE(con_id integer, con_number character varying, con_date date, sln_id integer, sln_name character varying, sln_is_resident smallint, cur_id integer, cur_name character varying, con_reusable smallint, con_final_date date, con_annul smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  p_con_number_in = upper(p_con_number_in);
  FOR _rec IN select con.con_id, con.con_number, con.con_date, con.sln_id, cur.cur_id, cur.cur_name, con.con_reusable, con.con_final_date, con.con_annul from dcl_contract con, dcl_currency cur where con.p_ctr_id = p_ctr_id and cur.cur_id = con.cur_id and con.cur_id = coalesce(p_cur_id_in, con.cur_id) and ( p_all_con is not null or ( p_all_con is null and (con_executed != 1 or con_executed is null) ) ) and ( p_only_reusable is null or con.con_reusable = p_only_reusable ) and ( con.sln_id is null or con.sln_id in (select int_id from dcl_decode_id_list(p_con_seller_in)) ) and ( p_con_number_in is null or ( upper(con.con_number) like ('%' || p_con_number_in || '%') ) ) and ( p_con_final_date_after is null or con.con_final_date > p_con_final_date_after ) order by con_date DESC, con_number DESC
  LOOP
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    sln_id := _rec.sln_id;
    cur_id := _rec.cur_id;
    cur_name := _rec.cur_name;
    con_reusable := _rec.con_reusable;
    con_final_date := _rec.con_final_date;
    con_annul := _rec.con_annul;
    sln_name := '';
    if ( sln_id is not null ) then
      select sln_name, sln_is_resident from dcl_seller where sln_id = sln_id into sln_name, sln_is_resident;
  END IF;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_contract_insert(date, integer, integer, character varying, smallint, numeric, smallint, smallint, date, character varying, integer, smallint, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contract_insert(p_con_date date, p_ctr_id integer, p_cur_id integer, p_con_number character varying, p_con_executed smallint, p_con_summ numeric, p_con_original smallint, p_con_annul smallint, p_con_annul_date date, p_con_comment character varying, p_sln_id integer, p_con_reusable smallint, p_con_final_date date) RETURNS TABLE(con_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_contract (
     p_con_number,
     p_con_date,
     p_ctr_id,
     p_cur_id,
     p_con_executed,
     p_con_summ,
     p_con_original,
     p_con_annul,
     p_con_annul_date,
     p_con_comment,
     p_sln_id,
     p_con_reusable,
     p_con_final_date
    )
    values (
     p_con_number,
     p_con_date,
     p_ctr_id,
     p_cur_id,
     p_con_executed,
     p_con_summ,
     p_con_original,
     p_con_annul,
     p_con_annul_date,
     p_con_comment,
     p_sln_id,
     p_con_reusable,
     p_con_final_date
   )
   returning con_id into con_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contractor_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CTR_ID IS NULL) THEN
    NEW.CTR_ID = nextval('gen_dcl_contractor_id');
  ELSE
    ID = nextval('gen_dcl_contractor_id');
    IF ( ID < NEW.CTR_ID ) THEN
      ID = nextval('gen_dcl_contractor_id');
  END IF;
  END IF;

  new.ctr_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.ctr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contractor_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.ctr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contractor_filter(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_filter(p_ctr_name_in character varying) RETURNS TABLE(ctr_id integer, ctr_name character varying, ctr_email character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ctr_name_in VARCHAR(200);
BEGIN
  v_ctr_name_in := upper(p_ctr_name_in);
  RETURN QUERY
    SELECT c.ctr_id, c.ctr_name, c.ctr_email
    FROM dcl_contractor c
    WHERE (v_ctr_name_in IS NULL OR v_ctr_name_in = '' OR upper(c.ctr_name) LIKE '%' || v_ctr_name_in || '%')
    ORDER BY upper(c.ctr_name);
END;
$$;


--
-- Name: dcl_contractor_filter_full(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_filter_full(p_ctr_name_in character varying, p_ctr_address_in character varying, p_ctr_account_in character varying, p_ctr_email_in character varying, p_ctr_unp_in character varying, p_ctr_full_name_in character varying, p_usr_name_in character varying, p_usr_id_in character varying, p_dep_name_in character varying) RETURNS TABLE(ctr_id integer, ctr_name character varying, ctr_full_name character varying, ctr_phone character varying, ctr_fax character, ctr_email character varying, ctr_bank_props character varying, ctr_block smallint, ctr_occupied integer, ctr_index character varying, ctr_region character varying, ctr_place character varying, ctr_street character varying, ctr_building character varying, ctr_add_info character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_need_suspend SMALLINT;
  v_usr_count INTEGER;
  v_acc_count INTEGER;
  v_usr_contact_person_count INTEGER;
  v_ctr_name_in VARCHAR;
  v_ctr_address_in VARCHAR;
  v_ctr_account_in VARCHAR;
  v_ctr_email_in VARCHAR;
  v_ctr_unp_in VARCHAR;
  v_ctr_full_name_in VARCHAR;
  v_usr_name_in VARCHAR;
  v_dep_name_in VARCHAR;
  v_usr_id_in INTEGER;
  rec RECORD;
BEGIN
  v_ctr_name_in := upper(p_ctr_name_in);
  v_ctr_address_in := upper(p_ctr_address_in);
  v_ctr_account_in := upper(p_ctr_account_in);
  v_ctr_email_in := upper(p_ctr_email_in);
  v_ctr_unp_in := upper(p_ctr_unp_in);
  v_ctr_full_name_in := upper(p_ctr_full_name_in);
  v_usr_name_in := upper(p_usr_name_in);
  v_dep_name_in := upper(p_dep_name_in);
  v_usr_id_in := CASE WHEN p_usr_id_in IS NOT NULL AND p_usr_id_in != '' THEN p_usr_id_in::INTEGER ELSE NULL END;

  FOR rec IN
    SELECT c.ctr_id, c.ctr_name, c.ctr_full_name, c.ctr_index, c.ctr_region,
           c.ctr_place, c.ctr_street, c.ctr_building, c.ctr_add_info,
           c.ctr_phone, c.ctr_fax, c.ctr_email, c.ctr_bank_props, c.ctr_block
    FROM dcl_contractor c
    WHERE (v_ctr_name_in IS NULL OR v_ctr_name_in = '' OR upper(c.ctr_name) LIKE '%' || v_ctr_name_in || '%')
      AND (v_ctr_address_in IS NULL OR v_ctr_address_in = '' OR
           (upper(COALESCE(c.ctr_index,'')) || ' ' || upper(COALESCE(c.ctr_region,'')) || ' ' || upper(COALESCE(c.ctr_place,'')) || ' ' || upper(COALESCE(c.ctr_street,'')) || ' ' || upper(COALESCE(c.ctr_building,'')) || ' ' || upper(COALESCE(c.ctr_add_info,''))) LIKE '%' || v_ctr_address_in || '%')
      AND (v_ctr_email_in IS NULL OR v_ctr_email_in = '' OR upper(c.ctr_email) LIKE '%' || v_ctr_email_in || '%')
      AND (v_ctr_unp_in IS NULL OR v_ctr_unp_in = '' OR upper(c.ctr_unp) LIKE '%' || v_ctr_unp_in || '%')
      AND (v_ctr_full_name_in IS NULL OR v_ctr_full_name_in = '' OR upper(c.ctr_full_name) LIKE '%' || v_ctr_full_name_in || '%')
    ORDER BY upper(c.ctr_name)
  LOOP
    ctr_id := rec.ctr_id;
    ctr_name := rec.ctr_name;
    ctr_full_name := rec.ctr_full_name;
    ctr_index := rec.ctr_index;
    ctr_region := rec.ctr_region;
    ctr_place := rec.ctr_place;
    ctr_street := rec.ctr_street;
    ctr_building := rec.ctr_building;
    ctr_add_info := rec.ctr_add_info;
    ctr_phone := rec.ctr_phone;
    ctr_fax := rec.ctr_fax;
    ctr_email := rec.ctr_email;
    ctr_bank_props := rec.ctr_bank_props;
    ctr_block := rec.ctr_block;

    v_need_suspend := NULL;
    ctr_occupied := NULL;
    SELECT ov.ctr_id INTO ctr_occupied FROM dcl_occupied_contractor_v ov WHERE ov.ctr_id = rec.ctr_id LIMIT 1;

    IF v_usr_id_in IS NULL AND (v_usr_name_in IS NULL OR v_usr_name_in = '') AND (v_dep_name_in IS NULL OR v_dep_name_in = '') THEN
      v_need_suspend := 1;
    ELSE
      IF v_usr_id_in IS NOT NULL THEN
        SELECT count(cu.usr_id) INTO v_usr_count
        FROM dcl_contractor_user cu WHERE cu.ctr_id = rec.ctr_id AND cu.usr_id = v_usr_id_in;

        SELECT count(cpu.usr_id) INTO v_usr_contact_person_count
        FROM dcl_contact_person cp, dcl_contact_person_user cpu
        WHERE cp.ctr_id = rec.ctr_id AND cpu.cps_id = cp.cps_id AND cpu.usr_id = v_usr_id_in;

        v_usr_count := v_usr_count + v_usr_contact_person_count;
        IF v_usr_count > 0 THEN v_need_suspend := 1; END IF;
      ELSE
        IF v_usr_name_in IS NOT NULL AND v_usr_name_in != '' THEN
          SELECT count(cu.usr_id) INTO v_usr_count
          FROM dcl_contractor_user cu, dcl_user_language ul
          WHERE cu.ctr_id = rec.ctr_id AND ul.usr_id = cu.usr_id AND ul.lng_id = 1
            AND upper(ul.usr_surname || ' ' || ul.usr_name) LIKE '%' || v_usr_name_in || '%';

          SELECT count(cpu.usr_id) INTO v_usr_contact_person_count
          FROM dcl_contact_person cp, dcl_contact_person_user cpu, dcl_user_language ul
          WHERE cp.ctr_id = rec.ctr_id AND cpu.cps_id = cp.cps_id
            AND ul.usr_id = cpu.usr_id AND ul.lng_id = 1
            AND upper(ul.usr_surname || ' ' || ul.usr_name) LIKE '%' || v_usr_name_in || '%';

          v_usr_count := v_usr_count + v_usr_contact_person_count;
          IF v_usr_count > 0 THEN v_need_suspend := 1; END IF;
        END IF;
      END IF;

      IF v_dep_name_in IS NOT NULL AND v_dep_name_in != '' AND v_need_suspend IS NULL THEN
        SELECT count(cu.usr_id) INTO v_usr_count
        FROM dcl_contractor_user cu, dcl_user u, dcl_department d
        WHERE cu.ctr_id = rec.ctr_id AND u.usr_id = cu.usr_id AND d.dep_id = u.dep_id
          AND upper(d.dep_name) LIKE '%' || v_dep_name_in || '%';

        SELECT count(cpu.usr_id) INTO v_usr_contact_person_count
        FROM dcl_contact_person cp, dcl_contact_person_user cpu, dcl_user u, dcl_department d
        WHERE cp.ctr_id = rec.ctr_id AND cpu.cps_id = cp.cps_id
          AND u.usr_id = cpu.usr_id AND d.dep_id = u.dep_id
          AND upper(d.dep_name) LIKE '%' || v_dep_name_in || '%';

        v_usr_count := v_usr_count + v_usr_contact_person_count;
        IF v_usr_count > 0 THEN v_need_suspend := 1; END IF;
      END IF;
    END IF;

    IF v_need_suspend IS NOT NULL AND v_ctr_account_in IS NOT NULL AND v_ctr_account_in != '' THEN
      v_need_suspend := NULL;
      SELECT count(acc.acc_id) INTO v_acc_count
      FROM dcl_account acc WHERE acc.ctr_id = rec.ctr_id AND upper(acc.acc_account) LIKE '%' || v_ctr_account_in || '%';
      IF v_acc_count > 0 THEN v_need_suspend := 1; END IF;
    END IF;

    IF v_need_suspend IS NOT NULL THEN
      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_contractor_for_cc_filter(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_for_cc_filter(p_ctr_name_in character varying) RETURNS TABLE(ctr_id integer, ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ctr_name_filter varchar(200);
  _rec RECORD;
BEGIN
  p_ctr_name_in = upper(p_ctr_name_in);

  FOR _rec IN select upper(ctr.ctr_name) as ctr_name_filter, ctr.ctr_id as ctr_id, ctr_name from dcl_contractor ctr, dcl_ctc_list lcc, dcl_contract con, dcl_con_list_spec spc where ctr.ctr_id = con.ctr_id and spc.con_id = con.con_id and spc.spc_id = lcc.spc_id and (( p_ctr_name_in is null ) or ( p_ctr_name_in like '' ) or ( upper(ctr.ctr_name) like('%' || p_ctr_name_in || '%') )) group by ctr_name_filter, ctr_id, ctr_name order by ctr_name_filter
  LOOP
    ctr_name_filter := _rec.ctr_name_filter;
    ctr_id := _rec.ctr_id;
    ctr_name := _rec.ctr_name;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_contractor_insert(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, smallint, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_insert(p_ctr_name character varying, p_ctr_full_name character varying, p_cut_id integer, p_ctr_index character varying, p_ctr_region character varying, p_ctr_place character varying, p_ctr_street character varying, p_ctr_building character varying, p_ctr_add_info character varying, p_ctr_phone character varying, p_ctr_fax character varying, p_ctr_email character varying, p_ctr_bank_props character varying, p_ctr_unp character varying, p_ctr_okpo character varying, p_ctr_block smallint, p_rpt_id integer, p_ctr_comment character varying) RETURNS TABLE(ctr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_contractor (
    p_ctr_name,
    p_ctr_full_name,
    p_cut_id,
    p_ctr_index,
    p_ctr_region,
    p_ctr_place,
    p_ctr_street,
    p_ctr_building,
    p_ctr_add_info,
    p_ctr_phone,
    p_ctr_fax,
    p_ctr_email,
    p_ctr_bank_props,
    p_ctr_unp,
    p_ctr_okpo,
    p_ctr_block,
    p_rpt_id,
    p_ctr_comment
  )
  values (
    p_ctr_name,
    p_ctr_full_name,
    p_cut_id,
    p_ctr_index,
    p_ctr_region,
    p_ctr_place,
    p_ctr_street,
    p_ctr_building,
    p_ctr_add_info,
    p_ctr_phone,
    p_ctr_fax,
    p_ctr_email,
    p_ctr_bank_props,
    p_ctr_unp,
    p_ctr_okpo,
    p_ctr_block,
    p_rpt_id,
    p_ctr_comment
  )
  returning ctr_id into ctr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contractor_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_load(p_ctr_id_in integer) RETURNS TABLE(ctr_id integer, ctr_name character varying, ctr_full_name character varying, cut_id integer, cut_name character varying, ctr_phone character varying, ctr_fax character, ctr_email character varying, ctr_bank_props character varying, account1 character varying, account2 character varying, accountval character varying, ctr_unp character varying, ctr_okpo character varying, ctr_double_account smallint, ctr_block integer, rpt_id integer, rpt_description character varying, byn_accounts character varying, other_accounts character varying, ctr_index character varying, ctr_region character varying, ctr_place character varying, ctr_street character varying, ctr_building character varying, ctr_add_info character varying, ctr_comment character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  acc_account varchar(35);
  cur_name varchar(10);
  _rec RECORD;
BEGIN
  ctr_id := null;
  ctr_name := null;
  ctr_full_name := null;
  cut_id := null;
  cut_name := null;
  ctr_index := null;
  ctr_region := null;
  ctr_place := null;
  ctr_street := null;
  ctr_building := null;
  ctr_add_info := null;
  ctr_phone := null;
  ctr_fax := null;
  ctr_email := null;
  ctr_bank_props := null;
  account1 := null;
  account2 := null;
  accountval := null;
  ctr_unp := null;
  ctr_okpo := null;
  ctr_block := null;
  ctr_double_account := null;
  rpt_id := null;
  rpt_description := null;
  byn_accounts := '';
  other_accounts := '';
  ctr_comment := null;

  select
       ctr.ctr_id,
       ctr.ctr_name,
       ctr.ctr_full_name,
       ctr.cut_id,
       cut.cut_name,
       ctr.ctr_index,
       ctr.ctr_region,
       ctr.ctr_place,
       ctr.ctr_street,
       ctr.ctr_building,
       ctr.ctr_add_info,
       ctr.ctr_phone,
       ctr.ctr_fax,
       ctr.ctr_email,
       ctr.ctr_bank_props,
       (select acc_account from dcl_account where ctr_id = ctr.ctr_id and acc_index = 1),
       (select acc_account from dcl_account where ctr_id = ctr.ctr_id and acc_index = 2),
       (select acc_account from dcl_account where ctr_id = ctr.ctr_id and acc_index = 3),
       ctr.ctr_unp,
       ctr.ctr_okpo,
       ctr.ctr_block,
       ctr.ctr_double_account,
       rpt.rpt_id,
       rpt.rpt_description,
       ctr.ctr_comment
  from dcl_contractor ctr
       left join dcl_country cut on cut.cut_id = ctr.cut_id,
       dcl_reputation rpt
  where ctr_id = p_ctr_id_in and
        rpt.rpt_id = ctr.rpt_id
  into
       ctr_id,
       ctr_name,
       ctr_full_name,
       cut_id,
       cut_name,
       ctr_index,
       ctr_region,
       ctr_place,
       ctr_street,
       ctr_building,
       ctr_add_info,
       ctr_phone,
       ctr_fax,
       ctr_email,
       ctr_bank_props,
       account1,
       account2,
       accountVal,
       ctr_unp,
       ctr_okpo,
       ctr_block,
       ctr_double_account,
       rpt_id,
       rpt_description,
       ctr_comment
  ;

  FOR _rec IN select acc.acc_account, cur.cur_name from dcl_account acc, dcl_currency cur where acc.ctr_id = ctr_id and cur.cur_id = acc.cur_id and cur.cur_name like 'BYN'
  LOOP
    acc_account := _rec.acc_account;
    cur_name := _rec.cur_name;
    if ( cur_name is null ) then
      cur_name := '';
  END IF;
    if ( acc_account is not null ) then
      byn_accounts := byn_accounts || acc_account || ' ' || cur_name || ', ';
  END IF;
  END LOOP;

  FOR _rec IN select acc.acc_account, cur.cur_name from dcl_account acc, dcl_currency cur where acc.ctr_id = ctr_id and cur.cur_id = acc.cur_id and (cur.cur_name not like 'BYN' or cur.cur_name is null)
  LOOP
    acc_account := _rec.acc_account;
    cur_name := _rec.cur_name;
    if ( cur_name is null ) then
      cur_name := '';
  END IF;
    if ( acc_account is not null ) then
      other_accounts := other_accounts || acc_account || ' ' || cur_name || ', ';
  END IF;
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contractor_request_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.crq_id and att.att_parent_table = 'DCL_CONTRACTOR_REQUEST';
RETURN OLD;
END
$$;


--
-- Name: dcl_contractor_request_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CRQ_ID IS NULL) THEN
    NEW.CRQ_ID = nextval('gen_dcl_contractor_request_id');
  ELSE
        ID = nextval('gen_dcl_contractor_request_id');
        IF ( ID < NEW.CRQ_ID ) THEN
          ID = nextval('gen_dcl_contractor_request_id');
  END IF;
  END IF;
    NEW.crq_create_date = CURRENT_TIMESTAMP;
    new.usr_id_create = get_context('usr_id');
    NEW.crq_edit_date = CURRENT_TIMESTAMP;
    new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contractor_request_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.crq_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_contractor_request_filter(smallint, date, date, character varying, smallint, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_filter(p_crq_request_type_id smallint DEFAULT NULL::smallint, p_crq_date_begin date DEFAULT NULL::date, p_crq_date_end date DEFAULT NULL::date, p_crq_ctr_name character varying DEFAULT NULL::character varying, p_crq_status smallint DEFAULT NULL::smallint, p_crq_usr_id integer DEFAULT NULL::integer, p_crq_dep_id integer DEFAULT NULL::integer, p_crq_ctr_id integer DEFAULT NULL::integer) RETURNS TABLE(crq_id integer, crq_date date, crq_request_type_id smallint, ctr_id integer, ctr_name character varying, crq_status smallint, usr_id integer, usr_full_name character varying, dep_id integer, dep_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE _rec RECORD;
BEGIN
  FOR _rec IN SELECT cr.crq_id, cr.crq_date, cr.crq_request_type_id,
      cr.ctr_id, ct.ctr_name, cr.crq_status,
      cr.usr_id, u.usr_full_name, cr.dep_id, d.dep_name
    FROM dcl_contractor_request cr
    LEFT JOIN dcl_contractor ct ON ct.ctr_id = cr.ctr_id
    LEFT JOIN dcl_user u ON u.usr_id = cr.usr_id
    LEFT JOIN dcl_department d ON d.dep_id = cr.dep_id
    WHERE (p_crq_request_type_id IS NULL OR cr.crq_request_type_id = p_crq_request_type_id)
      AND (p_crq_date_begin IS NULL OR cr.crq_date >= p_crq_date_begin)
      AND (p_crq_date_end IS NULL OR cr.crq_date <= p_crq_date_end)
      AND (p_crq_ctr_name IS NULL OR LOWER(ct.ctr_name) LIKE LOWER('%' || p_crq_ctr_name || '%'))
      AND (p_crq_status IS NULL OR cr.crq_status = p_crq_status)
      AND (p_crq_usr_id IS NULL OR cr.usr_id = p_crq_usr_id)
      AND (p_crq_dep_id IS NULL OR cr.dep_id = p_crq_dep_id)
      AND (p_crq_ctr_id IS NULL OR cr.ctr_id = p_crq_ctr_id)
    ORDER BY cr.crq_date DESC
  LOOP
    crq_id := _rec.crq_id; crq_date := _rec.crq_date;
    crq_request_type_id := _rec.crq_request_type_id;
    ctr_id := _rec.ctr_id; ctr_name := _rec.ctr_name;
    crq_status := _rec.crq_status; usr_id := _rec.usr_id;
    usr_full_name := _rec.usr_full_name; dep_id := _rec.dep_id; dep_name := _rec.dep_name;
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_contractor_request_insert(character varying, date, integer, integer, integer, integer, integer, integer, smallint, integer, integer, integer, integer, character varying, integer, smallint, integer, character varying, character varying, date, integer, smallint, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_insert(p_crq_number character varying, p_crq_receive_date date, p_ctr_id integer, p_cps_id integer, p_crq_request_type_id integer, p_con_id integer, p_lps_id integer, p_prd_id integer, p_crq_deliver smallint, p_sln_id integer, p_usr_id_manager integer, p_usr_id_chief integer, p_usr_id_specialist integer, p_crq_city character varying, p_ctr_id_other integer, p_crq_no_contract smallint, p_stf_id integer, p_crq_serial_num character varying, p_crq_year_out character varying, p_crq_enter_in_use_date date, p_crq_operating_time integer, p_crq_annul smallint, p_crq_ticket_number character varying, p_crq_comment character varying, p_con_id_for_work integer) RETURNS TABLE(crq_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN

    insert into dcl_contractor_request(
      p_crq_number,
      p_crq_receive_date,
      p_ctr_id,
      p_cps_id,
      p_crq_request_type_id,
      p_con_id,
      p_lps_id,
      p_prd_id,
      p_crq_deliver,
      p_sln_id,
      p_usr_id_manager,
      p_usr_id_chief,
      p_usr_id_specialist,
      p_crq_city,
      p_ctr_id_other,
      p_crq_no_contract,
      p_stf_id,
      p_crq_serial_num,
      p_crq_year_out,
      p_crq_enter_in_use_date,
      p_crq_operating_time,
      p_crq_annul,
      p_crq_ticket_number,
      p_crq_comment,
      p_con_id_for_work
    )
    values(
      p_crq_number,
      p_crq_receive_date,
      p_ctr_id,
      p_cps_id,
      p_crq_request_type_id,
      p_con_id,
      p_lps_id,
      p_prd_id,
      p_crq_deliver,
      p_sln_id,
      p_usr_id_manager,
      p_usr_id_chief,
      p_usr_id_specialist,
      p_crq_city,
      p_ctr_id_other,
      p_crq_no_contract,
      p_stf_id,
      p_crq_serial_num,
      p_crq_year_out,
      p_crq_enter_in_use_date,
      p_crq_operating_time,
      p_crq_annul,
      p_crq_ticket_number,
      p_crq_comment,
      p_con_id_for_work
    )
    returning crq_id into crq_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_contractor_request_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contractor_request_load(p_crq_id integer) RETURNS TABLE(usr_id_create integer, usr_id_edit integer, crq_create_date timestamp without time zone, crq_edit_date timestamp without time zone, crq_number character varying, crq_receive_date date, ctr_id integer, cps_id integer, crq_request_type_id integer, con_id integer, lps_id integer, crq_equipment character varying, ctn_number character varying, stf_id integer, stf_name character varying, lps_serial_num character varying, lps_year_out character varying, lps_enter_in_use_date character varying, prd_id integer, mad_complexity character varying, crq_deliver smallint, sln_id integer, sln_name character varying, manager_id integer, manager_name character varying, manager_surname character varying, chief_id integer, chief_name character varying, chief_surname character varying, specialist_id integer, specialist_name character varying, specialist_surname character varying, crq_city character varying, ctr_id_other integer, ctr_name_other character varying, crq_no_contract smallint, crq_serial_num character varying, crq_year_out character varying, crq_enter_in_use_date date, stf_name1 character varying, crq_annul smallint, crq_ticket_number character varying, shp_date character varying, con_number character varying, con_date character varying, spc_number character varying, spc_date character varying, con_seller_id integer, con_seller character varying, crq_comment character varying, crq_operating_time integer, con_id_for_work integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  count_deliver integer;
  _rec RECORD;
BEGIN
    select
      usr_id_create,
      usr_id_edit,
      crq_create_date,
      crq_edit_date,
      crq_number,
      crq_receive_date,
      ctr_id,
      cps_id,
      crq_request_type_id,
      con_id,
      lps_id,
      prd_id,
      crq_deliver,
      sln_id,
      usr_id_manager,
      usr_id_chief,
      usr_id_specialist,
      crq_city,
      ctr_id_other,
      crq_no_contract,
      stf_id, 
      crq_serial_num,
      crq_year_out,
      crq_enter_in_use_date,
      crq_operating_time,
      crq_annul,
      crq_ticket_number,
      crq_comment,
      con_id_for_work
    from dcl_contractor_request
    where p_crq_id = p_crq_id
    into 
      usr_id_create,
      usr_id_edit,
      crq_create_date,
      crq_edit_date,
      crq_number,
      crq_receive_date,
      ctr_id,
      cps_id,
      crq_request_type_id,
      con_id,
      lps_id,
      prd_id,
      crq_deliver,
      sln_id,
      manager_id,
      chief_id,
      specialist_id,
      crq_city,
      ctr_id_other,
      crq_no_contract,
      stf_id,
      crq_serial_num,
      crq_year_out,
      crq_enter_in_use_date,
      crq_operating_time,
      crq_annul,
      crq_ticket_number,
      crq_comment,
      con_id_for_work
    ;
    stf_name1 = null;
    if ( stf_id is not null ) then
      select stf_name from dcl_stuff_category where stf_id = stf_id into stf_name1;
  END IF;

    if (
         crq_request_type_id = 1 or
         ( ( crq_request_type_id = 2 or crq_request_type_id = 3 ) and crq_no_contract is null )
       ) then
      select lps_serial_num,
             lps_year_out,
             lps_enter_in_use_date,
             stf_name,
             ctn_number,
             crq_equipment,
             mad_complexity
      from dcl_equipment_pnp_load(lps_id)
      into  lps_serial_num,
            lps_year_out,
            lps_enter_in_use_date,
            stf_name,
            ctn_number,
            crq_equipment,
            mad_complexity;

      manager_name = null;
      manager_surname = null;
      if ( manager_id is not null ) then
        select usr_name,
               usr_surname
        from dcl_user_language
        where usr_id = manager_id and lng_id = 1
        into manager_name,
             manager_surname;
  END IF;

      chief_name = null;
      chief_surname = null;
      if ( chief_id is not null ) then
        select usr_name,
               usr_surname
        from dcl_user_language
        where usr_id = chief_id and lng_id = 1
        into chief_name,
             chief_surname;
  END IF;

      specialist_name = null;
      specialist_surname = null;
      if ( specialist_id is not null ) then
        select usr_name,
               usr_surname
        from dcl_user_language
        where usr_id = specialist_id and lng_id = 1
        into specialist_name,
             specialist_surname;
  END IF;

      ctr_name_other = null;
      if ( ctr_id_other is not null ) then
        select ctr_name from dcl_contractor where ctr_id = ctr_id_other into ctr_name_other;
  END IF;
  END IF;

    if (
         ( crq_request_type_id = 2 or crq_request_type_id = 3 ) and
           crq_no_contract is not null
       ) then
      stf_name = stf_name1;

      select ctn_number,
             crq_equipment,
             mad_complexity
     from dcl_equipment_for_produce_load(stf_id, prd_id)
     into  ctn_number,
           crq_equipment,
           mad_complexity;
  END IF;

    shp_date = null;
    con_number = null;
    con_date = null;
    spc_number = null;
    spc_date = null;
    con_seller_id = null;
    con_seller = null;
    -- service or guarantee
    if ( crq_request_type_id = 2 or crq_request_type_id = 3 ) then
      select
        shp_date,
        con_number,
        con_date,
        spc_number,
        spc_date,
        con_seller_id,
        con_seller
      from dcl_add_info_service_guarantee(lps_id)
      into
        shp_date,
        con_number,
        con_date,
        spc_number,
        spc_date,
        con_seller_id,
        con_seller
      ;

      crq_deliver = null;
      select count(crp_id) from dcl_crq_print where p_crq_id = p_crq_id and crp_deliver is not null into count_deliver;
      if ( count_deliver > 0 ) then
        crq_deliver = 1;
  END IF;
  END IF;

    sln_name = null;
    if ( sln_id is not null ) then
      select sln_name from dcl_seller where sln_id = sln_id into sln_name;
  END IF;

    RETURN NEXT;
END
$$;


--
-- Name: dcl_contracts_closed_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_contracts_closed_load(p_ctc_id_in integer) RETURNS TABLE(lcc_id integer, ctc_id integer, ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, con_date date, con_original smallint, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_group_delivery smallint, spc_original smallint, sum_out_nds_eur numeric, lcc_charges numeric, lcc_montage numeric, lcc_update_sum numeric, have_unblocked_prc smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  unblocked_prc_count integer;
  _rec RECORD;
BEGIN
  FOR _rec IN select lcc_id, ctc_id, ctr.ctr_id, ctr.ctr_name, con.con_id, con.con_number, con.con_date, con.con_original, spc.spc_id, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_group_delivery, spc.spc_original, ( select sum_out_nds_eur from dcl_get_sum_out_nds_eur(spc.spc_id) ), lcc_charges, lcc_montage, lcc_update_sum from dcl_ctc_list lcc, dcl_con_list_spec spc, dcl_contract con, dcl_contractor ctr where ctc_id = p_ctc_id_in and spc.spc_id = lcc.spc_id and con.con_id = spc.con_id and ctr.ctr_id = con.ctr_id order by upper(ctr.ctr_name)
  LOOP
    lcc_id := _rec.lcc_id;
    ctc_id := _rec.ctc_id;
    ctr_id := _rec.ctr_id;
    ctr_name := _rec.ctr_name;
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    con_original := _rec.con_original;
    spc_id := _rec.spc_id;
    spc_number := _rec.spc_number;
    spc_date := _rec.spc_date;
    spc_summ := _rec.spc_summ;
    spc_group_delivery := _rec.spc_group_delivery;
    spc_original := _rec.spc_original;
    sum_out_nds_eur := _rec.sum_out_nds_eur;
    lcc_charges := _rec.lcc_charges;
    lcc_montage := _rec.lcc_montage;
    lcc_update_sum := _rec.lcc_update_sum;
    have_unblocked_prc := null;

    SELECT coalesce(count(lps.lps_id), 0)
      INTO unblocked_prc_count
      from
      dcl_ctc_shp cshp,
      dcl_shp_list_produce lps,
      dcl_prc_list_produce lpc,
      dcl_produce_cost prc
    where
      cshp.lcc_id = lcc_id and
      lps.shp_id = cshp.shp_id and
      lpc.lpc_id = lps.lpc_id and
      prc.prc_id = lpc.prc_id and
      prc.prc_block is null;

    if ( unblocked_prc_count != 0 ) then
      have_unblocked_prc := 1;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_country_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_country_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CUT_ID IS NULL) THEN
    NEW.CUT_ID = nextval('gen_dcl_country_id');
  ELSE
    ID = nextval('gen_dcl_country_id');
    IF ( ID < NEW.CUT_ID ) THEN
      ID = nextval('gen_dcl_country_id');
  END IF;
  END IF;

  new.cut_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.cut_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_country_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_country_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.cut_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_country_insert(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_country_insert(p_cut_name character varying) RETURNS TABLE(cut_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_country (
    p_cut_name
  )
  values (
    p_cut_name
  )
  returning cut_id into cut_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_cpr_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LPR_ID IS NULL) THEN
    NEW.LPR_ID = nextval('gen_dcl_cpr_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_cpr_list_produce_id');
        IF ( ID < NEW.LPR_ID ) THEN
          ID = nextval('gen_dcl_cpr_list_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cpr_list_produce_load(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_list_produce_load(p_lpr_id_in integer, p_cpr_date timestamp without time zone) RETURNS TABLE(lpr_id integer, cpr_id integer, lpr_produce_name character varying, lpr_catalog_num character varying, lpr_price_brutto numeric, lpr_discount numeric, lpr_price_netto numeric, lpr_count numeric, cus_id integer, cus_code character varying, cus_percent numeric, lpr_coeficient numeric, stf_id integer, stf_name character varying, prd_id integer, lpr_comment character varying, lpc_id integer, lpc_cost_one_by numeric, lpc_price_list_by numeric, lpr_sale_price numeric, lpr_sale_cost_parking_trans numeric, lpc_1c_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_date date;
BEGIN
  lpr_id = null;
  cpr_id = null;
  lpr_produce_name = null;
  lpr_catalog_num = null;
  lpr_price_brutto = null;
  lpr_discount = null;
  lpr_price_netto = null;
  lpr_count = null;
  cus_id = null;
  cus_code = null;
  cus_percent = null;
  lpr_coeficient = null;
  stf_id = null;
  stf_name = null;
  prd_id = null;
  lpr_comment = null;
  lpc_id = null;
  lpc_cost_one_by = null;
  lpc_price_list_by = null;
  lpr_sale_price = null;
  lpr_sale_cost_parking_trans = null;

  select
    lpr_id,
    cpr_id,
    lpr_produce_name,
    lpr_catalog_num,
    lpr_price_brutto,
    lpr_discount,
    lpr_price_netto,
    lpr_count,
    cus_id,
    (select cus_code from dcl_custom_code cus where cus_id = lpr.cus_id ),
    (
      select cus_percent
      from dcl_custom_code cus
      where cus_code = (
                         select cus_code
                         from dcl_custom_code
                         where cus_id = lpr.cus_id
                       )
      and
      cus_instant = (
                      select max(cus_instant)
                      from dcl_custom_code
                      where cus_code = cus.cus_code and
                            cus_instant <= p_cpr_date
                    )
    ),
    lpr_coeficient,
    stf_id,
    ( select stf_name from dcl_stuff_category where stf_id = lpr.stf_id ),
    prd_id,
    lpr_comment,
    lpc_id,
    lpr_sale_price,
    lpr_sale_cost_parking_trans
  from dcl_cpr_list_produce lpr
  where lpr_id = p_lpr_id_in
  into
    lpr_id,
    cpr_id,
    lpr_produce_name,
    lpr_catalog_num,
    lpr_price_brutto,
    lpr_discount,
    lpr_price_netto,
    lpr_count,
    cus_id,
    cus_code,
    cus_percent,
    lpr_coeficient,
    stf_id,
    stf_name,
    prd_id,
    lpr_comment,
    lpc_id,
    lpr_sale_price,
    lpr_sale_cost_parking_trans
  ;

  if ( lpc_id is not null ) then

    select prc_date,
           lpc_cost_one_by,
           lpc_price_list_by,
           lpc_1c_number
    from dcl_prc_list_produce_load(lpc_id)
    into   prc_date,
           lpc_cost_one_by,
           lpc_price_list_by,
           lpc_1c_number
    ;

    if (prc_date < '2016-07-01') then
      lpc_cost_one_by = ROUND(lpc_cost_one_by / 100, 0) / 100;
      lpc_price_list_by = ROUND(lpc_price_list_by / 100, 0) / 100;

      lpr_price_brutto = ROUND(lpr_price_brutto / 100, 0) / 100;
      lpr_discount = ROUND(lpr_discount / 100, 0) / 100;
      lpr_price_netto = ROUND(lpr_price_netto / 100, 0) / 100;
  END IF;

  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_cpr_list_produces_load(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_list_produces_load(p_cpr_id_in integer, p_cpr_date timestamp without time zone) RETURNS TABLE(lpr_id integer, cpr_id integer, lpr_produce_name character varying, lpr_catalog_num character varying, lpr_price_brutto numeric, lpr_discount numeric, lpr_price_netto numeric, lpr_count numeric, cus_id integer, cus_code character varying, cus_percent numeric, lpr_coeficient numeric, stf_id integer, stf_name character varying, prd_id integer, lpr_comment character varying, lpc_id integer, lpc_cost_one_by numeric, lpc_price_list_by numeric, lpr_sale_price numeric, lpr_sale_cost_parking_trans numeric, lpc_1c_number character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  cpr_id = p_cpr_id_in;

  FOR lpr_id IN select lpr_id from dcl_cpr_list_produce lpr where lpr.cpr_id = p_cpr_id_in order by lpr_id
  LOOP
    select
      lpr_id,
      cpr_id,
      lpr_produce_name,
      lpr_catalog_num,
      lpr_price_brutto,
      lpr_discount,
      lpr_price_netto,
      lpr_count,
      cus_id,
      cus_code,
      cus_percent,
      lpr_coeficient,
      stf_id,
      stf_name,
      prd_id,
      lpr_comment,
      lpc_id,
      lpc_cost_one_by,
      lpc_price_list_by,
      lpc_1c_number,
      lpr_sale_price,
      lpr_sale_cost_parking_trans
    from dcl_cpr_list_produce_load(lpr_id, p_cpr_date)
    into
      lpr_id,
      cpr_id,
      lpr_produce_name,
      lpr_catalog_num,
      lpr_price_brutto,
      lpr_discount,
      lpr_price_netto,
      lpr_count,
      cus_id,
      cus_code,
      cus_percent,
      lpr_coeficient,
      stf_id,
      stf_name,
      prd_id,
      lpr_comment,
      lpc_id,
      lpc_cost_one_by,
      lpc_price_list_by,
      lpc_1c_number,
      lpr_sale_price,
      lpr_sale_cost_parking_trans
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_cpr_transport_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_transport_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.TRN_ID IS NULL) THEN
    NEW.TRN_ID = nextval('gen_dcl_cpr_transport_id');
  ELSE
        ID = nextval('gen_dcl_cpr_transport_id');
        IF ( ID < NEW.TRN_ID ) THEN
          ID = nextval('gen_dcl_cpr_transport_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_cpr_transport_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_transport_load(p_trn_id_in integer) RETURNS TABLE(trn_id integer, cpr_id integer, stf_id integer, stf_name character varying, trn_sum numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  trn_id = null;
  cpr_id = null;
  stf_id = null;
  stf_name = null;
  trn_sum = null;

  select
    trn_id,
    cpr_id,
    stf_id,
    ( select stf_name from dcl_stuff_category where stf_id = trn.stf_id ),
    trn_sum
  from dcl_cpr_transport trn
  where trn_id = p_trn_id_in
  into
    trn_id,
    cpr_id,
    stf_id,
    stf_name,
    trn_sum
  ;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_cpr_transports_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cpr_transports_load(p_cpr_id_in integer) RETURNS TABLE(trn_id integer, cpr_id integer, stf_id integer, stf_name character varying, trn_sum numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  cpr_id = p_cpr_id_in;

  FOR trn_id IN select trn_id from dcl_cpr_transport trn where trn.cpr_id = p_cpr_id_in order by trn_id
  LOOP
    select
      trn_id,
      cpr_id,
      stf_id,
      stf_name,
      trn_sum
    from dcl_cpr_transport_load(trn_id)
    into
      trn_id,
      cpr_id,
      stf_id,
      stf_name,
      trn_sum
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_crq_print_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_crq_print_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CRP_ID IS NULL) THEN
    NEW.CRP_ID = nextval('gen_dcl_crq_print_id');
  ELSE
        ID = nextval('gen_dcl_crq_print_id');
        IF ( ID < NEW.CRP_ID ) THEN
          ID = nextval('gen_dcl_crq_print_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_crq_stage_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_crq_stage_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CRS_ID IS NULL) THEN
    NEW.CRS_ID = nextval('gen_dcl_crq_stage_id');
  ELSE
        ID = nextval('gen_dcl_crq_stage_id');
        IF ( ID < NEW.CRS_ID ) THEN
          ID = nextval('gen_dcl_crq_stage_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ctc_list_ad0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ctc_list_ad0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  con_id integer;
BEGIN
  UPDATE dcl_con_list_spec SET spc_executed = null
  where
    spc_id = old.spc_id and
    spc_executed is not null;

  select con_id from dcl_con_list_spec where spc_id = old.spc_id into con_id;
  update dcl_contract set con_executed = null where con_id = con_id;
RETURN OLD;
END
$$;


--
-- Name: dcl_ctc_list_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ctc_list_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LCC_ID IS NULL) THEN
    NEW.LCC_ID = nextval('gen_dcl_ctc_list_id');
  ELSE
        ID = nextval('gen_dcl_ctc_list_id');
        IF ( ID < NEW.LCC_ID ) THEN
          ID = nextval('gen_dcl_ctc_list_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_currencies_rates_for_date(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_currencies_rates_for_date(p_course_date character varying) RETURNS TABLE(cur_id integer, cur_name character varying, crt_id integer, crt_rate numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_date DATE;
BEGIN
  v_date := CASE WHEN p_course_date IS NOT NULL AND p_course_date != '' THEN p_course_date::DATE ELSE CURRENT_DATE END;
  
  RETURN QUERY
    SELECT c.cur_id, c.cur_name, cr.crt_id, cr.crt_rate
    FROM dcl_currency c
    LEFT JOIN dcl_currency_rate cr ON cr.cur_id = c.cur_id AND cr.crt_date = v_date;
END;
$$;


--
-- Name: dcl_currency_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_currency_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CUR_ID IS NULL) THEN
    NEW.CUR_ID = nextval('gen_dcl_currency_id');
  ELSE
        ID = nextval('gen_dcl_currency_id');
        IF ( ID < NEW.CUR_ID ) THEN
          ID = nextval('gen_dcl_currency_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_currency_rate_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_currency_rate_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CRT_ID IS NULL) THEN
    NEW.CRT_ID = nextval('gen_dcl_currency_rate_id');
  ELSE
    ID = nextval('gen_dcl_currency_rate_id');
    IF ( ID < NEW.CRT_ID ) THEN
      ID = nextval('gen_dcl_currency_rate_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_currency_rate_for_date(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_currency_rate_for_date(p_cur_id character varying, p_course_date character varying) RETURNS TABLE(crt_id integer, crt_rate numeric, crt_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_cur_id INTEGER;
  v_date DATE;
BEGIN
  IF p_cur_id IS NULL OR p_cur_id = '' THEN
    RETURN;
  END IF;
  v_cur_id := p_cur_id::INTEGER;
  v_date := CASE WHEN p_course_date IS NOT NULL AND p_course_date != '' THEN p_course_date::DATE ELSE CURRENT_DATE END;
  
  RETURN QUERY
    SELECT cr.crt_id, cr.crt_rate, cr.crt_date
    FROM dcl_currency_rate cr
    WHERE cr.cur_id = v_cur_id
      AND cr.crt_date = (
        SELECT max(cr2.crt_date)
        FROM dcl_currency_rate cr2
        WHERE cr2.cur_id = v_cur_id
          AND cr2.crt_date <= v_date
      );
END;
$$;


--
-- Name: dcl_currency_rate_min_date(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_currency_rate_min_date(p_cur_id integer) RETURNS TABLE(min_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_currency_count INTEGER;
BEGIN
  min_date := NULL;
  SELECT COUNT(*) INTO v_currency_count FROM dcl_currency WHERE cur_id = p_cur_id;
  IF (v_currency_count > 0) THEN
    SELECT MIN(crt.crt_date) INTO min_date FROM dcl_currency_rate crt WHERE crt.cur_id = p_cur_id;
  END IF;
  RETURN NEXT;
END $$;


--
-- Name: dcl_current_work_add_info(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_current_work_add_info(p_spc_id integer) RETURNS TABLE(spi_send_date character varying, cost_produce_date character varying, shp_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_current_spi_send_date DATE;
  v_current_cost_produce_date DATE;
  v_current_shp_number VARCHAR(50);
  _rec RECORD;
BEGIN
  spi_send_date := NULL; cost_produce_date := NULL; shp_number := NULL;
  v_current_spi_send_date := NULL; v_current_cost_produce_date := NULL; v_current_shp_number := NULL;
  
  SELECT MAX(spi.spi_send_date) INTO v_current_spi_send_date
    FROM dcl_specification_import spi WHERE spi.spc_id = p_spc_id;
  IF (v_current_spi_send_date IS NOT NULL) THEN
    SELECT d.strdate INTO spi_send_date FROM date2str(v_current_spi_send_date) d;
  END IF;
  
  SELECT MAX(cst.cst_date) INTO v_current_cost_produce_date
    FROM dcl_produce_cost cst WHERE cst.spc_id = p_spc_id;
  IF (v_current_cost_produce_date IS NOT NULL) THEN
    SELECT d.strdate INTO cost_produce_date FROM date2str(v_current_cost_produce_date) d;
  END IF;
  
  FOR _rec IN SELECT s.shp_number FROM dcl_shipping s WHERE s.spc_id = p_spc_id ORDER BY s.shp_id DESC
  LOOP
    IF (v_current_shp_number IS NULL) THEN
      v_current_shp_number := _rec.shp_number;
    ELSE
      v_current_shp_number := v_current_shp_number || ', ' || _rec.shp_number;
    END IF;
  END LOOP;
  shp_number := v_current_shp_number;
  
  RETURN NEXT;
END $$;


--
-- Name: dcl_current_works_filter(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_current_works_filter(p_contractor character varying, p_request_type_id character varying, p_equipment character varying, p_stuff_category character varying, p_user character varying) RETURNS TABLE(crq_id integer, crq_number character varying, crq_create_date_formatted character varying, crq_equipment character varying, stf_name character varying, crq_request_type character varying, crq_contractor character varying, con_number_date character varying, ord_number character varying, ord_date_formatted character varying, manager character varying, ord_sum numeric, crq_comment character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_request_type_id INTEGER;
BEGIN
    IF p_request_type_id IS NOT NULL AND p_request_type_id != '' THEN
        v_request_type_id := CAST(p_request_type_id AS INTEGER);
    ELSE
        v_request_type_id := NULL;
    END IF;
    RETURN QUERY
    SELECT cr.crq_id, cr.crq_number::VARCHAR,
           to_char(cr.crq_receive_date, 'DD.MM.YYYY')::VARCHAR AS crq_create_date_formatted,
           cr.crq_equipment::VARCHAR,
           sc.stf_name::VARCHAR,
           crt.crt_name::VARCHAR AS crq_request_type,
           c.ctr_name::VARCHAR AS crq_contractor,
           ''::VARCHAR AS con_number_date,
           ''::VARCHAR AS ord_number,
           ''::VARCHAR AS ord_date_formatted,
           ''::VARCHAR AS manager,
           0::NUMERIC AS ord_sum,
           cr.crq_comment::VARCHAR
    FROM dcl_contractor_request cr
    LEFT JOIN dcl_contractor c ON c.ctr_id = cr.ctr_id
    LEFT JOIN dcl_contractor_request_type crt ON crt.crt_id = cr.crq_request_type_id
    LEFT JOIN dcl_stuff_category sc ON sc.stf_id = cr.stf_id
    LEFT JOIN dcl_user u ON u.usr_id = cr.usr_id_create
    WHERE cr.crq_annul = 0
      AND (p_contractor IS NULL OR p_contractor = '' OR upper(c.ctr_name) LIKE '%' || upper(p_contractor) || '%')
      AND (v_request_type_id IS NULL OR cr.crq_request_type_id = v_request_type_id)
      AND (p_equipment IS NULL OR p_equipment = '' OR upper(cr.crq_equipment::VARCHAR) LIKE '%' || upper(p_equipment) || '%')
      AND (p_stuff_category IS NULL OR p_stuff_category = '' OR upper(sc.stf_name) LIKE '%' || upper(p_stuff_category) || '%')
      AND (p_user IS NULL OR p_user = '' OR upper(u.usr_name) LIKE '%' || upper(p_user) || '%')
    ORDER BY cr.crq_receive_date DESC, cr.crq_id DESC;
END;
$$;


--
-- Name: dcl_cus_code_history_trigger_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_cus_code_history_trigger_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    if (new.id is null ) then
    new.id = nextval('dcl_cus_code_history_generator');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_custom_code_au0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_custom_code_au0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  if (new.cus_code != old.cus_code) then
    UPDATE dcl_produce SET cus_code = new.cus_code where cus_code = old.cus_code;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_custom_code_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_custom_code_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.CUS_ID IS NULL) THEN
    NEW.CUS_ID = nextval('gen_dcl_custome_code_id');
  ELSE
        ID = nextval('gen_dcl_custome_code_id');
        IF ( ID < NEW.CUS_ID ) THEN
          ID = nextval('gen_dcl_custome_code_id');
  END IF;
  END IF;
    NEW.cus_create_date = CURRENT_TIMESTAMP;
    NEW.cus_edit_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_custom_code_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_custom_code_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.cus_edit_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_custom_code_filter(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_custom_code_filter(p_cus_code_in character varying) RETURNS TABLE(cus_id integer, cus_code character varying, cus_description character varying, cus_percent numeric, cus_block smallint)
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _rec RECORD;
BEGIN
  p_cus_code_in = upper(p_cus_code_in);

  FOR _rec IN select cus_id, cus_code, cus_description, cus_percent, cus_block from dcl_custom_code cus where cus_instant = ( select max(cus_instant) from dcl_custom_code where cus_code = cus.cus_code and cus_instant <= ADDDAY((SELECT CAST('NOW' AS DATE) FROM RDB$DATABASE), 1) ) and ( p_cus_code_in is null or ( (upper(cus.cus_code) || ',' || upper(cus.cus_description)) like('%' || p_cus_code_in || '%')) )
  LOOP
    cus_id := _rec.cus_id;
    cus_code := _rec.cus_code;
    cus_description := _rec.cus_description;
    cus_percent := _rec.cus_percent;
    cus_block := _rec.cus_block;
    RETURN NEXT;
  END LOOP;
END
$_$;


--
-- Name: dcl_decode_id_list(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_decode_id_list(p_par_ids character varying) RETURNS TABLE(par_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  int_len INTEGER;
  int_pos INTEGER;
  txt_id VARCHAR(30);
  txt_symbol VARCHAR(1);
BEGIN
  int_len := LENGTH(p_par_ids);
  int_pos := 1;
  txt_id := '';
  WHILE (int_pos <= int_len) LOOP
    txt_symbol := SUBSTR(p_par_ids, int_pos, 1);
    IF (txt_symbol != ';') THEN
      txt_id := txt_id || txt_symbol;
    ELSE
      IF (txt_id != '' AND txt_id IS NOT NULL) THEN
        par_id := CAST(txt_id AS INTEGER);
        RETURN NEXT;
        txt_id := '';
      END IF;
    END IF;
    int_pos := int_pos + 1;
  END LOOP;
  IF (txt_id != '' AND txt_id IS NOT NULL) THEN
    par_id := CAST(txt_id AS INTEGER);
    RETURN NEXT;
  END IF;
END $$;


--
-- Name: dcl_delete_contract_closed(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_delete_contract_closed(IN p_ctc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (p_ctc_id IS NULL) THEN
    RETURN;
  END IF;
  DELETE FROM dcl_contract_closed WHERE ctc_id = p_ctc_id;
END
$$;


--
-- Name: dcl_delete_duplicate_ctn(); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_delete_duplicate_ctn()
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN SELECT ctn_id FROM dcl_catalog_number cn
    WHERE (SELECT COUNT(*) FROM dcl_catalog_number cn2
      WHERE cn2.stf_id = cn.stf_id AND cn2.prd_id = cn.prd_id) > 1
    AND cn.ctn_id > (SELECT MIN(cn3.ctn_id) FROM dcl_catalog_number cn3
      WHERE cn3.stf_id = cn.stf_id AND cn3.prd_id = cn.prd_id)
  LOOP
    DELETE FROM dcl_catalog_number WHERE ctn_id = _rec.ctn_id;
  END LOOP;
END $$;


--
-- Name: dcl_delivery_request_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_delivery_request_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.DLR_ID IS NULL) THEN
    NEW.DLR_ID = nextval('gen_dcl_delivery_request_id');
  ELSE
        ID = nextval('gen_dcl_delivery_request_id');
        IF ( ID < NEW.DLR_ID ) THEN
          ID = nextval('gen_dcl_delivery_request_id');
  END IF;
  END IF;

  new.dlr_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.dlr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
  if ( new.dlr_place_request is not null ) then
    new.dlr_place_date = CURRENT_TIMESTAMP;
    new.usr_id_place = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_delivery_request_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_delivery_request_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.dlr_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
  if ( new.dlr_place_request is not null and old.dlr_place_request is null ) then
    new.dlr_place_date = CURRENT_TIMESTAMP;
    new.usr_id_place = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_delivery_request_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_delivery_request_filter(p_dlr_number_in character varying, p_dlr_date_begin_in character varying, p_dlr_date_end_in character varying, p_dlr_user_in character varying, p_dlr_fair_trade_in character varying, p_unexecuted character varying, p_minsk character varying, p_annul_exclude character varying, p_specification_numbers_in character varying) RETURNS TABLE(dlr_id integer, dlr_number character varying, dlr_date date, dlr_fair_trade smallint, dlr_place_request smallint, dlr_user character varying, dlr_annul smallint, specification_numbers character varying, customers character varying, contracts character varying, orders character varying, dlr_minsk smallint, usr_id integer, dep_id integer, produce_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dlr_number_in VARCHAR(20);
  v_dlr_user_in VARCHAR(50);
  v_specification_numbers_in VARCHAR(100);
  v_date_begin DATE;
  v_date_end DATE;
  v_fair_trade SMALLINT;
  v_unexecuted SMALLINT;
  v_minsk_val SMALLINT;
  v_annul SMALLINT;
  v_count_rest_drp DECIMAL(15,2);
  v_dlr_need_deliver SMALLINT;
  v_dlr_executed SMALLINT;
  v_need_suspend SMALLINT;
  rec RECORD;
  srec RECORD;
BEGIN
  v_dlr_number_in := upper(p_dlr_number_in);
  v_dlr_user_in := upper(p_dlr_user_in);
  v_specification_numbers_in := upper(p_specification_numbers_in);
  v_date_begin := CASE WHEN p_dlr_date_begin_in IS NOT NULL AND p_dlr_date_begin_in != '' THEN p_dlr_date_begin_in::DATE ELSE NULL END;
  v_date_end := CASE WHEN p_dlr_date_end_in IS NOT NULL AND p_dlr_date_end_in != '' THEN p_dlr_date_end_in::DATE ELSE NULL END;
  v_fair_trade := CASE WHEN p_dlr_fair_trade_in IS NOT NULL AND p_dlr_fair_trade_in != '' THEN p_dlr_fair_trade_in::SMALLINT ELSE NULL END;
  v_unexecuted := CASE WHEN p_unexecuted IS NOT NULL AND p_unexecuted != '' THEN p_unexecuted::SMALLINT ELSE NULL END;
  v_minsk_val := CASE WHEN p_minsk IS NOT NULL AND p_minsk != '' THEN p_minsk::SMALLINT ELSE 0 END;
  v_annul := CASE WHEN p_annul_exclude IS NOT NULL AND p_annul_exclude != '' THEN p_annul_exclude::SMALLINT ELSE NULL END;

  FOR rec IN
    SELECT d.dlr_id, d.dlr_number, d.dlr_date, d.dlr_fair_trade, d.dlr_need_deliver,
           d.dlr_place_request, d.usr_id_create,
           (SELECT ul.usr_surname || ' ' || ul.usr_name FROM dcl_user_language ul WHERE ul.usr_id = d.usr_id_create AND ul.lng_id = 1) AS user_name,
           d.dlr_annul, d.dlr_minsk, d.dlr_executed
    FROM dcl_delivery_request d
    WHERE (v_fair_trade IS NULL OR v_fair_trade = 0 OR (v_fair_trade = 1 AND d.dlr_fair_trade = v_fair_trade))
      AND d.dlr_minsk = v_minsk_val
      AND (v_annul IS NULL OR (v_annul IS NOT NULL AND d.dlr_annul IS NULL))
      AND (v_date_begin IS NULL OR d.dlr_date >= v_date_begin)
      AND (v_date_end IS NULL OR d.dlr_date <= v_date_end)
      AND (v_dlr_user_in IS NULL OR v_dlr_user_in = '' OR
           (SELECT upper(ul.usr_surname || ' ' || ul.usr_name) FROM dcl_user_language ul WHERE ul.usr_id = d.usr_id_create AND ul.lng_id = 1) LIKE '%' || v_dlr_user_in || '%')
      AND (v_dlr_number_in IS NULL OR v_dlr_number_in = '' OR upper(d.dlr_number) LIKE '%' || v_dlr_number_in || '%')
    ORDER BY d.dlr_date DESC, d.dlr_number DESC
  LOOP
    dlr_id := rec.dlr_id;
    dlr_number := rec.dlr_number;
    dlr_date := rec.dlr_date;
    dlr_fair_trade := rec.dlr_fair_trade;
    v_dlr_need_deliver := rec.dlr_need_deliver;
    dlr_place_request := rec.dlr_place_request;
    usr_id := rec.usr_id_create;
    dlr_user := rec.user_name;
    dlr_annul := rec.dlr_annul;
    dlr_minsk := rec.dlr_minsk;
    v_dlr_executed := rec.dlr_executed;

    SELECT u.dep_id INTO dep_id FROM dcl_user u WHERE u.usr_id = rec.usr_id_create;
    SELECT count(drp.drp_id) INTO produce_count FROM dcl_dlr_list_produce drp WHERE drp.dlr_id = rec.dlr_id;

    v_need_suspend := 1;
    specification_numbers := '';
    customers := '';
    contracts := '';
    orders := '';

    IF rec.dlr_fair_trade IS NULL OR (rec.dlr_fair_trade IS NOT NULL AND rec.dlr_minsk IS NOT NULL) THEN
      FOR srec IN
        SELECT DISTINCT spi.spi_number
        FROM dcl_spi_list_produce sip
        JOIN dcl_specification_import spi ON spi.spi_id = sip.spi_id
        JOIN dcl_dlr_list_produce drp ON sip.drp_id = drp.drp_id
        WHERE drp.dlr_id = rec.dlr_id
      LOOP
        specification_numbers := specification_numbers || srec.spi_number || '<br>';
      END LOOP;

      v_need_suspend := 0;
      IF v_specification_numbers_in IS NULL OR v_specification_numbers_in = '' OR upper(specification_numbers) LIKE '%' || v_specification_numbers_in || '%' THEN
        v_need_suspend := 1;

        FOR srec IN SELECT DISTINCT cn.ctr_name FROM dcl_get_customer_for_dlr(rec.dlr_id) cn LOOP
          customers := customers || srec.ctr_name || '<br>';
        END LOOP;

        FOR srec IN SELECT DISTINCT cn.con_num_and_other FROM dcl_get_con_num_for_dlr(rec.dlr_id) cn LOOP
          contracts := contracts || srec.con_num_and_other || '<br>';
        END LOOP;

        FOR srec IN SELECT DISTINCT od.ord_num_date FROM dcl_get_ord_num_date_for_dlr(rec.dlr_id) od LOOP
          orders := orders || srec.ord_num_date || '<br>';
        END LOOP;
      END IF;
    ELSE
      IF v_specification_numbers_in IS NOT NULL AND v_specification_numbers_in != '' THEN
        v_need_suspend := 0;
      END IF;
    END IF;

    IF v_unexecuted IS NULL AND v_need_suspend = 1 THEN
      RETURN NEXT;
    ELSE
      IF rec.dlr_minsk = 0 THEN
        SELECT g.count_rest_drp INTO v_count_rest_drp FROM dcl_get_count_rest_drp(rec.dlr_id, v_dlr_need_deliver) g;
        IF v_count_rest_drp > 0 AND v_need_suspend = 1 THEN
          RETURN NEXT;
        END IF;
      END IF;

      IF rec.dlr_minsk = 1 AND v_dlr_executed IS NULL THEN
        RETURN NEXT;
      END IF;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_delivery_request_insert(date, character varying, smallint, character varying, character varying, smallint, smallint, smallint, smallint, smallint, smallint, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_delivery_request_insert(p_dlr_date date, p_dlr_number character varying, p_dlr_fair_trade smallint, p_dlr_wherefrom character varying, p_dlr_comment character varying, p_dlr_place_request smallint, p_dlr_minsk smallint, p_dlr_need_deliver smallint, p_dlr_ord_not_form smallint, p_dlr_guarantee_repair smallint, p_dlr_include_in_spec smallint, p_dlr_annul smallint, p_dlr_executed smallint) RETURNS TABLE(dlr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_delivery_request (
    p_dlr_number,
    p_dlr_date,
    p_dlr_fair_trade,
    p_dlr_wherefrom,
    p_dlr_comment,
    p_dlr_place_request,
    p_dlr_minsk,
    p_dlr_need_deliver,
    p_dlr_ord_not_form,
    p_dlr_guarantee_repair,
    p_dlr_include_in_spec,
    p_dlr_annul,
    p_dlr_executed
  )
  values (
    p_dlr_number,
    p_dlr_date,
    p_dlr_fair_trade,
    p_dlr_wherefrom,
    p_dlr_comment,
    p_dlr_place_request,
    p_dlr_minsk,
    p_dlr_need_deliver,
    p_dlr_ord_not_form,
    p_dlr_guarantee_repair,
    p_dlr_include_in_spec,
    p_dlr_annul,
    p_dlr_executed
  )
  returning dlr_id into dlr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_department_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_department_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.DEP_ID IS NULL) THEN
    NEW.DEP_ID = nextval('gen_dcl_department_id');
  ELSE
        ID = nextval('gen_dcl_department_id');
        IF ( ID < NEW.DEP_ID ) THEN
          ID = nextval('gen_dcl_department_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_department_filter(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_department_filter(p_dep_name_in character varying) RETURNS TABLE(dep_id integer, dep_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  p_dep_name_in = upper(p_dep_name_in);

  FOR _rec IN select dep_id, dep_name from dcl_department dep where ( p_dep_name_in is null or p_dep_name_in like '' or upper(dep.dep_name) like('%' || p_dep_name_in || '%') )
  LOOP
    dep_id := _rec.dep_id;
    dep_name := _rec.dep_name;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_dlr_count_by_prd_id_dlr_id(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_count_by_prd_id_dlr_id(p_prd_id integer, p_stf_id integer, p_ord_id integer, p_dlr_id integer) RETURNS TABLE(trn_produce_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_opr_id INTEGER;
  v_drp_count DECIMAL(15,2);
  v_ord_id_local INTEGER;
  _rec RECORD;
BEGIN
  trn_produce_count := 0;
  FOR _rec IN SELECT drp.opr_id, drp.drp_count
    FROM dcl_delivery_request dlr, dcl_dlr_list_produce drp
    WHERE dlr.dlr_id = p_dlr_id AND dlr.stf_id = p_stf_id
      AND drp.dlr_id = dlr.dlr_id AND drp.prd_id = p_prd_id
  LOOP
    v_opr_id := _rec.opr_id;
    v_drp_count := _rec.drp_count;
    IF (p_ord_id IS NOT NULL AND v_opr_id IS NOT NULL) THEN
      SELECT opr.ord_id INTO v_ord_id_local FROM dcl_ord_list_produce opr WHERE opr.opr_id = v_opr_id;
      IF (p_ord_id = v_ord_id_local) THEN
        trn_produce_count := trn_produce_count + v_drp_count;
      END IF;
    ELSIF (p_ord_id IS NULL) THEN
      trn_produce_count := trn_produce_count + v_drp_count;
    END IF;
  END LOOP;
  RETURN NEXT;
END $$;


--
-- Name: dcl_dlr_list_produce_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_list_produce_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_count integer;
  apr_count integer;
  asm_id_old integer;
BEGIN
  if ( old.asm_id is not null ) then
    asm_count = 0;
    select count(asm_id) from dcl_prc_list_produce where asm_id = old.asm_id into asm_count;
    if ( asm_count = 0 ) then
      select count(asm_id) from dcl_dlr_list_produce where asm_id = old.asm_id and drp_id != old.drp_id into asm_count;
  END IF;
    if ( asm_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = old.asm_id;
  END IF;
  END IF;
  if ( old.apr_id is not null ) then
    apr_count = 0;
    select asm_id from dcl_asm_list_produce where apr_id = old.apr_id into asm_id_old;
    select count(apr_id) from dcl_prc_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) into apr_count;
    if ( apr_count = 0 ) then
      select count(apr_id) from dcl_dlr_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) and drp_id != old.drp_id into apr_count;
  END IF;
    if ( apr_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = asm_id_old;
  END IF;
  END IF;
RETURN OLD;
END
$$;


--
-- Name: dcl_dlr_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.DRP_ID IS NULL) THEN
    NEW.DRP_ID = nextval('gen_dcl_dlr_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_dlr_list_produce_id');
        IF ( ID < NEW.DRP_ID ) THEN
          ID = nextval('gen_dcl_dlr_list_produce_id');
  END IF;
  END IF;

  if ( new.asm_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 where asm_id = new.asm_id;
  END IF;
  if ( new.apr_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 where asm_id = (select asm_id from dcl_asm_list_produce where apr_id = new.apr_id);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_dlr_list_produce_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_list_produce_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_count integer;
  apr_count integer;
  asm_id_old integer;
BEGIN
  if ( new.asm_id != old.asm_id or ( new.asm_id is null and old.asm_id is not null ) ) then
    asm_count = 0;
    select count(asm_id) from dcl_prc_list_produce where asm_id = old.asm_id into asm_count;
    if ( asm_count = 0 ) then
      select count(asm_id) from dcl_dlr_list_produce where asm_id = old.asm_id and drp_id != old.drp_id into asm_count;
  END IF;
    if ( asm_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = old.asm_id;
  END IF;
  END IF;
  if ( new.apr_id != old.apr_id or ( new.apr_id is null and old.apr_id is not null ) ) then
    apr_count = 0;
    select asm_id from dcl_asm_list_produce where apr_id = old.apr_id into asm_id_old;
    select count(apr_id) from dcl_prc_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) into apr_count;
    if ( apr_count = 0 ) then
      select count(apr_id) from dcl_dlr_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) and drp_id != old.drp_id into apr_count;
  END IF;
    if ( apr_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = asm_id_old;
  END IF;
  END IF;

  if ( new.asm_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 WHERE asm_id = new.asm_id;
  END IF;
  if ( new.apr_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 WHERE asm_id = (select asm_id from dcl_asm_list_produce where apr_id = new.apr_id);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_dlr_list_produce_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_list_produce_load(p_drp_id_in integer) RETURNS TABLE(drp_id integer, dlr_id integer, prd_id integer, drp_price numeric, drp_count numeric, stf_id integer, stf_name character varying, ctr_id integer, ctr_name character varying, opr_id integer, asm_id integer, apr_id integer, sip_id integer, prs_id integer, prs_name character varying, drp_purpose character varying, drp_occupied integer, receive_manager_id integer, receive_manager_name character varying, receive_manager_surname character varying, receive_date date, ord_number character varying, ord_date date, spi_number character varying, spi_date date, spi_numbers character varying, dlr_ord_not_form smallint, drp_have_depend smallint, ord_info character varying, ord_info_contractor_for character varying, ord_id integer, drp_max_extra smallint, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spi_number_local varchar(100);
BEGIN
  drp_id = null;
  dlr_id = null;
  prd_id = null;
  drp_price = null;
  drp_count = null;
  stf_id = null;
  stf_name = null;
  ctr_id = null;
  ctr_name = null;
  spc_id = null;
  spc_number = null;
  spc_date = null;
  con_id = null;
  con_number = null;
  con_date = null;
  cur_name = null;
  opr_id = null;
  asm_id = null;
  apr_id = null;
  sip_id = null;
  prs_id = null;
  prs_name = null;
  drp_purpose = null;
  drp_occupied = null;
  receive_manager_id = null;
  receive_date = null;
  ord_number = null;
  ord_date = null;
  ord_id = null;
  spi_number = null;
  spi_date = null;
  receive_manager_name = null;
  receive_manager_surname = null;
  dlr_ord_not_form = null;
  drp_have_depend = null;
  ord_info = null;
  ord_info_contractor_for = null;
  drp_max_extra = null;

  select
      drp.drp_id,
      drp.dlr_id,
      drp.prd_id,
      drp.drp_price,
      drp.drp_count,
      drp.stf_id,
      stf.stf_name,
      drp.ctr_id,
      drp.spc_id,
      drp.opr_id,
      drp.asm_id,
      drp.apr_id,
      drp.sip_id,
      drp.prs_id,
      drp.drp_purpose,
      (select drp_id from DCL_OCCUPIED_DLR_PRODUCE_V where drp_id = drp.drp_id) as drp_occupied,
      drp.receive_manager_id,
      drp.receive_date,
      dlr.dlr_ord_not_form,
      drp.drp_max_extra
  from
      dcl_dlr_list_produce drp,
      dcl_stuff_category stf,
      dcl_delivery_request dlr
  where drp.drp_id = p_drp_id_in and
        stf.stf_id = drp.stf_id and
        dlr.dlr_id = drp.dlr_id
  into
      drp_id,
      dlr_id,
      prd_id,
      drp_price,
      drp_count,
      stf_id,
      stf_name,
      ctr_id,
      spc_id,
      opr_id,
      asm_id,
      apr_id,
      sip_id,
      prs_id,
      drp_purpose,
      drp_occupied,
      receive_manager_id,
      receive_date,
      dlr_ord_not_form,
      drp_max_extra
    ;

    if ( ctr_id is not null ) then
      select ctr_name from dcl_contractor where ctr_id = ctr_id into ctr_name;
  END IF;

    if (spc_id is not null) then
      select
        spc.spc_number,
        spc.spc_date,
        con.con_id,
        con.con_number,
        con.con_date,
        cur.cur_name
      from
        dcl_con_list_spec spc,
        dcl_contract con,
        dcl_currency cur
      where spc.spc_id = spc_id and
            con.con_id = spc.con_id and
            cur.cur_id = con.cur_id
      into 
        spc_number,
        spc_date,
        con_id,
        con_number,
        con_date,
        cur_name
      ;
  END IF;

    if ( prs_id is not null ) then
      select prs_name from dcl_purpose where prs_id = prs_id into prs_name;
  END IF;

    if ( opr_id is not null ) then
      select
        ord.ord_id,
        ord.ord_number,
        ord.ord_date
      from dcl_order ord,
           dcl_ord_list_produce opr
      where ord.ord_id = opr.ord_id and
            opr.opr_id = opr_id
      into
        ord_id,
        ord_number,
        ord_date
      ;

      select
        opr_have_depend
      from dcl_ord_list_produce_load(opr_id)
      into
        drp_have_depend
      ;
  END IF;

    if ( asm_id is not null ) then
      drp_have_depend = 1;

      select ord_info,
             ord_info_contractor_for,
             ord_number,
             ord_date
      from dcl_assemble_load(asm_id)
      into   ord_info,
             ord_info_contractor_for,
             ord_number,
             ord_date
      ;
  END IF;

    if ( apr_id is not null ) then
      select
        ord.ord_id,
        ord.ord_number,
        ord.ord_date
      from
        dcl_order ord,
        dcl_ord_list_produce opr,
        dcl_assemble asm,
        dcl_asm_list_produce apr
      where ord.ord_id = opr.ord_id and
            opr.opr_id = asm.opr_id and
            asm.asm_id = apr.asm_id and
            apr.apr_id = apr_id
      into
        ord_id,
        ord_number,
        ord_date
      ;
  END IF;

    if ( sip_id is not null ) then
      select
        spi_number,
        spi_date
      from dcl_specification_import spi,
           dcl_spi_list_produce sip
      where spi.spi_id = sip.spi_id and
            sip.sip_id = sip_id
      into
        spi_number,
        spi_date
      ;

      select ord_id from dcl_spi_list_produce_load(sip_id) into ord_id;
  END IF;

    if ( receive_manager_id is not null ) then
      select
        (select usr_name from dcl_user_language where usr_id = u.usr_id and lng_id = 1) as usr_name,
        (select usr_surname from dcl_user_language where usr_id = u.usr_id and lng_id = 1) as usr_surname
      from dcl_user u
      where usr_id = receive_manager_id
      into
        receive_manager_name, 
        receive_manager_surname
      ;
  END IF;

    spi_numbers = '';
  FOR spi_number_local IN select distinct(spi.spi_number) from dcl_spi_list_produce sip, dcl_specification_import spi where spi.spi_id = sip.spi_id and sip.drp_id = p_drp_id_in
  LOOP
      spi_numbers = spi_numbers || spi_number_local || ', ';
  END LOOP;

    RETURN NEXT;
END
$$;


--
-- Name: dcl_dlr_list_produces_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_dlr_list_produces_load(p_dlr_id_in integer) RETURNS TABLE(drp_id integer, dlr_id integer, prd_id integer, drp_price numeric, drp_count numeric, stf_id integer, stf_name character varying, ctr_id integer, ctr_name character varying, opr_id integer, asm_id integer, apr_id integer, sip_id integer, prs_id integer, prs_name character varying, drp_purpose character varying, drp_occupied integer, receive_manager_id integer, receive_manager_name character varying, receive_manager_surname character varying, receive_date date, ord_number character varying, ord_date date, spi_number character varying, spi_date date, spi_numbers character varying, drp_have_depend smallint, ord_info character varying, ord_info_contractor_for character varying, ord_id integer, drp_max_extra smallint, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
  dlr_id = p_dlr_id_in;

  FOR drp_id IN select drp_id from dcl_dlr_list_produce drp where drp.dlr_id = p_dlr_id_in order by drp_id
  LOOP
    select
      dlr_id,
      prd_id,
      drp_price,
      drp_count,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      spc_id,
      spc_number,
      spc_date,
      con_id, 
      con_number,
      con_date,
      opr_id,
      asm_id,
      apr_id,
      sip_id,
      prs_id,
      prs_name,
      drp_purpose,
      drp_occupied,
      receive_manager_id,
      receive_manager_name,
      receive_manager_surname,
      receive_date,
      ord_id,
      ord_number,
      ord_date,
      spi_number,
      spi_date,
      spi_numbers,
      drp_have_depend,
      ord_info,
      ord_info_contractor_for,
      drp_max_extra
    from
      dcl_dlr_list_produce_load(drp_id)
    into
      dlr_id,
      prd_id,
      drp_price,
      drp_count,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      spc_id,
      spc_number,
      spc_date,
      con_id,
      con_number,
      con_date,
      opr_id,
      asm_id,
      apr_id,
      sip_id,
      prs_id,
      prs_name,
      drp_purpose,
      drp_occupied,
      receive_manager_id,
      receive_manager_name,
      receive_manager_surname,
      receive_date,
      ord_id,
      ord_number,
      ord_date,
      spi_number,
      spi_date,
      spi_numbers,
      drp_have_depend,
      ord_info,
      ord_info_contractor_for,
      drp_max_extra
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_drp_depended_lines(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_drp_depended_lines(p_asm_id integer) RETURNS TABLE(id integer, prd_id integer, stf_id integer, prd_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_asm_id is not null ) then
  FOR _rec IN select -1, apr.prd_id as "produce.id", asm.stf_id, apr.apr_count from dcl_assemble asm, dcl_asm_list_produce apr where asm.p_asm_id = p_asm_id and apr.p_asm_id = asm.p_asm_id
  LOOP
    id := _rec.id;
    prd_id := _rec.prd_id;
    stf_id := _rec.stf_id;
    prd_count := _rec.prd_count;
      RETURN NEXT;
  END LOOP;
  END IF;
END
$$;


--
-- Name: dcl_equipment_filter(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_equipment_filter(p_con_id_in integer, p_crq_equipment_in character varying, p_req_id integer) RETURNS TABLE(lps_id integer, crq_equipment character varying, ctn_number character varying, stf_name character varying, lps_serial_num character varying, lps_year_out character varying, lps_usr_id integer, lps_usr_fullname character varying, lps_enter_in_use_date character varying, mad_complexity character varying, lps_occupied integer, crq_number character varying, shp_date character varying, con_number character varying, con_date character varying, spc_number character varying, spc_date character varying, con_seller_id integer, con_seller character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  filterstr varchar(3000);
  lps_enter_in_use_date_local date;
  mad_id integer;
  _rec RECORD;
BEGIN
  p_crq_equipment_in = upper(p_crq_equipment_in);

  FOR _rec IN select lps.lps_id, lps.lps_serial_num, lps.lps_year_out, lps.lps_enter_in_use_date, (select stf_name from dcl_stuff_category stf where stf.stf_id = lps.stf_id), ctn.ctn_number, prd.prd_name || coalesce(' ' || prd.prd_type, '') || coalesce(' ' || prd.prd_params, '') || coalesce(' ' || prd.prd_add_params, ''), ctn.mad_id from dcl_con_list_spec spc, dcl_shipping shp, dcl_shp_list_produce lps, dcl_prc_list_produce lpc, dcl_produce prd, dcl_catalog_number ctn where spc.con_id = p_con_id_in and shp.spc_id = spc.spc_id and lps.shp_id = shp.shp_id and lpc.lpc_id = lps.lpc_id and prd.prd_id = lpc.prd_id and ctn.prd_id = lpc.prd_id and ctn.stf_id = lps.stf_id and exists ( select ctn_id from dcl_catalog_number where prd_id = prd.prd_id and mad_id is not null )
  LOOP
    lps_id := _rec.lps_id;
    lps_serial_num := _rec.lps_serial_num;
    lps_year_out := _rec.lps_year_out;
    lps_enter_in_use_date_local := _rec.lps_enter_in_use_date;
    stf_name := _rec.stf_name;
    ctn_number := _rec.ctn_number;
    crq_equipment := _rec.crq_equipment;
    mad_id := _rec.mad_id;
    lps_occupied := null;
    if ( p_req_id = 1 ) then -- only for PNP
      select distinct lps_id from dcl_contractor_request where lps_id = lps_id and crq_request_type_id = 1 into lps_occupied;
      if ( lps_occupied is not null ) then
        SELECT crq_number from dcl_contractor_request where lps_id = lps_id and crq_request_type_id = 1 into crq_number;
  END IF;
  END IF;

    lps_enter_in_use_date := null;
    if ( lps_enter_in_use_date_local is not null ) then
      select strdate from date2str(lps_enter_in_use_date_local) into lps_enter_in_use_date;
  END IF;

    if ( mad_id is not null ) then
      select mad_complexity from dcl_montage_adjustment where mad_id = mad_id into mad_complexity;
  END IF;

    SELECT usr_id
      INTO lps_usr_id
      from dcl_lps_list_manager
    where lps_id = lps_id;

    lps_usr_fullname := null;
    if ( lps_usr_id is not null ) then
      SELECT usr_surname || ' ' || usr_name
        INTO lps_usr_fullname
        from dcl_user_language
      where usr_id = lps_usr_id and lng_id = 1;
  END IF;

    -- not PNP - Service or Guarantee
    shp_date := null;
    con_number := null;
    con_date := null;
    spc_number := null;
    spc_date := null;
    con_seller_id := null;
    con_seller := null;
    if ( p_req_id != 1 ) then
      select
        shp_date,
        con_number,
        con_date,
        spc_number,
        spc_date,
        con_seller_id,
        con_seller
      from dcl_add_info_service_guarantee(lps_id)
      into
        shp_date,
        con_number,
        con_date,
        spc_number,
        spc_date,
        con_seller_id,
        con_seller
      ;
  END IF;

    if ( p_crq_equipment_in is null or p_crq_equipment_in like '' ) then
      RETURN NEXT;
  ELSE
      filterstr := crq_equipment || coalesce(' ' || ctn_number, '') || coalesce(' ' || stf_name, '') || coalesce(' ' || lps_serial_num, '');
      filterstr := upper(filterstr);
      if ( filterstr like '%' || p_crq_equipment_in || '%' ) then
        RETURN NEXT;
  END IF;
  END IF;

  END LOOP;
END
$$;


--
-- Name: dcl_equipment_for_produce_load(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_equipment_for_produce_load(p_stf_id integer, p_prd_id integer) RETURNS TABLE(crq_equipment character varying, ctn_number character varying, mad_complexity character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
     select ctn.ctn_number,
            prd.prd_name || coalesce(' ' || prd.prd_type, '') || coalesce(' ' || prd.prd_params, '') || coalesce(' ' || prd.prd_add_params, ''),
            mad.mad_complexity
    from dcl_produce prd,
         dcl_catalog_number ctn
         left join dcl_montage_adjustment mad on mad.mad_id = ctn.mad_id
    where prd.p_prd_id = p_prd_id and
          ctn.p_prd_id = prd.p_prd_id and
          ctn.p_stf_id = p_stf_id
    into  ctn_number,
          crq_equipment,
          mad_complexity;

   RETURN NEXT;
END
$$;


--
-- Name: dcl_equipment_guaranty_load(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_equipment_guaranty_load(p_lps_id integer, p_prd_id integer) RETURNS TABLE(crq_equipment character varying, ctn_number character varying, stf_name character varying, lps_serial_num character varying, lps_year_out character varying, mad_complexity character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
     select lps.lps_serial_num,
            lps.lps_year_out,
            (select stf_name from dcl_stuff_category stf where stf.stf_id = lps.stf_id),
            ctn.ctn_number,
            prd.prd_name || coalesce(' ' || prd.prd_type, '') || coalesce(' ' || prd.prd_params, '') || coalesce(' ' || prd.prd_add_params, ''),
            mad.mad_complexity
    from dcl_shp_list_produce lps,
         dcl_produce prd,
         dcl_catalog_number ctn
         left join dcl_montage_adjustment mad on mad.mad_id = ctn.mad_id
    where lps.p_lps_id = p_lps_id and
          prd.p_prd_id = p_prd_id and
          ctn.p_prd_id = prd.p_prd_id and
          ctn.stf_id = lps.stf_id
    into  lps_serial_num,
          lps_year_out,
          stf_name,
          ctn_number,
          crq_equipment,
          mad_complexity;

   RETURN NEXT;
END
$$;


--
-- Name: dcl_equipment_pnp_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_equipment_pnp_load(p_lps_id integer) RETURNS TABLE(crq_equipment character varying, ctn_number character varying, stf_name character varying, lps_serial_num character varying, lps_year_out character varying, lps_enter_in_use_date character varying, mad_complexity character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  mad_id integer;
  lps_enter_in_use_date_local date;
BEGIN
   mad_complexity = null;

   select lps.lps_serial_num,
          lps.lps_year_out,
          lps.lps_enter_in_use_date,
          (select stf_name from dcl_stuff_category stf where stf.stf_id = lps.stf_id),
          ctn.ctn_number,
          prd.prd_name || coalesce(' ' || prd.prd_type, '') || coalesce(' ' || prd.prd_params, '') || coalesce(' ' || prd.prd_add_params, ''),
          ctn.mad_id
   from dcl_shp_list_produce lps,
        dcl_prc_list_produce lpc,
        dcl_produce prd,
        dcl_catalog_number ctn
   where lps.p_lps_id = p_lps_id and
         lpc.lpc_id = lps.lpc_id and
         prd.prd_id = lpc.prd_id and
         ctn.prd_id = lpc.prd_id and
         ctn.stf_id = lps.stf_id
   into  lps_serial_num,
         lps_year_out,
         lps_enter_in_use_date_local,
         stf_name,
         ctn_number,
         crq_equipment,
         mad_id;

   lps_enter_in_use_date = null;
   if ( lps_enter_in_use_date_local is not null ) then
     select strdate from date2str(lps_enter_in_use_date_local) into lps_enter_in_use_date;
  END IF;

   if ( mad_id is not null ) then
     select mad_complexity from dcl_montage_adjustment where mad_id = mad_id into mad_complexity;
  END IF;

   RETURN NEXT;
END
$$;


--
-- Name: dcl_field_comment_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_field_comment_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.FCM_ID IS NULL) THEN
    NEW.FCM_ID = nextval('gen_dcl_field_comment_id');
  ELSE
        ID = nextval('gen_dcl_field_comment_id');
        IF ( ID < NEW.FCM_ID ) THEN
          ID = nextval('gen_dcl_field_comment_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_files_path_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_files_path_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.FLP_ID IS NULL) THEN
    NEW.FLP_ID = nextval('gen_dcl_files_path_id');
  ELSE
        ID = nextval('gen_dcl_files_path_id');
        IF ( ID < NEW.FLP_ID ) THEN
          ID = nextval('gen_dcl_files_path_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_get_1c_by_prc_id_prd_id(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_1c_by_prc_id_prd_id(p_prd_id integer, p_stf_id integer, p_prc_id integer) RETURNS TABLE(lpc_1c_number character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

  FOR lpc_1c_number IN select distinct lpc_1c_number from dcl_prc_list_produce where p_prc_id = p_prc_id and p_prd_id = p_prd_id and p_stf_id = p_stf_id order by lpc_1c_number
  LOOP
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_asm_list_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_asm_list_for_ord(p_ord_id integer) RETURNS TABLE(assemblies character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_num_date varchar(40);
BEGIN
  assemblies = '';

  FOR asm_num_date IN select distinct(asm_num_date) from dcl_get_asm_num_date_for_ord(p_ord_id)
  LOOP
    assemblies = assemblies || asm_num_date || ', ';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_asm_num_date_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_asm_num_date_for_ord(p_ord_id integer) RETURNS TABLE(asm_num_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_date date;
  asm_number varchar(10);
  opr_id integer;
  _rec RECORD;
BEGIN
  FOR _rec IN select opr_id from dcl_ord_list_produce where p_ord_id = p_ord_id
  LOOP
    opr_id := _rec.opr_id;
  FOR _rec IN select asm_date, asm_number from dcl_assemble asm, dcl_asm_list_produce apr where   apr.asm_id = asm.asm_id and apr.opr_id = opr_id  union  select asm_date, asm_number from dcl_assemble asm where   asm.opr_id = opr_id
  LOOP
    asm_date := _rec.asm_date;
    asm_number := _rec.asm_number;
      asm_num_date := '';
      select strdate from date2str(asm_date) into asm_num_date;
      asm_num_date := asm_number || 'from' || asm_num_date;

      RETURN NEXT;
  END LOOP;
  END LOOP;
END
$$;


--
-- Name: dcl_get_att_count_for_spc(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_att_count_for_spc(p_spc_id integer) RETURNS TABLE(attachmentscount integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  SELECT count(*)::INTEGER
  FROM dcl_attachment
  WHERE att_parent_table='DCL_CON_LIST_SPEC' AND att_parent_id = p_spc_id
  INTO attachmentscount;
  
  IF attachmentscount IS NULL THEN
    attachmentscount := 0;
  END IF;
  
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_get_blank_images_in_str(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_blank_images_in_str(p_bln_id integer) RETURNS TABLE(bln_images character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_bim_name varchar(50);
  v_bim_image varchar(32);
  _rec RECORD;
BEGIN
  bln_images = '';
  FOR _rec IN select bi.bim_name, bi.bim_image from dcl_blank_image bi where bi.bln_id = p_bln_id order by bi.bim_id
  LOOP
    v_bim_name := _rec.bim_name;
    v_bim_image := _rec.bim_image;
    bln_images = bln_images || v_bim_name || ': ' || v_bim_image || '<br>';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_categories_for_tree(integer, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, smallint, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_categories_for_tree(p_cat_id_in integer, p_cat_name_in character varying, p_prd_name_in character varying, p_prd_type_in character varying, p_prd_params_in character varying, p_prd_add_params_in character varying, p_stf_id_in integer, p_cus_code_in character varying, p_ctn_number_in character varying, p_not_blocked smallint, p_prd_common_in character varying) RETURNS TABLE(cat_id integer, is_have_produces smallint, is_have_subfolders smallint, prd_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  cat_count integer;
  cat_name varchar(100);
  _rec RECORD;
BEGIN
  p_cat_name_in = upper(p_cat_name_in);

  p_prd_name_in = upper(p_prd_name_in);
  p_prd_type_in = upper(p_prd_type_in);
  p_prd_params_in = upper(p_prd_params_in);
  p_prd_add_params_in = upper(p_prd_add_params_in);
  p_cus_code_in = upper(p_cus_code_in);
  p_ctn_number_in = upper(p_ctn_number_in);
  p_prd_common_in = upper(p_prd_common_in);

  FOR _rec IN select cat_id, cat_name from dcl_category cat where ( cat_id = p_cat_id_in ) order by cat_name
  LOOP
    cat_id := _rec.cat_id;
    cat_name := _rec.cat_name;
      select count(cat_id) from dcl_category where (parent_id = cat_id) into cat_count;
      if ( cat_count = 0 or cat_count is null ) then
        is_have_subfolders := null;
  ELSE
        is_have_subfolders := 1;
  END IF;

      prd_count := null;
      SELECT count(prd_id)
        INTO prd_count
        from
        dcl_produce prd
      where
        prd.cat_id = cat_id and
        ( p_not_blocked is null or ( p_not_blocked is not null and prd_block is null ) ) and
        ( p_stf_id_in is null or ( (select count(ctn_id) from dcl_catalog_number ctn where ctn.prd_id = prd.prd_id and ctn.stf_id = p_stf_id_in ) = 1 ) ) and
        ( p_prd_name_in is null or p_prd_name_in like '' or upper(prd.prd_name) like('%' || p_prd_name_in || '%') ) and
        ( p_prd_type_in is null or p_prd_type_in like '' or upper(prd.prd_type) like('%' || p_prd_type_in || '%') ) and
        ( p_prd_params_in is null or p_prd_params_in like '' or upper(prd.prd_params) like('%' || p_prd_params_in || '%') ) and
        ( p_prd_add_params_in is null or p_prd_add_params_in like '' or upper(prd.prd_add_params) like('%' || p_prd_add_params_in || '%') ) and
        ( p_cus_code_in is null or p_cus_code_in like '' or upper(prd.cus_code) like('%' || p_cus_code_in || '%') ) and
        ( p_ctn_number_in is null or p_ctn_number_in like '' or ( (select count(ctn_id) from dcl_catalog_number ctn where ctn.prd_id = prd.prd_id and upper(ctn.ctn_number) like('%' || p_ctn_number_in || '%') ) >= 1 ) );

      if ( p_prd_common_in is not null and prd_count != 0 ) then
        select count(prd_id) from dcl_get_produces_for_cat(cat_id, p_prd_name_in, p_prd_type_in, p_prd_params_in, p_prd_add_params_in, p_stf_id_in, p_cus_code_in, p_ctn_number_in, p_not_blocked, p_prd_common_in) into prd_count;
  END IF;

      if ( prd_count = 0 ) then
        if ( is_have_subfolders = 1 ) then
         select sum(is_have_produces) from dcl_get_child_categories(cat_id, null, p_prd_name_in, p_prd_type_in, p_prd_params_in, p_prd_add_params_in, p_stf_id_in, p_cus_code_in, p_ctn_number_in, p_not_blocked, p_prd_common_in) into is_have_produces;
  ELSE
          is_have_produces := null;
  END IF;
        RETURN NEXT;
  ELSE
        is_have_produces := 1;
        RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_get_child_categories(integer, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, smallint, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_child_categories(p_cat_id_in integer, p_cat_name_in character varying, p_prd_name_in character varying, p_prd_type_in character varying, p_prd_params_in character varying, p_prd_add_params_in character varying, p_stf_id_in integer, p_cus_code_in character varying, p_ctn_number_in character varying, p_not_blocked smallint, p_prd_common_in character varying) RETURNS TABLE(cat_id integer, is_have_produces smallint, is_have_subfolders smallint, prd_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  cat_count integer;
  cat_name varchar(100);
  _rec RECORD;
BEGIN
  p_cat_name_in = upper(p_cat_name_in);

  p_prd_name_in = upper(p_prd_name_in);
  p_prd_type_in = upper(p_prd_type_in);
  p_prd_params_in = upper(p_prd_params_in);
  p_prd_add_params_in = upper(p_prd_add_params_in);
  p_cus_code_in = upper(p_cus_code_in);
  p_ctn_number_in = upper(p_ctn_number_in);
  p_prd_common_in = upper(p_prd_common_in);

  FOR _rec IN select cat_id, cat_name from dcl_category cat where ( (p_cat_id_in is null and parent_id is null ) or parent_id = p_cat_id_in )
  LOOP
    cat_id := _rec.cat_id;
    cat_name := _rec.cat_name;
      select count(cat_id) from dcl_category where (parent_id = cat_id) into cat_count;
      if ( cat_count = 0 or cat_count is null ) then
        is_have_subfolders := null;
  ELSE
        is_have_subfolders := 1;
  END IF;

      prd_count := null;
      SELECT count(prd_id)
        INTO prd_count
        from
        dcl_produce prd
      where
        prd.cat_id = cat_id and
        ( p_not_blocked is null or ( p_not_blocked is not null and prd_block is null ) ) and
        ( p_stf_id_in is null or ( (select count(ctn_id) from dcl_catalog_number ctn where ctn.prd_id = prd.prd_id and ctn.stf_id = p_stf_id_in ) = 1 ) ) and
        ( p_prd_name_in is null or p_prd_name_in like '' or upper(prd.prd_name) like('%' || p_prd_name_in || '%') ) and
        ( p_prd_type_in is null or p_prd_type_in like '' or upper(prd.prd_type) like('%' || p_prd_type_in || '%') ) and
        ( p_prd_params_in is null or p_prd_params_in like '' or upper(prd.prd_params) like('%' || p_prd_params_in || '%') ) and
        ( p_prd_add_params_in is null or p_prd_add_params_in like '' or upper(prd.prd_add_params) like('%' || p_prd_add_params_in || '%') ) and
        ( p_cus_code_in is null or p_cus_code_in like '' or upper(prd.cus_code) like('%' || p_cus_code_in || '%') ) and
        ( p_ctn_number_in is null or p_ctn_number_in like '' or ( (select count(ctn_id) from dcl_catalog_number ctn where ctn.prd_id = prd.prd_id and upper(ctn.ctn_number) like('%' || p_ctn_number_in || '%') ) >= 1 ) );

      if ( p_prd_common_in is not null and prd_count != 0 ) then
        select count(prd_id) from dcl_get_produces_for_cat(cat_id, p_prd_name_in, p_prd_type_in, p_prd_params_in, p_prd_add_params_in, p_stf_id_in, p_cus_code_in, p_ctn_number_in, p_not_blocked, p_prd_common_in) into prd_count;
  END IF;

      if ( prd_count = 0 ) then
        if ( is_have_subfolders = 1 ) then
         select sum(is_have_produces) from dcl_get_child_categories(cat_id, null, p_prd_name_in, p_prd_type_in, p_prd_params_in, p_prd_add_params_in, p_stf_id_in, p_cus_code_in, p_ctn_number_in, p_not_blocked, p_prd_common_in) into is_have_produces;
  ELSE
          is_have_produces := null;
  END IF;
        RETURN NEXT;
  ELSE
        is_have_produces := 1;
        RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_get_circ_and_rest_for_prd(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_circ_and_rest_for_prd(p_prd_id integer) RETURNS TABLE(prd_count numeric, prd_rest numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_prd_count DECIMAL(15,2);
BEGIN
  prd_count := 0;
  prd_rest := 0;
  SELECT COALESCE(SUM(lpc.lpc_count), 0) INTO v_prd_count
    FROM dcl_prc_list_produce lpc WHERE lpc.prd_id = p_prd_id;
  prd_count := v_prd_count;
  prd_rest := v_prd_count;
  RETURN NEXT;
END $$;


--
-- Name: dcl_get_con_num_for_dlr(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_con_num_for_dlr(p_dlr_id integer) RETURNS TABLE(con_num_and_other character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT drp.asm_id, drp.spc_id
    FROM dcl_dlr_list_produce drp
    WHERE drp.dlr_id = p_dlr_id
  LOOP
    IF rec.spc_id IS NOT NULL THEN
      SELECT (con.con_number || ' от ' || to_char(con.con_date, 'DD.MM.YYYY') || ', ' || spc.spc_number || ' от ' || to_char(spc.spc_date, 'DD.MM.YYYY'))::VARCHAR(150)
      INTO con_num_and_other
      FROM dcl_con_list_spec spc
      JOIN dcl_contract con ON con.con_id = spc.con_id
      WHERE spc.spc_id = rec.spc_id;
      IF FOUND THEN RETURN NEXT; END IF;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_get_contractor_for_for_ord(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_contractor_for_for_ord(p_ord_id integer, p_delimiter character varying) RETURNS TABLE(contractors character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_contractor varchar(200);
BEGIN
  contractors := '';
  FOR v_contractor IN
    SELECT DISTINCT c.ctr_name FROM dcl_get_contractors_for_for_ord(p_ord_id) c
  LOOP
    contractors := contractors || v_contractor || p_delimiter;
  END LOOP;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_get_contractors_for_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_contractors_for_for_ord(p_ord_id integer) RETURNS TABLE(ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ord_in_one_spec smallint;
BEGIN
  SELECT o.ord_in_one_spec FROM dcl_order o WHERE o.ord_id = p_ord_id INTO v_ord_in_one_spec;

  IF v_ord_in_one_spec IS NOT NULL THEN
    RETURN QUERY
      SELECT ctr.ctr_name
      FROM dcl_contractor ctr, dcl_order ord
      WHERE ctr.ctr_id = ord.ctr_id_for AND ord.ord_id = p_ord_id;
  ELSE
    RETURN QUERY
      SELECT DISTINCT ctr.ctr_name
      FROM dcl_contractor ctr, dcl_ord_list_produce opr
      WHERE ctr.ctr_id = opr.ctr_id AND opr.ord_id = p_ord_id;
  END IF;
END;
$$;


--
-- Name: dcl_get_count_day(date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_count_day(date1 date, date2 date) RETURNS TABLE(count_day integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF date1 IS NULL OR date2 IS NULL THEN
    count_day := NULL;
  ELSE
    count_day := date1 - date2;
  END IF;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_get_count_opr_used_in_asm(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_count_opr_used_in_asm(p_opr_id integer) RETURNS TABLE(out_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm decimal(15,2);
  disasm decimal(15,2);
BEGIN
    out_count = 0;

    SELECT coalesce(sum(apr.apr_count * asm.asm_count), 0)
      INTO asm
      from dcl_assemble asm,
         dcl_asm_list_produce apr
    where asm.asm_type = 0 -- ????????????????
          and asm.asm_id = apr.asm_id
          and apr.p_opr_id = p_opr_id;

    -- ???????? ???????????????? ?????????????? ???? ????????????, ???? ???????????? ??????????????, ?????????????? ???????? ???? ???????????? ??????????????.
    if (asm > 0) then
      out_count = out_count + asm;
  END IF;


    SELECT coalesce(sum(asm.asm_count), 0)
      INTO disasm
      from dcl_assemble asm
    where asm.asm_type = 1 -- ??????????????????
          and asm.p_opr_id = p_opr_id;

    -- ???????? ??????????????????, ???? ??????????????, ?????? ?????? ?????????????? ??????????????????. ???????? ??????.
    if (disasm > 0) then
      out_count = out_count + disasm;
  END IF;

    RETURN NEXT;
END
$$;


--
-- Name: dcl_get_count_rest_drp(integer, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_count_rest_drp(p_dlr_id integer, p_dlr_need_deliver smallint) RETURNS TABLE(count_rest_drp numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_count_lpc DECIMAL(15,2);
  v_count_sip DECIMAL(15,2);
  v_count_empty_manager INTEGER;
  v_count_empty_date INTEGER;
  v_count_drp INTEGER;
BEGIN
  v_count_drp := 0;
  SELECT count(drp_id) INTO v_count_drp
  FROM dcl_dlr_list_produce drp WHERE drp.dlr_id = p_dlr_id;

  IF v_count_drp = 0 THEN
    count_rest_drp := 1;
    RETURN NEXT;
  ELSE
    count_rest_drp := 0;
    IF p_dlr_need_deliver IS NULL THEN
      v_count_lpc := 0;
      v_count_sip := 0;

      SELECT coalesce(sum(drp_count), 0) INTO count_rest_drp
      FROM dcl_dlr_list_produce drp WHERE drp.dlr_id = p_dlr_id;

      SELECT coalesce(sum(lpc_count), 0) INTO v_count_lpc
      FROM dcl_dlr_list_produce drp
      JOIN dcl_prc_list_produce lpc ON lpc.drp_id = drp.drp_id
      WHERE drp.dlr_id = p_dlr_id;

      SELECT coalesce(sum(sip_count), 0) INTO v_count_sip
      FROM dcl_dlr_list_produce drp
      JOIN dcl_spi_list_produce sip ON sip.drp_id = drp.drp_id
      WHERE drp.dlr_id = p_dlr_id;

      count_rest_drp := count_rest_drp - v_count_lpc - v_count_sip;
      RETURN NEXT;
    ELSE
      SELECT count(drp_id) INTO v_count_empty_manager
      FROM dcl_dlr_list_produce drp
      WHERE drp.dlr_id = p_dlr_id AND drp.receive_manager_id IS NULL;

      SELECT count(drp_id) INTO v_count_empty_date
      FROM dcl_dlr_list_produce drp
      WHERE drp.dlr_id = p_dlr_id AND drp.receive_date IS NULL;

      IF v_count_empty_manager != 0 OR v_count_empty_date != 0 THEN
        count_rest_drp := 1;
      END IF;
      RETURN NEXT;
    END IF;
  END IF;
END;
$$;


--
-- Name: dcl_get_crq_deliver(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_crq_deliver(p_crq_id integer) RETURNS TABLE(crq_deliver smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  count_not_deliver integer;
BEGIN
  crq_deliver = null;
  select count(crp_id) from dcl_crq_print where p_crq_id = p_crq_id and crp_deliver is null into count_not_deliver;
  if ( count_not_deliver = 0 ) then
    crq_deliver = 1;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_ctn_num_list_by_prd_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_ctn_num_list_by_prd_id(p_prd_id integer) RETURNS TABLE(product_list character varying, ctn_number_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_stf_name VARCHAR(150);
  v_ctn_number VARCHAR(50);
BEGIN
  product_list := '';
  ctn_number_list := '';
  FOR v_stf_name, v_ctn_number IN
    SELECT stf.stf_name, ctn.ctn_number
    FROM dcl_stuff_category stf, dcl_catalog_number ctn
    WHERE stf.stf_id = ctn.stf_id AND ctn.prd_id = p_prd_id
    ORDER BY 1
  LOOP
    product_list := product_list || v_stf_name || '<br>';
    ctn_number_list := ctn_number_list || v_ctn_number || '<br>';
  END LOOP;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_get_customer_for_dlr(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_customer_for_dlr(p_dlr_id integer) RETURNS TABLE(ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT drp.ctr_id, drp.asm_id
    FROM dcl_dlr_list_produce drp
    WHERE drp.dlr_id = p_dlr_id
  LOOP
    IF rec.ctr_id IS NOT NULL THEN
      SELECT ctr.ctr_name INTO ctr_name
      FROM dcl_contractor ctr WHERE ctr.ctr_id = rec.ctr_id;
      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_get_decode_rests_in_lit(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_decode_rests_in_lit(p_prd_id integer, p_stf_id integer) RETURNS TABLE(quantity numeric, date_created timestamp without time zone, contractor_name character varying, specification_number character varying, contract_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  ord_date date;
  trn_date date;
  _rec RECORD;
BEGIN
    date_created := null;
    contractor_name := null;
    specification_number := null;
    contract_number := null;

  FOR _rec IN select coalesce(prc.ord_produce_cnt_rest, 0) + coalesce(prc.trn_produce_cnt_rest, 0), prc.ord_date, prc.trn_date, prc.opr_id from dcl_movement_load(p_prd_id, p_stf_id, 1, null) prc where coalesce(prc.ord_produce_cnt_rest, 0) + coalesce(prc.trn_produce_cnt_rest, 0) > 0 and (prc.ord_date is not null or prc.trn_date is not null)
  LOOP
    quantity := _rec.ord_date;
    ord_date := _rec.trn_date;
    trn_date := _rec.opr_id;
    opr_id := _rec.opr_id;
        if (ord_date is not null) then
          date_created := ord_date;
  ELSE
          date_created := trn_date;
  END IF;

        SELECT contractor_name, specification_number, contract_number
          INTO contractor_name, specification_number, contract_number
          from dcl_get_rest_info_from_order(opr_id);

        RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_decode_rests_in_minsk(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_decode_rests_in_minsk(p_prd_id integer, p_stf_id integer) RETURNS TABLE(quantity numeric, date_created timestamp without time zone, contractor_name character varying, specification_number character varying, contract_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  _rec RECORD;
BEGIN
    date_created = null;
    contractor_name = null;
    specification_number = null;
    contract_number = null;

  FOR _rec IN select prc.prc_produce_cnt_rest, prc.prc_date, prc.opr_id from dcl_movement_load(p_prd_id, p_stf_id, 1, null) prc where prc.prc_produce_cnt_rest > 0 and prc.prc_date is not null
  LOOP
    quantity := _rec.quantity;
    date_created := _rec.date_created;
    opr_id := _rec.opr_id;
        select contractor_name, specification_number, contract_number
        from dcl_get_rest_info_from_order(opr_id)
        into contractor_name, specification_number, contract_number;

        RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_double_contractor(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_double_contractor(p_ctr_id integer, p_pay_account character varying) RETURNS TABLE(contractors character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  contractor VARCHAR(200);
BEGIN
  contractors = '';

  FOR contractor IN select distinct ctr.ctr_name from dcl_contractor ctr, dcl_account acc where  ctr.p_ctr_id != p_ctr_id and ctr.ctr_double_account is not null and acc.p_ctr_id = ctr.p_ctr_id and acc.acc_account = p_pay_account
  LOOP
    contractors = contractors || contractor || ', ';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_double_produces(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_double_produces(p_stf_id integer) RETURNS TABLE(double_str character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN

  double_str = 'Double Catalog Numbers';
  RETURN NEXT;

  FOR double_str IN select distinct ctn1.ctn_number from dcl_catalog_number ctn1, dcl_catalog_number ctn2 where ctn1.ctn_id != ctn2.ctn_id and ctn1.prd_id != ctn2.prd_id and ctn1.ctn_number = ctn2.ctn_number and ctn1.ctn_number != '' and ( select prd_id from dcl_produce prd where prd.prd_id = ctn1.prd_id and prd.prd_not_check_double is null ) is not null and ( p_stf_id = -1 or ctn1.p_stf_id = p_stf_id )
  LOOP
    RETURN NEXT;
  END LOOP;

  if (p_stf_id = -1) then

    double_str = 'Double Types';
    RETURN NEXT;

  FOR double_str IN select distinct prd1.prd_type from dcl_produce prd1, dcl_produce prd2 where prd1.prd_id != prd2.prd_id and prd1.prd_type = prd2.prd_type and prd1.prd_type != '' and prd1.prd_not_check_double is null
  LOOP
      RETURN NEXT;
  END LOOP;

    double_str = 'Double Parameters';
    RETURN NEXT;

  FOR double_str IN select distinct prd1.prd_params from dcl_produce prd1, dcl_produce prd2 where prd1.prd_id != prd2.prd_id and prd1.prd_params = prd2.prd_params and prd1.prd_params != '' and prd1.prd_not_check_double is null
  LOOP
      RETURN NEXT;
  END LOOP;

    double_str = 'Double Additional Parameters';
    RETURN NEXT;

  FOR double_str IN select distinct prd1.prd_add_params from dcl_produce prd1, dcl_produce prd2 where prd1.prd_id != prd2.prd_id and prd1.prd_add_params = prd2.prd_add_params and prd1.prd_add_params != '' and prd1.prd_not_check_double is null
  LOOP
      RETURN NEXT;
  END LOOP;

  END IF;
END
$$;


--
-- Name: dcl_get_manager_list_by_shp_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_manager_list_by_shp_id(p_shp_id integer) RETURNS TABLE(manager_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  usr_name varchar(50);
BEGIN
  manager_list = '';
  FOR usr_name IN select manager from dcl_get_managers_by_shp_id(p_shp_id) order by 1
  LOOP
    manager_list = manager_list || usr_name || '<br>';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_managers_by_shp_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_managers_by_shp_id(p_shp_id integer) RETURNS TABLE(manager character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  FOR manager IN select distinct (usr_surname || ' ' || usr_name) from dcl_user_language usr_lng, dcl_shp_list_produce lps, dcl_lps_list_manager lmn where lps.p_shp_id = p_shp_id and lmn.lps_id = lps.lps_id and usr_lng.usr_id = lmn.usr_id and usr_lng.lng_id = 1
  LOOP
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_num(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_num(p_t character varying) RETURNS TABLE(num integer)
    LANGUAGE plpgsql
    AS $_$
DECLARE
  d DATE;
  y INTEGER;
BEGIN
  SELECT CAST('NOW' AS TIMESTAMP) FROM RDB$DATABASE INTO d;
  Y = EXTRACT(YEAR FROM D);

  select dcl_num from dcl_year_num where dcl_year=y and dcl_table=p_t into num;
  if ( num is NULL ) then
    num = 1;
    insert into dcl_year_num (dcl_year,  dcl_num, dcl_table) values (y, num, p_t);
  else
    num = num + 1;
    update dcl_year_num set dcl_num = num where dcl_year=y and dcl_table=p_t;
  END IF;

  RETURN NEXT;
END
$_$;


--
-- Name: dcl_get_occupied_shp_pos(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_occupied_shp_pos(p_position_ids character varying) RETURNS TABLE(occupied_ids character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lps_id integer;
  crq_count integer;
BEGIN
  occupied_ids = '';

  FOR lps_id IN select int_id from dcl_decode_id_list(p_position_ids)
  LOOP
    select count(crq_id) from dcl_contractor_request crq where lps_id = lps_id into crq_count;
    if ( crq_count > 0 ) then
      occupied_ids = occupied_ids || lps_id || ', ';
  END IF;
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_opr_id_by_lpc(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_opr_id_by_lpc(p_asm_id_in integer, p_apr_id_in integer, p_drp_id_in integer, p_sip_id_in integer) RETURNS TABLE(opr_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  drp_id integer;
  asm_id integer;
  apr_id integer;
BEGIN
  opr_id = null;

  if (p_sip_id_in is not null) then
    select opr_id, drp_id from dcl_spi_list_produce sip where sip.sip_id = p_sip_id_in into opr_id, drp_id;
  END IF;

  if (p_drp_id_in is not null) then
    drp_id = p_drp_id_in;
  END IF;

  if (drp_id is not null) then
    select opr_id, asm_id, apr_id from dcl_dlr_list_produce drp where drp.drp_id = drp_id into opr_id, asm_id, apr_id;
  END IF;

  if (p_asm_id_in is not null) then
    asm_id = p_asm_id_in;
  END IF;

  if (asm_id is not null) then
    select opr_id from dcl_assemble asm where asm.asm_id = asm_id into opr_id;
  END IF;

  if (p_apr_id_in is not null) then
    apr_id = p_apr_id_in;
  END IF;

  if (apr_id is not null) then
    select opr_id from dcl_asm_list_produce apr where apr.apr_id = apr_id into opr_id;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_opr_id_from_asm(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_opr_id_from_asm(p_apr_id integer) RETURNS TABLE(opr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  SELECT apr.opr_id INTO opr_id FROM dcl_asm_list_produce apr WHERE apr.apr_id = p_apr_id;
  RETURN NEXT;
END $$;


--
-- Name: dcl_get_ord_cust_info_for_asm(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_ord_cust_info_for_asm(p_asm_id integer) RETURNS TABLE(ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ord_id integer;
  opr_id integer;
  _rec RECORD;
BEGIN
  FOR _rec IN select distinct apr.opr_id from dcl_asm_list_produce apr where apr.p_asm_id = p_asm_id
  LOOP
    opr_id := _rec.opr_id;
    select ord_id from dcl_ord_list_produce opr where opr.opr_id = opr_id into ord_id;

  FOR _rec IN select ctr_name from dcl_get_contractors_for_for_ord(ord_id)
  LOOP
    ctr_name := _rec.ctr_name;
      RETURN NEXT;
  END LOOP;
  END LOOP;
END
$$;


--
-- Name: dcl_get_ord_id_by_lpc(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_ord_id_by_lpc(p_opr_id_in integer, p_asm_id_in integer, p_apr_id_in integer, p_drp_id_in integer, p_sip_id_in integer) RETURNS TABLE(ord_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  drp_id integer;
  asm_id integer;
  apr_id integer;
BEGIN
  ord_id = null;
  opr_id = null;

  if (p_sip_id_in is not null) then
    select opr_id, drp_id from dcl_spi_list_produce sip where sip.sip_id = p_sip_id_in into opr_id, drp_id;
  END IF;

  if (p_drp_id_in is not null) then
    drp_id = p_drp_id_in;
  END IF;

  if (drp_id is not null) then
    select opr_id, asm_id, apr_id from dcl_dlr_list_produce drp where drp.drp_id = drp_id into opr_id, asm_id, apr_id;
  END IF;

  if (p_asm_id_in is not null) then
    asm_id = p_asm_id_in;
  END IF;

  if (asm_id is not null) then
    select opr_id from dcl_assemble asm where asm.asm_id = asm_id into opr_id;
  END IF;

  if (p_apr_id_in is not null) then
    apr_id = p_apr_id_in;
  END IF;

  if (apr_id is not null) then
    select opr_id from dcl_asm_list_produce apr where apr.apr_id = apr_id into opr_id;
  END IF;

  if (p_opr_id_in is not null) then
    opr_id = p_opr_id_in;
  END IF;

  if (opr_id is not null) then
    select ord_id from dcl_ord_list_produce opr where opr.opr_id = opr_id into ord_id;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_ord_info_for_asm(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_ord_info_for_asm(p_asm_id integer) RETURNS TABLE(ord_id integer, ord_number character varying, ord_date date, ord_date_str character varying, contractors_for character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
BEGIN
  FOR opr_id IN select distinct apr.opr_id from dcl_asm_list_produce apr where apr.p_asm_id = p_asm_id
  LOOP
    select ord.ord_id,
           ord.ord_number,
           ord.ord_date
    from dcl_ord_list_produce opr,
         dcl_order ord
    where opr.opr_id = opr_id and
          ord.ord_id = opr.ord_id
    into   ord_id,
           ord_number,
           ord_date
    ;

    ord_date_str = '';
    select strdate from date2str(ord_date) into ord_date_str;
    select contractors from dcl_get_contractor_for_for_ord(ord_id, '<br>') into contractors_for;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_ord_num_date_for_dlr(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_ord_num_date_for_dlr(p_dlr_id integer) RETURNS TABLE(ord_num_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN
    SELECT drp.opr_id, drp.apr_id, drp.asm_id
    FROM dcl_dlr_list_produce drp
    WHERE drp.dlr_id = p_dlr_id
  LOOP
    IF rec.opr_id IS NOT NULL THEN
      SELECT (ord.ord_number || ' от ' || to_char(ord.ord_date, 'DD.MM.YYYY'))::VARCHAR(40)
      INTO ord_num_date
      FROM dcl_order ord
      JOIN dcl_ord_list_produce opr ON ord.ord_id = opr.ord_id
      WHERE opr.opr_id = rec.opr_id;
      IF FOUND THEN RETURN NEXT; END IF;
    ELSIF rec.apr_id IS NOT NULL THEN
      SELECT (ord.ord_number || ' от ' || to_char(ord.ord_date, 'DD.MM.YYYY'))::VARCHAR(40)
      INTO ord_num_date
      FROM dcl_order ord
      JOIN dcl_ord_list_produce opr ON ord.ord_id = opr.ord_id
      WHERE opr.opr_id = rec.apr_id;
      IF FOUND THEN RETURN NEXT; END IF;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_get_payed_date(integer, numeric, smallint, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_payed_date(p_spc_id integer, p_spc_summ numeric, p_spc_percent_or_sum smallint, p_spc_delivery_percent numeric, p_spc_delivery_sum numeric) RETURNS TABLE(payed_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lps_summ decimal(15,2);
  pay_date date;
  check_sum decimal(15,2);
  calculated decimal(15,2);
  _rec RECORD;
BEGIN
  payed_date := null;
  if ( p_spc_percent_or_sum is not null ) then
    check_sum := 0;
  FOR _rec IN select lps_summ, pay_date from dcl_pay_list_summ psum, dcl_payment pay where psum.p_spc_id = p_spc_id and pay.pay_id = psum.pay_id order by pay_date
  LOOP
    lps_summ := _rec.lps_summ;
    pay_date := _rec.pay_date;
      check_sum := check_sum + lps_summ;

      if ( 0 = p_spc_percent_or_sum and p_spc_summ != 0 ) then
        calculated := (check_sum / p_spc_summ * 100);
        if ( calculated + 0.5 >= p_spc_delivery_percent ) then
          payed_date := pay_date;
          EXIT;
  END IF;
  END IF;

      if ( 1 = p_spc_percent_or_sum ) then
        if ( check_sum >= p_spc_delivery_sum ) then
          payed_date := pay_date;
          EXIT;
  END IF;
  END IF;
  END LOOP;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_prc_list_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_prc_list_for_ord(p_ord_id integer) RETURNS TABLE(cost_produces character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_num_date varchar(80);
BEGIN
  cost_produces = '';

  FOR prc_num_date IN select distinct(prc_num_date) from dcl_get_prc_num_date_for_ord(p_ord_id)
  LOOP
    cost_produces = cost_produces || prc_num_date || ', ';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_prc_num_date_for_drp(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_prc_num_date_for_drp(p_drp_id integer) RETURNS TABLE(prc_num_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_date date;
  prc_number varchar(50);
  _rec RECORD;
BEGIN
  FOR _rec IN select prc_date, prc_number from dcl_produce_cost prc, dcl_prc_list_produce lpc where   lpc.prc_id = prc.prc_id and lpc.p_drp_id = p_drp_id
  LOOP
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
    prc_num_date = '';
    select strdate from date2str(prc_date) into prc_num_date;
    prc_num_date = prc_number || 'from' || prc_num_date;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_prc_num_date_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_prc_num_date_for_ord(p_ord_id integer) RETURNS TABLE(prc_num_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_date date;
  prc_number varchar(50);
  opr_id integer;
  drp_id integer;
  apr_id integer;
  asm_id integer;
  sip_id integer;
  _rec RECORD;
BEGIN
  FOR _rec IN select opr_id from dcl_ord_list_produce where p_ord_id = p_ord_id
  LOOP
    opr_id := _rec.opr_id;
  FOR _rec IN select prc_date, prc_number from dcl_produce_cost prc, dcl_prc_list_produce lpc where   lpc.prc_id = prc.prc_id and lpc.opr_id = opr_id
  LOOP
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
      prc_num_date := '';
      select strdate from date2str(prc_date) into prc_num_date;
      prc_num_date := prc_number || 'from' || prc_num_date;

      RETURN NEXT;
  END LOOP;

  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.opr_id = opr_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select prc_num_date from dcl_get_prc_num_date_for_drp(drp_id)
  LOOP
    prc_num_date := _rec.prc_num_date;
        RETURN NEXT;
  END LOOP;

  FOR _rec IN select sip_id from dcl_spi_list_produce sip where sip.drp_id = drp_id
  LOOP
    sip_id := _rec.sip_id;
  FOR _rec IN select prc_num_date from dcl_get_prc_num_date_for_sip(sip_id)
  LOOP
    prc_num_date := _rec.prc_num_date;
          RETURN NEXT;
  END LOOP;
  END LOOP;
  END LOOP;

  FOR _rec IN select apr_id from dcl_asm_list_produce apr where apr.opr_id = opr_id
  LOOP
    apr_id := _rec.apr_id;
  FOR _rec IN select prc_date, prc_number from dcl_produce_cost prc, dcl_prc_list_produce lpc where   lpc.prc_id = prc.prc_id and lpc.apr_id = apr_id
  LOOP
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
        prc_num_date := '';
        select strdate from date2str(prc_date) into prc_num_date;
        prc_num_date := prc_number || 'from' || prc_num_date;

        RETURN NEXT;
  END LOOP;

  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.apr_id = apr_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select prc_num_date from dcl_get_prc_num_date_for_drp(drp_id)
  LOOP
    prc_num_date := _rec.prc_num_date;
          RETURN NEXT;
  END LOOP;
  END LOOP;
  END LOOP;

  FOR _rec IN select asm_id from dcl_assemble asm where asm.opr_id = opr_id
  LOOP
    asm_id := _rec.asm_id;
  FOR _rec IN select prc_date, prc_number from dcl_produce_cost prc, dcl_prc_list_produce lpc where   lpc.prc_id = prc.prc_id and lpc.asm_id = asm_id
  LOOP
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
        prc_num_date := '';
        select strdate from date2str(prc_date) into prc_num_date;
        prc_num_date := prc_number || 'from' || prc_num_date;

        RETURN NEXT;
  END LOOP;

  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.apr_id = asm_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select prc_num_date from dcl_get_prc_num_date_for_drp(drp_id)
  LOOP
    prc_num_date := _rec.prc_num_date;
          RETURN NEXT;
  END LOOP;
  END LOOP;
  END LOOP;

  FOR _rec IN select sip_id from dcl_spi_list_produce sip where sip.opr_id = opr_id
  LOOP
    sip_id := _rec.sip_id;
  FOR _rec IN select prc_num_date from dcl_get_prc_num_date_for_sip(sip_id)
  LOOP
    prc_num_date := _rec.prc_num_date;
        RETURN NEXT;
  END LOOP;
  END LOOP;

  END LOOP;
END
$$;


--
-- Name: dcl_get_prc_num_date_for_sip(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_prc_num_date_for_sip(p_sip_id integer) RETURNS TABLE(prc_num_date character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_date date;
  prc_number varchar(50);
  _rec RECORD;
BEGIN
  FOR _rec IN select prc_date, prc_number from dcl_produce_cost prc, dcl_prc_list_produce lpc where   lpc.prc_id = prc.prc_id and lpc.p_sip_id = p_sip_id
  LOOP
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
    prc_num_date = '';
    select strdate from date2str(prc_date) into prc_num_date;
    prc_num_date = prc_number || 'from' || prc_num_date;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_produces_for_cat(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_produces_for_cat(p_cat_id_in character varying, p_prd_name_in character varying, p_prd_type_in character varying, p_prd_params_in character varying, p_prd_add_params_in character varying, p_stf_id_in character varying, p_cus_code_in character varying, p_ctn_number_in character varying, p_not_blocked character varying, p_prd_common_in character varying) RETURNS TABLE(prd_id integer, prd_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, unt_id integer, cus_code character varying, prd_block smallint, product_list character varying, ctn_number_list character varying, prd_not_check_double smallint, prd_user character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_prd_common VARCHAR(5000);
  v_prd_name_order VARCHAR(1000);
  v_cat_id INTEGER;
  v_stf_id INTEGER;
  v_not_blocked SMALLINT;
  v_prd_name_in VARCHAR;
  v_prd_type_in VARCHAR;
  v_prd_params_in VARCHAR;
  v_prd_add_params_in VARCHAR;
  v_cus_code_in VARCHAR;
  v_ctn_number_in VARCHAR;
  v_prd_common_in VARCHAR;
  rec RECORD;
  ctn_rec RECORD;
BEGIN
  v_cat_id := CASE WHEN p_cat_id_in IS NOT NULL AND p_cat_id_in != '' THEN p_cat_id_in::INTEGER ELSE NULL END;
  v_stf_id := CASE WHEN p_stf_id_in IS NOT NULL AND p_stf_id_in != '' THEN p_stf_id_in::INTEGER ELSE NULL END;
  v_not_blocked := CASE WHEN p_not_blocked IS NOT NULL AND p_not_blocked != '' THEN p_not_blocked::SMALLINT ELSE NULL END;
  v_prd_name_in := upper(p_prd_name_in);
  v_prd_type_in := upper(p_prd_type_in);
  v_prd_params_in := upper(p_prd_params_in);
  v_prd_add_params_in := upper(p_prd_add_params_in);
  v_cus_code_in := upper(p_cus_code_in);
  v_ctn_number_in := upper(p_ctn_number_in);
  v_prd_common_in := upper(p_prd_common_in);

  FOR rec IN
    SELECT p.prd_id, p.prd_name, upper(p.prd_name) AS prd_name_order,
           p.prd_type, p.prd_params, p.prd_add_params, p.unt_id, p.cus_code,
           p.prd_block, p.prd_not_check_double,
           (SELECT ul.usr_surname || ' ' || ul.usr_name FROM dcl_user_language ul WHERE ul.usr_id = p.usr_id_create AND ul.lng_id = 1) AS user_name
    FROM dcl_produce p
    WHERE p.cat_id = v_cat_id
      AND (v_not_blocked IS NULL OR (v_not_blocked IS NOT NULL AND p.prd_block IS NULL))
      AND (v_stf_id IS NULL OR ((SELECT count(ctn.ctn_id) FROM dcl_catalog_number ctn WHERE ctn.prd_id = p.prd_id AND ctn.stf_id = v_stf_id) = 1))
      AND (v_prd_name_in IS NULL OR v_prd_name_in = '' OR upper(p.prd_name) LIKE '%' || v_prd_name_in || '%')
      AND (v_prd_type_in IS NULL OR v_prd_type_in = '' OR upper(p.prd_type) LIKE '%' || v_prd_type_in || '%')
      AND (v_prd_params_in IS NULL OR v_prd_params_in = '' OR upper(p.prd_params) LIKE '%' || v_prd_params_in || '%')
      AND (v_prd_add_params_in IS NULL OR v_prd_add_params_in = '' OR upper(p.prd_add_params) LIKE '%' || v_prd_add_params_in || '%')
      AND (v_cus_code_in IS NULL OR v_cus_code_in = '' OR upper(p.cus_code) LIKE '%' || v_cus_code_in || '%')
      AND (v_ctn_number_in IS NULL OR v_ctn_number_in = '' OR ((SELECT count(ctn.ctn_id) FROM dcl_catalog_number ctn WHERE ctn.prd_id = p.prd_id AND upper(ctn.ctn_number) LIKE '%' || v_ctn_number_in || '%') >= 1))
    ORDER BY upper(p.prd_name), p.prd_type, p.prd_params, p.prd_add_params
  LOOP
    prd_id := rec.prd_id;
    prd_name := rec.prd_name;
    prd_type := rec.prd_type;
    prd_params := rec.prd_params;
    prd_add_params := rec.prd_add_params;
    unt_id := rec.unt_id;
    cus_code := rec.cus_code;
    prd_block := rec.prd_block;
    prd_not_check_double := rec.prd_not_check_double;
    prd_user := rec.user_name;

    SELECT g.product_list, g.ctn_number_list INTO product_list, ctn_number_list
    FROM dcl_get_ctn_num_list_by_prd_id(rec.prd_id) g;

    v_prd_common := upper(COALESCE(rec.prd_name,'') || ' ' || COALESCE(rec.prd_type,'') || ' ' || COALESCE(rec.prd_params,'') || ' ' || COALESCE(rec.prd_add_params,'') || ' ' || COALESCE(rec.cus_code,'') || ' ' || COALESCE(ctn_number_list,''));
    IF v_prd_common_in IS NULL OR v_prd_common_in = '' OR v_prd_common LIKE '%' || v_prd_common_in || '%' THEN
      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_get_product_list_by_shp_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_product_list_by_shp_id(p_shp_id integer) RETURNS TABLE(product_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  stf_name VARCHAR(150);
BEGIN
  product_list = '';
  FOR stf_name IN select distinct stf_name from dcl_stuff_category stf, dcl_shp_list_produce lps where stf.stf_id = lps.stf_id and lps.p_shp_id = p_shp_id order by 1
  LOOP
    product_list = product_list || stf_name || '<br>';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_reserved_count_for_cpr(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_reserved_count_for_cpr(p_cpr_id integer, p_lpc_id integer) RETURNS TABLE(reserved numeric)
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _rec RECORD;
BEGIN
  reserved = 0;

  if ( p_lpc_id is not null ) then

    SELECT coalesce (sum(lpr_count), 0)
      INTO reserved
      from
    (
      select ( lpr_count - ( select coalesce (sum(lps.lps_count), 0) from dcl_shp_list_produce lps where lps.lpr_id = lpr.lpr_id ) ) as lpr_count
      from  dcl_cpr_list_produce lpr
      where lpr.p_lpc_id = p_lpc_id and
            (
              select count(p_cpr_id)
              from dcl_commercial_proposal cpr
              where cpr.p_cpr_id = lpr.p_cpr_id and
                    cpr.p_cpr_id != p_cpr_id and
                    cpr.cpr_assemble_minsk_store is not null and
                    (
                      cpr.cpr_no_reservation is null and
                      (
                        cpr.cpr_final_date >= (SELECT CAST('NOW' AS DATE) FROM RDB$DATABASE)
                        or
                        cpr.cpr_proposal_received_flag=1
                      )
                    )
            ) > 0
    );

  END IF;

  RETURN NEXT;
END
$_$;


--
-- Name: dcl_get_reserved_info(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_reserved_info(p_lpc_id integer) RETURNS TABLE(cpr_id integer, cpr_number character varying, con_number character varying, ctr_name character varying, cpr_count numeric, shp_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
  _rec2 RECORD;
  v_shp_sum DECIMAL(15,2);
BEGIN
  FOR _rec IN SELECT DISTINCT lpr.cpr_id
    FROM dcl_cpr_list_produce lpr
    WHERE lpr.lpc_id = p_lpc_id
      AND (lpr.lpr_count - COALESCE((SELECT SUM(lps.lps_count) FROM dcl_shp_list_produce lps WHERE lps.lpr_id = lpr.lpr_id), 0)) > 0
      AND lpr.cpr_id = (SELECT cpr.cpr_id FROM dcl_commercial_proposal cpr
        WHERE cpr.cpr_id = lpr.cpr_id
          AND cpr.cpr_assemble_minsk_store IS NOT NULL
          AND cpr.cpr_no_reservation IS NULL
          AND (cpr.cpr_final_date >= CURRENT_DATE OR cpr.cpr_proposal_received_flag = 1))
  LOOP
    cpr_id := _rec.cpr_id;
    SELECT cp.cpr_number INTO cpr_number FROM dcl_commercial_proposal cp WHERE cp.cpr_id = _rec.cpr_id;
    SELECT c.con_number INTO con_number FROM dcl_contract c
      JOIN dcl_con_list_spec spc ON c.con_id = spc.con_id
      JOIN dcl_commercial_proposal cp ON cp.spc_id = spc.spc_id
      WHERE cp.cpr_id = _rec.cpr_id;
    SELECT ct.ctr_name INTO ctr_name FROM dcl_contractor ct
      JOIN dcl_contract c ON c.ctr_id = ct.ctr_id
      JOIN dcl_con_list_spec spc ON c.con_id = spc.con_id
      JOIN dcl_commercial_proposal cp ON cp.spc_id = spc.spc_id
      WHERE cp.cpr_id = _rec.cpr_id;
    
    cpr_count := 0; shp_count := 0;
    FOR _rec2 IN SELECT lpr.lpr_id, lpr.lpr_count FROM dcl_cpr_list_produce lpr
      WHERE lpr.cpr_id = _rec.cpr_id AND lpr.lpc_id = p_lpc_id
    LOOP
      cpr_count := cpr_count + COALESCE(_rec2.lpr_count, 0);
      SELECT COALESCE(SUM(lps.lps_count), 0) INTO v_shp_sum
        FROM dcl_shp_list_produce lps WHERE lps.lpr_id = _rec2.lpr_id;
      shp_count := shp_count + v_shp_sum;
    END LOOP;
    
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_get_rest_asm_for_dlr(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_asm_for_dlr(p_dlr_id integer) RETURNS TABLE(apr_id integer, asm_id integer, asm_number character varying, asm_date date, prd_id integer, apr_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_type integer;
  asm_count decimal(15,2);
  drp_count decimal(15,2);
  lpc_count decimal(15,2);
  opr_id integer;
  _rec RECORD;
BEGIN
  if ( p_dlr_id is null ) then
    p_dlr_id = -1; -- __'__??'____??_??___??_??__ ___??'"___>''__'<_?? ID, ''.__ ___>'_ null __'__??____ ___??'__??'''_ __'_'______?? sql
  END IF;


  FOR _rec IN select asm_id, asm_number, asm_date, asm_type, asm_count, prd_id, opr_id from dcl_assemble asm
  LOOP
    asm_id := _rec.asm_id;
    asm_number := _rec.asm_number;
    asm_date := _rec.asm_date;
    asm_type := _rec.asm_type;
    asm_count := _rec.asm_count;
    prd_id := _rec.prd_id;
    opr_id := _rec.opr_id;
    apr_id := null;
    if ( asm_type = 0 ) then
      apr_count := asm_count;

      SELECT coalesce(sum(drp.drp_count), 0)
        INTO lpc_count
        from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.asm_id = asm_id and dlr.p_dlr_id = drp.p_dlr_id and drp.p_dlr_id != p_dlr_id and dlr.dlr_annul is null;
select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.asm_id = asm_id;

      apr_count := apr_count - drp_count - lpc_count;

      if ( apr_count > 0 ) then
        RETURN NEXT;
  END IF;
  END IF;

    if ( asm_type = 1 ) then
  FOR _rec IN select apr_id, apr.prd_id, ( (apr_count * asm_count) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.p_dlr_id = drp.p_dlr_id and drp.p_dlr_id != p_dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id ) ) as apr_count from dcl_asm_list_produce apr where apr.asm_id = asm_id and ( ( (apr_count * asm_count) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.p_dlr_id = drp.p_dlr_id and drp.p_dlr_id != p_dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id ) ) > 0 )
  LOOP
    apr_id := _rec.apr_id;
    prd_id := _rec.prd_id;
    apr_count := _rec.apr_count;
        RETURN NEXT;
  END LOOP;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_asm_for_prc(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_asm_for_prc(p_prc_id integer) RETURNS TABLE(apr_id integer, asm_id integer, asm_number character varying, asm_date date, prd_id integer, apr_count numeric, ctn_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_type integer;
  asm_count decimal(15,2);
  drp_count decimal(15,2);
  lpc_count decimal(15,2);
  opr_id integer;
  _rec RECORD;
BEGIN
  if ( p_prc_id is null ) then
    p_prc_id = -1;
  END IF;


  FOR _rec IN select asm_id, asm_number, asm_date, asm_type, asm_count, prd_id, opr_id, (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = asm.prd_id and ctn.stf_id = asm.stf_id) from dcl_assemble asm
  LOOP
    asm_id := _rec.asm_id;
    asm_number := _rec.asm_number;
    asm_date := _rec.asm_date;
    asm_type := _rec.asm_type;
    asm_count := _rec.asm_count;
    prd_id := _rec.prd_id;
    opr_id := _rec.opr_id;
    ctn_number := _rec.ctn_number;
    apr_id := null;
    if ( asm_type = 0 ) then
      apr_count := asm_count;

      SELECT coalesce(sum(lpc.lpc_count), 0)
        INTO drp_count
        from dcl_prc_list_produce lpc where lpc.asm_id = asm_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) );
select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.asm_id = asm_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null;

      apr_count := apr_count - drp_count - lpc_count;

      if ( apr_count > 0 ) then
        RETURN NEXT;
  END IF;
  END IF;

    if ( asm_type = 1 ) then
  FOR _rec IN select apr_id, apr.prd_id, ( (apr_count * asm_count) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) ) as apr_count, (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = apr.prd_id and ctn.stf_id = asm.stf_id) from  dcl_assemble asm, dcl_asm_list_produce apr where asm.asm_id = asm_id and apr.asm_id = asm.asm_id and ( ( (apr_count * asm_count) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) ) > 0 )
  LOOP
    apr_id := _rec.apr_id;
    prd_id := _rec.prd_id;
    apr_count := _rec.apr_count;
    ctn_number := _rec.ctn_number;
        RETURN NEXT;
  END LOOP;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_drp_for_prc(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_drp_for_prc(p_prc_id integer) RETURNS TABLE(drp_id integer, dlr_id integer, dlr_number character varying, dlr_date date, prd_id integer, drp_count numeric, ctn_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_prc_id is null ) then
    p_prc_id = -1;
  END IF;

  FOR _rec IN select drp_id, dlr.dlr_id as dlr_id, dlr_number, dlr_date, prd_id, ( drp_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.drp_id = drp.drp_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) ) as drp_count, (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = drp.prd_id and ctn.stf_id = drp.stf_id) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where dlr.dlr_id = drp.dlr_id and dlr.dlr_fair_trade is not null and dlr.dlr_minsk = 0 and dlr.dlr_include_in_spec is null and dlr.dlr_place_request is not null and dlr.dlr_annul is null and dlr.dlr_need_deliver is null and drp.prd_id is not null and ( ( drp_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.drp_id = drp.drp_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) ) > 0 )
  LOOP
    drp_id := _rec.drp_id;
    dlr_id := _rec.dlr_id;
    dlr_number := _rec.dlr_number;
    dlr_date := _rec.dlr_date;
    prd_id := _rec.prd_id;
    drp_count := _rec.drp_count;
    ctn_number := _rec.ctn_number;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_drp_for_spi(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_drp_for_spi(p_spi_id integer) RETURNS TABLE(drp_id integer, dlr_id integer, dlr_number character varying, dlr_date date, prd_id integer, drp_count numeric, guarantee smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_spi_id is null ) then
    p_spi_id = -1; -- _???'__???'____???_???___???___ ___'"___>''__'<_??? ID, ''._??? ___>'_ null __'______ _???_???'__???'''_ __'_'______??? sql
  END IF;

  FOR _rec IN select drp_id, dlr.dlr_id as dlr_id, dlr_number, dlr_date, prd_id, (drp_count - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.drp_id = drp.drp_id and sip.p_spi_id != p_spi_id )), dlr.dlr_guarantee_repair from dcl_dlr_list_produce drp, dcl_delivery_request dlr where dlr.dlr_id = drp.dlr_id and ( ( dlr.dlr_fair_trade is null ) or ( dlr.dlr_fair_trade is not null and dlr.dlr_minsk = 0 and dlr.dlr_include_in_spec is not null ) ) and dlr.dlr_place_request is not null and dlr.dlr_annul is null and drp.prd_id is not null and ( (drp_count - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.drp_id = drp.drp_id and sip.p_spi_id != p_spi_id )) > 0 )
  LOOP
    drp_id := _rec.drp_id;
    dlr_id := _rec.dlr_id;
    dlr_number := _rec.dlr_number;
    dlr_date := _rec.dlr_date;
    prd_id := _rec.prd_id;
    drp_count := _rec.drp_count;
    guarantee := _rec.guarantee;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_info_from_order(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_info_from_order(p_opr_id integer) RETURNS TABLE(all_in_one_spec integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  all_in_one_spec := NULL;
  SELECT ord.ord_in_one_spec INTO all_in_one_spec
    FROM dcl_ord_list_produce opr JOIN dcl_order ord ON opr.ord_id = ord.ord_id
    WHERE opr.opr_id = p_opr_id;
  RETURN NEXT;
END $$;


--
-- Name: dcl_get_rest_lpc_for_cpr(integer, integer, character varying, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_lpc_for_cpr(p_cpr_id integer, p_rut_id integer, p_lpc_1c_number_in character varying, p_prc_date_min date) RETURNS TABLE(lpc_id integer, prc_id integer, prc_number character varying, prc_date date, lpc_count numeric, free_count numeric, lpc_1c_number character varying, ctn_number character varying, prd_id integer, reserved numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_cpr_id is null ) then
    p_cpr_id = -1;
  END IF;

  p_lpc_1c_number_in = upper(p_lpc_1c_number_in);

  FOR _rec IN select prc.prc_id, prc.prc_number, prc.prc_date, lpc.lpc_id, (lpc_count - (select  coalesce (sum(shp.lps_count), 0) from dcl_shp_list_produce shp where shp.lpc_id = lpc.lpc_id )), lpc.lpc_1c_number, lpc.prd_id, (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = lpc.prd_id and ctn.stf_id = lpc.stf_id) from dcl_produce_cost prc, dcl_prc_list_produce lpc where prc.p_rut_id = p_rut_id and lpc.prc_id = prc.prc_id and ( p_prc_date_min is null or prc.prc_date >= p_prc_date_min ) and ( p_lpc_1c_number_in is null or p_lpc_1c_number_in like '' or upper(lpc.lpc_1c_number) like('%' || p_lpc_1c_number_in || '%') ) and lpc.lpc_count > (select coalesce (sum(shp.lps_count), 0) from dcl_shp_list_produce shp where shp.lpc_id = lpc.lpc_id )
  LOOP
    prc_id := _rec.prc_id;
    prc_number := _rec.prc_number;
    prc_date := _rec.prc_date;
    lpc_id := _rec.lpc_id;
    lpc_count := _rec.lpc_count;
    lpc_1c_number := _rec.lpc_1c_number;
    prd_id := _rec.prd_id;
    ctn_number := _rec.ctn_number;
    free_count := lpc_count;
    reserved := 0;

    if ( lpc_id is not null ) then
      select reserved from dcl_get_reserved_count_for_cpr(p_cpr_id, lpc_id) into reserved;
  END IF;
    free_count := free_count - reserved;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_lpc_for_lpr(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_lpc_for_lpr(p_cpr_id integer, p_lpc_id integer) RETURNS TABLE(rest_lpc_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  free_count decimal(15,2);
  reserved decimal(15,2);
BEGIN
  if ( p_cpr_id is null ) then
    p_cpr_id = -1;
  END IF;

  select
     (lpc_count - (select coalesce (sum(shp.lps_count), 0) from dcl_shp_list_produce shp where shp.p_lpc_id = p_lpc_id ))
  from dcl_prc_list_produce lpc
  where lpc.p_lpc_id = p_lpc_id
  into
     free_count
  ;

  reserved = 0;

  if ( p_lpc_id is not null ) then
    select reserved from dcl_get_reserved_count_for_cpr(p_cpr_id, p_lpc_id) into reserved;
  END IF;
  rest_lpc_count = free_count - reserved;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_rest_lpc_for_shp(integer, character varying, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_lpc_for_shp(p_rut_id_in integer, p_lpc_1c_number_in character varying, p_prc_date_min date, p_ctr_id_in integer) RETURNS TABLE(lpc_id integer, prc_id integer, prc_number character varying, prc_date date, prd_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, stf_id integer, stf_name character varying, rut_id integer, lpc_count numeric, free_count numeric, lpc_1c_number character varying, ctn_number character varying, cpr_ctr_name character varying, cpr_number character varying, lpr_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_prd_id INTEGER; v_reserved DECIMAL(15,2); v_lpr_count DECIMAL(15,2);
  v_cpr_id INTEGER; v_lpc_count_save DECIMAL(15,2); v_free_count_save DECIMAL(15,2);
  v_lpc_1c_upper VARCHAR(12);
  _rec RECORD; _rec2 RECORD;
BEGIN
  v_lpc_1c_upper := UPPER(p_lpc_1c_number_in);
  FOR _rec IN SELECT prc.prc_id, prc.prc_number, prc.prc_date, prc.rut_id,
      lpc.lpc_id, lpc.stf_id, lpc.lpc_count,
      (lpc.lpc_count - COALESCE((SELECT SUM(lps.lps_count) FROM dcl_shp_list_produce lps WHERE lps.lpc_id = lpc.lpc_id), 0)) AS v_free_count,
      lpc.lpc_1c_number, lpc.prd_id
    FROM dcl_produce_cost prc
    JOIN dcl_prc_list_produce lpc ON lpc.prc_id = prc.prc_id
    WHERE prc.rut_id = p_rut_id_in
      AND (p_prc_date_min IS NULL OR prc.prc_date >= p_prc_date_min)
      AND (v_lpc_1c_upper IS NULL OR v_lpc_1c_upper = '' OR UPPER(lpc.lpc_1c_number) LIKE '%' || v_lpc_1c_upper || '%')
      AND lpc.lpc_count > COALESCE((SELECT SUM(lps.lps_count) FROM dcl_shp_list_produce lps WHERE lps.lpc_id = lpc.lpc_id), 0)
  LOOP
    prc_id := _rec.prc_id; prc_number := _rec.prc_number; prc_date := _rec.prc_date;
    rut_id := _rec.rut_id; lpc_id := _rec.lpc_id; stf_id := _rec.stf_id;
    lpc_count := _rec.lpc_count; free_count := _rec.v_free_count;
    lpc_1c_number := _rec.lpc_1c_number; v_prd_id := _rec.prd_id;
    
    SELECT s.stf_name INTO stf_name FROM dcl_stuff_category s WHERE s.stf_id = _rec.stf_id;
    SELECT p.prd_name, p.prd_type, p.prd_params, p.prd_add_params
      INTO prd_name, prd_type, prd_params, prd_add_params
      FROM dcl_produce p WHERE p.prd_id = v_prd_id;
    BEGIN
      SELECT cn.ctn_number_list INTO ctn_number FROM dcl_get_ctn_num_list_by_prd_id(v_prd_id) cn;
    EXCEPTION WHEN OTHERS THEN ctn_number := NULL;
    END;
    
    v_lpc_count_save := lpc_count; v_free_count_save := free_count;
    cpr_ctr_name := NULL; cpr_number := NULL; lpr_id := NULL;
    
    FOR _rec2 IN SELECT lpr.lpr_id, lpr.lpr_count, lpr.cpr_id
      FROM dcl_cpr_list_produce lpr WHERE lpr.lpc_id = _rec.lpc_id
    LOOP
      lpr_id := _rec2.lpr_id; v_cpr_id := _rec2.cpr_id;
      v_reserved := COALESCE((SELECT SUM(lps.lps_count) FROM dcl_shp_list_produce lps WHERE lps.lpr_id = _rec2.lpr_id), 0);
      v_lpr_count := _rec2.lpr_count - v_reserved;
      IF (v_lpr_count > 0) THEN
        free_count := v_lpr_count;
        lpc_count := _rec2.lpr_count;
        SELECT cp.cpr_number INTO cpr_number FROM dcl_commercial_proposal cp WHERE cp.cpr_id = v_cpr_id;
        SELECT ct.ctr_name INTO cpr_ctr_name FROM dcl_contractor ct
          JOIN dcl_contract c ON c.ctr_id = ct.ctr_id
          JOIN dcl_con_list_spec spc ON c.con_id = spc.con_id
          JOIN dcl_commercial_proposal cp ON cp.spc_id = spc.spc_id
          WHERE cp.cpr_id = v_cpr_id;
        
        IF (p_ctr_id_in IS NULL OR cpr_ctr_name IS NOT NULL) THEN
          RETURN NEXT;
        END IF;
      END IF;
    END LOOP;
    
    lpc_count := v_lpc_count_save; free_count := v_free_count_save;
    cpr_ctr_name := NULL; cpr_number := NULL; lpr_id := NULL;
    IF (NOT EXISTS(SELECT 1 FROM dcl_cpr_list_produce lpr WHERE lpr.lpc_id = _rec.lpc_id)) THEN
      IF (p_ctr_id_in IS NULL) THEN
        RETURN NEXT;
      END IF;
    END IF;
  END LOOP;
END $$;


--
-- Name: dcl_get_rest_opr_for_asm(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_opr_for_asm(p_stf_id integer) RETURNS TABLE(opr_id integer, ord_id integer, ord_number character varying, ord_date date, prd_id integer, opr_count_executed numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  p_stf_id = null; -- Request from Lintera
  FOR _rec IN select opr_id, ord.ord_id as ord_id, ord_number, ord_date, prd_id, ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ) from dcl_ord_list_produce opr, dcl_order ord where ord.ord_id = opr.ord_id and ord.ord_all_include_in_spec is null and (p_stf_id is null or ord.p_stf_id = p_stf_id) and opr.opr_use_prev_number is null and opr.prd_id is not null and ( ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ) > 0 )
  LOOP
    opr_id := _rec.opr_id;
    ord_id := _rec.ord_id;
    ord_number := _rec.ord_number;
    ord_date := _rec.ord_date;
    prd_id := _rec.prd_id;
    opr_count_executed := _rec.opr_count_executed;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_opr_for_dlr(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_opr_for_dlr(p_dlr_id integer, p_usr_id integer) RETURNS TABLE(opr_id integer, ord_id integer, ord_number character varying, ord_date date, ctr_name character varying, prd_id integer, opr_count_executed numeric, ctn_number character varying, seller smallint, specification_number character varying, contract_number character varying, contractor_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_dlr_id is null ) then
    p_dlr_id = -1;
  END IF;

  FOR _rec IN select opr_id, ord.ord_id as ord_id, ord_number, ord_date, prd_id, ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.p_dlr_id = drp.p_dlr_id and ( drp.p_dlr_id != p_dlr_id or ( drp.p_dlr_id = p_dlr_id and (select drp_id from DCL_OCCUPIED_DLR_PRODUCE_V where drp_id = drp.drp_id) is not null) ) and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ), (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = opr.prd_id and ctn.stf_id = ord.stf_id), sln_id from dcl_ord_list_produce opr, dcl_order ord where ord.ord_id = opr.ord_id and (ord.usr_id_create = p_usr_id or p_usr_id = -1 ) and ord.ord_all_include_in_spec is null and opr.opr_use_prev_number is null and opr.prd_id is not null and ( ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.p_dlr_id = drp.p_dlr_id and ( drp.p_dlr_id != p_dlr_id or ( drp.p_dlr_id = p_dlr_id and (select drp_id from DCL_OCCUPIED_DLR_PRODUCE_V where drp_id = drp.drp_id) is not null) ) and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ) > 0 )
  LOOP
    opr_id := _rec.opr_id;
    ord_id := _rec.ord_id;
    ord_number := _rec.ord_number;
    ord_date := _rec.ord_date;
    prd_id := _rec.prd_id;
    opr_count_executed := _rec.opr_count_executed;
    ctn_number := _rec.ctn_number;
    seller := _rec.seller;
    select contractors from dcl_get_contractor_for_for_ord(ord_id, ', ') into ctr_name;
    select specification_number, contract_number , contractor_name from  dcl_get_rest_info_from_order(opr_id) into specification_number, contract_number , contractor_name;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_opr_for_prc(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_opr_for_prc(p_prc_id integer) RETURNS TABLE(opr_id integer, ord_id integer, ord_number character varying, ord_date date, ctr_name character varying, prd_id integer, opr_count_executed numeric, ctn_number character varying, seller smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_prc_id is null ) then
    p_prc_id = -1;
  END IF;

  FOR _rec IN select opr.opr_id, ord.ord_id, ord.ord_number, ord.ord_date, opr.prd_id, ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ), (select ctn_number from dcl_catalog_number ctn where ctn.prd_id = opr.prd_id and ctn.stf_id = ord.stf_id), sln_id from dcl_ord_list_produce opr, dcl_order ord where ord.ord_id = opr.ord_id and ord.ord_all_include_in_spec is null and opr.opr_use_prev_number is null and opr.prd_id is not null and ( ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and (select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ) > 0 )
  LOOP
    opr_id := _rec.opr_id;
    ord_id := _rec.ord_id;
    ord_number := _rec.ord_number;
    ord_date := _rec.ord_date;
    prd_id := _rec.prd_id;
    opr_count_executed := _rec.opr_count_executed;
    ctn_number := _rec.ctn_number;
    seller := _rec.seller;
    select contractors from dcl_get_contractor_for_for_ord(ord_id, ', ') into ctr_name;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_opr_for_spi(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_opr_for_spi(p_spi_id integer) RETURNS TABLE(opr_id integer, ord_id integer, ord_number character varying, ord_date date, ctr_name character varying, prd_id integer, opr_count_executed numeric, seller smallint, guarantee smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_spi_id is null ) then
    p_spi_id = -1; -- __'___'____??_____??_??__ ___??'"___>''__'<__ ID, ''.__ ___>'_ null __'__??____ ____'__??'''_ __'_'_______ sql
  END IF;

  FOR _rec IN select opr_id, ord.ord_id as ord_id, ord_number, ord_date, prd_id, ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id and ( sip.p_spi_id != p_spi_id or ( sip.p_spi_id = p_spi_id and (select sip_id from DCL_OCCUPIED_SPI_PRODUCE_V where sip_id = sip.sip_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ), sln_id, ord_by_guaranty from dcl_ord_list_produce opr, dcl_order ord where ord.ord_id = opr.ord_id and ord.ord_all_include_in_spec is not null and opr.opr_use_prev_number is null and opr.prd_id is not null and ( ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id and ( sip.p_spi_id != p_spi_id or ( sip.p_spi_id = p_spi_id and (select sip_id from DCL_OCCUPIED_SPI_PRODUCE_V where sip_id = sip.sip_id) is not null) ) ) - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ) > 0 )
  LOOP
    opr_id := _rec.opr_id;
    ord_id := _rec.ord_id;
    ord_number := _rec.ord_number;
    ord_date := _rec.ord_date;
    prd_id := _rec.prd_id;
    opr_count_executed := _rec.opr_count_executed;
    seller := _rec.seller;
    guarantee := _rec.guarantee;
    select contractors from dcl_get_contractor_for_for_ord(ord_id, ', ') into ctr_name;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_sip_for_dlr(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_sip_for_dlr(p_dlr_id integer) RETURNS TABLE(sip_id integer, spi_id integer, spi_number character varying, spi_date date, prd_id integer, sip_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  if ( p_dlr_id is null ) then
    p_dlr_id = -1; -- __'__??'____??_??___??_??__ ___??'"___>''__'<_?? ID, ''.__ ___>'_ null __'__??____ ___??'__??'''_ __'_'______?? sql
  END IF;

  FOR _rec IN select sip_id, spi.spi_id as spi_id, spi_number, spi_date, prd_id, ( sip_count - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.sip_id = sip.sip_id and dlr.p_dlr_id = drp.p_dlr_id and drp.p_dlr_id != p_dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) ) as sip_count from dcl_spi_list_produce sip, dcl_specification_import spi where spi.spi_id = sip.spi_id and sip.prd_id is not null and ( ( sip_count - (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.sip_id = sip.sip_id and dlr.p_dlr_id = drp.p_dlr_id and drp.p_dlr_id != p_dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) ) > 0 )
  LOOP
    sip_id := _rec.sip_id;
    spi_id := _rec.spi_id;
    spi_number := _rec.spi_number;
    spi_date := _rec.spi_date;
    prd_id := _rec.prd_id;
    sip_count := _rec.sip_count;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_rest_sip_for_prc(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_rest_sip_for_prc(p_prc_id integer) RETURNS TABLE(sip_id integer, spi_id integer, spi_number character varying, spi_date date, prd_id integer, sip_count numeric, ctn_number character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  cus_code varchar(10);
  drp_id integer;
  opr_id integer;
  _rec RECORD;
BEGIN
  if ( p_prc_id is null ) then
    p_prc_id = -1;
  END IF;

  FOR _rec IN select sip_id, sip.drp_id, sip.opr_id, spi.spi_id, spi_number, spi_date, prd_id, ( sip_count - ( select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and ( select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id ) is not null ) ) ) ), ( select ctn_number from dcl_catalog_number ctn, dcl_dlr_list_produce drp where ctn.prd_id = sip.prd_id and ctn.stf_id = drp.stf_id and drp.drp_id = sip.drp_id ), ( select cus.cus_code from dcl_custom_code cus, dcl_produce prd where prd.prd_id = sip.prd_id and cus.cus_code = prd.cus_code and cus.cus_instant = ( select max(cus1.cus_instant) from dcl_custom_code cus1 where cus1.cus_code = cus.cus_code and cus.cus_instant <= spi.spi_date ) ) from dcl_spi_list_produce sip, dcl_specification_import spi where spi.spi_id = sip.spi_id and spi.spi_arrive is not null and sip.prd_id is not null and ( ( sip_count - ( select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id and ( lpc.p_prc_id != p_prc_id or ( lpc.p_prc_id = p_prc_id and ( select lpc_id from DCL_OCCUPIED_PRC_PRODUCE_V where lpc_id = lpc.lpc_id ) is not null ) ) ) ) > 0 ) order by spi.spi_date DESC, spi.spi_id, 10, sip.sip_id
  LOOP
    sip_id := _rec.sip_id;
    drp_id := _rec.drp_id;
    opr_id := _rec.opr_id;
    spi_id := _rec.spi_id;
    spi_number := _rec.spi_number;
    spi_date := _rec.spi_date;
    prd_id := _rec.prd_id;
    sip_count := _rec.sip_count;
    ctn_number := _rec.ctn_number;
    cus_code := _rec.cus_code;
    if ( drp_id is not null ) then
      SELECT ctn_number
        INTO ctn_number
        from
        dcl_catalog_number ctn,
        dcl_dlr_list_produce drp
      where
        drp.drp_id = drp_id and
        ctn.prd_id = prd_id and
        ctn.stf_id = drp.stf_id;
  END IF;
    if ( opr_id is not null ) then
      SELECT ctn_number
        INTO ctn_number
        from
        dcl_catalog_number ctn,
        dcl_ord_list_produce opr,
        dcl_order ord
      where
        opr.opr_id = opr_id and
        ord.ord_id = opr.ord_id and
        ctn.prd_id = prd_id and
        ctn.stf_id = ord.stf_id;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_row_sum(numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_row_sum(p_sum_pay_closed numeric, p_summ_plus_nds numeric, p_summ_all numeric) RETURNS TABLE(summ_row numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ_row_f float;
BEGIN
  if ( p_sum_pay_closed != 0 ) then
    summ_row_f = p_summ_all * p_summ_plus_nds / p_sum_pay_closed;
  else
    summ_row_f = 0;
  END IF;

  summ_row = summ_row_f;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_row_summ_eur(integer, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_row_summ_eur(p_lcc_id integer, p_summ_plus_nds double precision) RETURNS TABLE(summ_eur numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  eur decimal(15,2);
  summ decimal(15,2);
  summ_eur_f float;
BEGIN
  SELECT sum(pls.lps_summ_eur), sum(pls.lps_summ)
    INTO eur, summ
    from dcl_pay_list_summ pls,
       dcl_ctc_pay ctc_pay
  where ctc_pay.p_lcc_id = p_lcc_id and
        pls.lps_id = ctc_pay.lps_id;

  if ( summ != 0 ) then
    summ_eur_f = eur * p_summ_plus_nds / summ;
  else
    summ_eur_f = 0;
  END IF;

  summ_eur = summ_eur_f;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_row_summ_out_nds(numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_row_summ_out_nds(summ_eur_row numeric, nds_rate numeric) RETURNS TABLE(summ_out_nds numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ_out_nds_f float;
begin
  summ_out_nds_f = summ_eur_row  * 100 / ( 100 + nds_rate );

  summ_out_nds = summ_out_nds_f;

  RETURN NEXT;
end
$$;


--
-- Name: dcl_get_spc_pay_expiration(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_spc_pay_expiration(p_spc_id integer) RETURNS TABLE(spc_pay_expiration integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spp_date date;
  pay_sum decimal(15,2);
  spp_sum decimal(15,2);
  spp_sum_all decimal(15,2);
  last_pay_date date;
  last_graphic_date date;
  _rec RECORD;
BEGIN
  spc_pay_expiration := 0;

  SELECT coalesce(sum(psum.lps_summ), 0)
    INTO pay_sum
    from
    dcl_payment pay,
    dcl_pay_list_summ psum
  where
    psum.p_spc_id = p_spc_id and
    pay.pay_id = psum.pay_id;

  spp_sum_all := 0;
  FOR _rec IN select spp_sum, spp_date from dcl_spc_list_payment where p_spc_id = p_spc_id and (spp_date < (CURRENT_DATE) or spp_date is null ) order by spp_id
  LOOP
    spp_sum := _rec.spp_sum;
    spp_date := _rec.spp_date;
    spp_sum_all := spp_sum_all + spp_sum;
    if ( spp_sum_all > pay_sum and spp_date is not null) then
      select count_day from dcl_get_count_day((CURRENT_DATE), spp_date) into spc_pay_expiration;

      RETURN NEXT;
      RETURN;
  END IF;
  END LOOP;

  SELECT coalesce(sum(spp_sum), 0)
    INTO spp_sum
    from dcl_spc_list_payment
  where p_spc_id = p_spc_id;

  if ( spp_sum_all = pay_sum ) then -- all paied
    SELECT max(pay.pay_date)
      INTO last_pay_date
      from
      dcl_payment pay,
      dcl_pay_list_summ psum
    where
      psum.p_spc_id = p_spc_id and
      pay.pay_id = psum.pay_id;

    SELECT max(spp_date)
      INTO last_graphic_date
      from dcl_spc_list_payment
    where p_spc_id = p_spc_id;

    if ( last_graphic_date < last_pay_date ) then
      select count_day from dcl_get_count_day(last_pay_date, last_graphic_date) into spc_pay_expiration;
      RETURN NEXT;
  END IF;
  END IF;
END
$$;


--
-- Name: dcl_get_spi_list_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_spi_list_for_ord(p_ord_id integer) RETURNS TABLE(specifications_import character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spi_num_date varchar(130);
  spi_date integer;
  spi_number varchar(100);
  _rec RECORD;
BEGIN
  specifications_import = '';

  FOR _rec IN select distinct spi_number, spi_date from dcl_get_spi_num_date_for_ord(p_ord_id)
  LOOP
    spi_number := _rec.spi_number;
    spi_date := _rec.spi_date;
    select strdate from date2str(spi_date) into spi_num_date;
    spi_num_date = spi_number || 'from' || spi_num_date;

    specifications_import = specifications_import || spi_num_date || ', ';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_spi_num_date_for_drp(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_spi_num_date_for_drp(p_drp_id integer) RETURNS TABLE(spi_date date, spi_number character varying, spi_send_date date, sip_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select spi_date, spi_number, spi_send_date, sip_id from dcl_specification_import spi, dcl_spi_list_produce sip where   sip.spi_id = spi.spi_id and sip.p_drp_id = p_drp_id
  LOOP
    spi_date := _rec.spi_date;
    spi_number := _rec.spi_number;
    spi_send_date := _rec.spi_send_date;
    sip_id := _rec.sip_id;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_spi_num_date_for_ord(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_spi_num_date_for_ord(p_ord_id integer) RETURNS TABLE(spi_date date, spi_number character varying, spi_send_date date, sip_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  drp_id integer;
  apr_id integer;
  asm_id integer;
  _rec RECORD;
BEGIN
  FOR _rec IN select opr_id from dcl_ord_list_produce where p_ord_id = p_ord_id
  LOOP
    opr_id := _rec.opr_id;
  FOR _rec IN select spi_date, spi_number, spi_send_date, sip_id from dcl_specification_import spi, dcl_spi_list_produce sip where   sip.spi_id = spi.spi_id and sip.opr_id = opr_id
  LOOP
    spi_date := _rec.spi_date;
    spi_number := _rec.spi_number;
    spi_send_date := _rec.spi_send_date;
    sip_id := _rec.sip_id;
      RETURN NEXT;
  END LOOP;

  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.opr_id = opr_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select spi_date, spi_number, spi_send_date, sip_id from dcl_get_spi_num_date_for_drp(drp_id)
  LOOP
    spi_date := _rec.spi_date;
    spi_number := _rec.spi_number;
    spi_send_date := _rec.spi_send_date;
    sip_id := _rec.sip_id;
        RETURN NEXT;
  END LOOP;
  END LOOP;

  FOR _rec IN select apr_id from dcl_asm_list_produce apr where apr.opr_id = opr_id
  LOOP
    apr_id := _rec.apr_id;
  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.apr_id = apr_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select spi_date, spi_number, spi_send_date, sip_id from dcl_get_spi_num_date_for_drp(drp_id)
  LOOP
    spi_date := _rec.spi_date;
    spi_number := _rec.spi_number;
    spi_send_date := _rec.spi_send_date;
    sip_id := _rec.sip_id;
          RETURN NEXT;
  END LOOP;
  END LOOP;
  END LOOP;

  FOR _rec IN select asm_id from dcl_assemble asm where asm.opr_id = opr_id
  LOOP
    asm_id := _rec.asm_id;
  FOR _rec IN select drp_id from dcl_dlr_list_produce drp where drp.apr_id = asm_id
  LOOP
    drp_id := _rec.drp_id;
  FOR _rec IN select spi_date, spi_number, spi_send_date, sip_id from dcl_get_spi_num_date_for_drp(drp_id)
  LOOP
    spi_date := _rec.spi_date;
    spi_number := _rec.spi_number;
    spi_send_date := _rec.spi_send_date;
    sip_id := _rec.sip_id;
          RETURN NEXT;
  END LOOP;
  END LOOP;
  END LOOP;

  END LOOP;
END
$$;


--
-- Name: dcl_get_sum_out_nds_eur(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_sum_out_nds_eur(p_spc_id integer) RETURNS TABLE(sum_out_nds_eur numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lps_summ_eur DECIMAL(15,2);
  lps_summ DECIMAL(15,2);
  shp_summ_plus_nds DECIMAL(15,2);
  spc_nds_rate DECIMAL(15,2);
  sum_out_nds_eur_f FLOAT;
BEGIN
  /* Procedure Text */

  SELECT sum(pls.lps_summ_eur), sum(pls.lps_summ)
    INTO lps_summ_eur, lps_summ
    from dcl_pay_list_summ pls
  where pls.p_spc_id = p_spc_id;

  SELECT sum(shp.shp_summ_plus_nds)
    INTO shp_summ_plus_nds
    from dcl_shipping shp
  where shp.p_spc_id = p_spc_id;

  SELECT spc.spc_nds_rate
    INTO spc_nds_rate
    from dcl_con_list_spec spc
  where spc.p_spc_id = p_spc_id;

  sum_out_nds_eur_f = shp_summ_plus_nds / lps_summ * lps_summ_eur * 100  / (100 + spc_nds_rate);

  sum_out_nds_eur = sum_out_nds_eur_f;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_sum_out_nds_eur_part(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_sum_out_nds_eur_part(p_spc_id integer, p_pay_ids character varying, p_shp_ids character varying) RETURNS TABLE(sum_out_nds_eur numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lps_summ_eur decimal(15,2);
  lps_summ decimal(15,2);
  shp_summ_plus_nds decimal(15,2);
  spc_nds_rate decimal(15,2);
  sum_out_nds_eur_f float;
BEGIN
  /* Procedure Text */

  SELECT sum(pls.lps_summ_eur), sum(pls.lps_summ)
    INTO lps_summ_eur, lps_summ
    from dcl_pay_list_summ pls
  where pls.p_spc_id = p_spc_id and
        not exists ( select int_id from dcl_decode_id_list(p_pay_ids) where int_id = pls.pay_id );

  SELECT sum(shp.shp_summ_plus_nds)
    INTO shp_summ_plus_nds
    from dcl_shipping shp
  where shp.p_spc_id = p_spc_id  and
        not exists ( select int_id from dcl_decode_id_list(p_shp_ids) where int_id = shp.shp_id );

  SELECT spc.spc_nds_rate
    INTO spc_nds_rate
    from dcl_con_list_spec spc
  where spc.p_spc_id = p_spc_id;

  sum_out_nds_eur_f = shp_summ_plus_nds / lps_summ * lps_summ_eur * 100  / (100 + spc_nds_rate);

  sum_out_nds_eur = sum_out_nds_eur_f;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_get_timestamp_breakdown(date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_timestamp_breakdown(p_par_date1 date, p_par_date2 date) RETURNS TABLE(par_date date, par_year integer, par_month integer, par_day integer, par_week integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_date DATE;
BEGIN
  IF (p_par_date1 IS NULL OR p_par_date2 IS NULL) THEN
    RETURN;
  END IF;
  v_date := p_par_date1;
  WHILE (v_date <= p_par_date2) LOOP
    par_date := v_date;
    par_year := EXTRACT(YEAR FROM v_date);
    par_month := EXTRACT(MONTH FROM v_date);
    par_day := EXTRACT(DAY FROM v_date);
    par_week := EXTRACT(WEEK FROM v_date);
    RETURN NEXT;
    v_date := v_date + INTERVAL '1 day';
  END LOOP;
END $$;


--
-- Name: dcl_get_tree(character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, smallint, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_tree(p_cat_name_in character varying, p_prd_name_in character varying, p_prd_type_in character varying, p_prd_params_in character varying, p_prd_add_params_in character varying, p_stf_id_in integer, p_cus_code_in character varying, p_ctn_number_in character varying, p_not_blocked smallint, p_prd_common_in character varying) RETURNS TABLE(cat_id integer, cat_name character varying, parent_id integer, is_have_produces smallint, is_have_subfolders smallint, prd_count integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  cat_name_fake varchar(100);
  _rec RECORD;
BEGIN
  FOR _rec IN select cat_id, cat_name, parent_id, upper(cat.cat_name) as cat_name_sort from dcl_category cat order by parent_id, cat_name_sort
  LOOP
    cat_id := _rec.cat_id;
    cat_name := _rec.cat_name;
    parent_id := _rec.parent_id;
    cat_name_fake := _rec.cat_name_fake;
      select sum(is_have_produces),
             sum(is_have_subfolders),
             sum(prd_count)
      from DCL_GET_CATEGORIES_FOR_TREE(cat_id, p_cat_name_in, p_prd_name_in, p_prd_type_in, p_prd_params_in, p_prd_add_params_in, p_stf_id_in, p_cus_code_in, p_ctn_number_in, p_not_blocked, p_prd_common_in)
      into is_have_produces,
           is_have_subfolders,
           prd_count;
      RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_get_user_for_contract(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_user_for_contract(p_con_id integer) RETURNS TABLE(usr_id integer, con_user character varying, dep_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  FOR usr_id, con_user IN
    SELECT DISTINCT
      spc.usr_id,
      (SELECT ul.usr_surname || ' ' || ul.usr_name FROM dcl_user_language ul WHERE ul.usr_id = spc.usr_id AND ul.lng_id = 1)
    FROM dcl_con_list_spec spc
    WHERE spc.con_id = p_con_id AND spc.usr_id IS NOT NULL
  LOOP
    dep_id := NULL;
    IF usr_id IS NOT NULL THEN
      SELECT u.dep_id FROM dcl_user u WHERE u.usr_id = dcl_get_user_for_contract.usr_id INTO dep_id;
    END IF;
    RETURN NEXT;
  END LOOP;
END;
$$;


--
-- Name: dcl_get_usr_dep_list_con(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_usr_dep_list_con(p_con_id integer) RETURNS TABLE(con_user character varying, usr_id_list character varying, dep_id_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  con_user_local VARCHAR(50);
  usr_id_local INTEGER;
  dep_id_local INTEGER;
BEGIN
  con_user := '';
  usr_id_list := '';
  dep_id_list := '';
  
  FOR usr_id_local, con_user_local, dep_id_local IN
    SELECT uf.usr_id, uf.con_user, uf.dep_id
    FROM dcl_get_user_for_contract(p_con_id) uf
  LOOP
    usr_id_list := usr_id_list || usr_id_local || '<br>';
    con_user := con_user || con_user_local || '<br>';
    IF dep_id_local IS NOT NULL THEN
      dep_id_list := dep_id_list || dep_id_local || '<br>';
    END IF;
  END LOOP;
  
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_get_usr_for_spec_imp(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_usr_for_spec_imp(p_spi_id integer) RETURNS TABLE(usr_full_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_temp TEXT;
  v_name TEXT;
  _rec RECORD;
BEGIN
  v_temp := '';
  FOR _rec IN SELECT u.usr_full_name FROM dcl_user u
    JOIN dcl_sip_list_produce sip ON sip.usr_id = u.usr_id
    WHERE sip.spi_id = p_spi_id
    GROUP BY u.usr_full_name
  LOOP
    v_name := _rec.usr_full_name;
    IF (POSITION(v_name IN v_temp) = 0) THEN
      v_temp := v_temp || v_name || ', ';
    END IF;
  END LOOP;
  usr_full_name := v_temp;
  RETURN NEXT;
END $$;


--
-- Name: dcl_get_usr_id_list_shp(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_get_usr_id_list_shp(p_shp_id integer, p_spc_id integer) RETURNS TABLE(usr_id_list character varying, dep_id_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_con_id integer;
  v_usr_id integer;
  v_dep_id integer;
  rec RECORD;
BEGIN
  usr_id_list := '';
  dep_id_list := '';
  IF p_spc_id IS NOT NULL THEN
    SELECT spc.con_id FROM dcl_con_list_spec spc WHERE spc.spc_id = p_spc_id INTO v_con_id;
    FOR rec IN SELECT u.usr_id, u.dep_id FROM dcl_get_user_for_contract(v_con_id) u
    LOOP
      usr_id_list := usr_id_list || rec.usr_id || '<br>';
      IF rec.dep_id IS NOT NULL THEN
        dep_id_list := dep_id_list || rec.dep_id || '<br>';
      END IF;
    END LOOP;
  END IF;

  FOR rec IN
    SELECT DISTINCT lmn.usr_id
    FROM dcl_shp_list_produce lps, dcl_lps_list_manager lmn
    WHERE lps.shp_id = p_shp_id AND lmn.lps_id = lps.lps_id
  LOOP
    usr_id_list := usr_id_list || rec.usr_id || '<br>';
    SELECT u.dep_id FROM dcl_user u WHERE u.usr_id = rec.usr_id INTO v_dep_id;
    IF v_dep_id IS NOT NULL THEN
      dep_id_list := dep_id_list || v_dep_id || '<br>';
    END IF;
  END LOOP;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_goods_circulation(date, date, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_goods_circulation(p_date_begin date, p_date_end date, p_prd_common_in character varying, p_stf_id_in integer, p_sln_id_in integer, p_ctr_id_in integer) RETURNS TABLE(lps_id integer, lps_count numeric, prd_id integer, produce_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, rest_in_minsk numeric, ctn_number character varying, unit character varying, contractor character varying, shp_date date, stf_id integer, stf_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prd_common varchar(1700);
  _rec RECORD;
BEGIN
  p_prd_common_in = upper(p_prd_common_in);

  FOR _rec IN select lps.lps_id, lps.lps_count, shp.shp_date, lpc.prd_id, ctr.ctr_name, ( select ctn.ctn_number from dcl_catalog_number ctn where ctn.stf_id = lpc.stf_id and ctn.prd_id = lpc.prd_id ), stf.stf_id, stf.stf_name from dcl_shipping shp, dcl_contractor ctr, dcl_shp_list_produce lps, dcl_prc_list_produce lpc, dcl_stuff_category stf, dcl_con_list_spec spc, dcl_contract con where shp.shp_date >= p_date_begin and shp.shp_date <= p_date_end and lps.shp_id = shp.shp_id and lpc.lpc_id = lps.lpc_id and ctr.ctr_id = shp.ctr_id and stf.stf_id = lpc.stf_id and (p_stf_id_in is null or p_stf_id_in = -1 or stf.stf_id = p_stf_id_in) and spc.spc_id = shp.spc_id and con.con_id = spc.con_id and (p_sln_id_in is null or con.sln_id = p_sln_id_in ) and (p_ctr_id_in is null or p_ctr_id_in = -1 or ctr.ctr_id = p_ctr_id_in )
  LOOP
    lps_id := _rec.lps_id;
    lps_count := _rec.lps_count;
    shp_date := _rec.shp_date;
    prd_id := _rec.prd_id;
    contractor := _rec.ctr_name;
    ctn_number := _rec.ctn_number;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;

      select
        prd.prd_name,
        prd.prd_type,
        prd.prd_params,
        prd.prd_add_params,
        unt.unt_name
      from  dcl_produce prd,
            dcl_unit_language unt
      where prd.prd_id = prd_id and
            unt.unt_id = prd.unt_id and
            unt.lng_id = 1
      into
        produce_name,
        prd_type,
        prd_params,
        prd_add_params,
        unit
      ;

      prd_common := upper(coalesce(produce_name, '') || ' ' || coalesce(prd_type, '') || ' ' || coalesce(prd_params, '') || ' ' || coalesce(prd_add_params, ''));
      if ( p_prd_common_in is null or p_prd_common_in like '' or prd_common like('%' || p_prd_common_in || '%') ) then
        select rest_in_minsk from dcl_get_circ_and_rest_for_prd(prd_id) into rest_in_minsk;

        RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_goods_circulation_rest(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_goods_circulation_rest(p_prd_common_in character varying, p_stf_id_in integer, p_ctr_id_for_in integer) RETURNS TABLE(prd_id integer, produce_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, ctn_number character varying, unit character varying, contractor character varying, stf_id integer, stf_name character varying, shp_date date, rest_in_minsk numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prd_common varchar(1700);
  ord_in_one_spec smallint;
  ord_ctr_id_for integer;
  opr_ctr_id_for integer;
  _rec RECORD;
BEGIN
  p_prd_common_in = upper(p_prd_common_in);

  FOR _rec IN select ord.stf_id, stf.stf_name, opr.prd_id, opr.ctr_id, ord.ord_date, ord.ord_in_one_spec, ord.ctr_id_for, ( select ctn.ctn_number from dcl_catalog_number ctn where ctn.stf_id = ord.stf_id and ctn.prd_id = opr.prd_id ) from   dcl_order ord, dcl_ord_list_produce opr, dcl_stuff_category stf where  opr.ord_id = ord.ord_id and stf.stf_id = ord.stf_id and (p_stf_id_in is null or p_stf_id_in = -1 or stf.stf_id = p_stf_id_in ) and ( p_ctr_id_for_in is null or p_ctr_id_for_in = -1 or ( ord.ctr_id_for = p_ctr_id_for_in and ord.ord_in_one_spec is not null ) or ( ord.ord_in_one_spec is null and (select count(opr_id) from dcl_ord_list_produce where ord_id = ord.ord_id and ctr_id = p_ctr_id_for_in ) > 0 ) ) and ord.ord_annul is null and opr.opr_count > 0
  LOOP
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    prd_id := _rec.prd_id;
    opr_ctr_id_for := _rec.ctr_id;
    shp_date := _rec.ord_date;
    -- нужно для выделения периодов ord_in_one_spec := _rec.ord_in_one_spec;
    ord_ctr_id_for := _rec.ctr_id_for;
    ctn_number := _rec.ctn_number;
     select
        prd.prd_name,
        prd.prd_type,
        prd.prd_params,
        prd.prd_add_params,
        unt.unt_name
      from  dcl_produce prd,
            dcl_unit_language unt
      where prd.prd_id = prd_id and
            unt.unt_id = prd.unt_id and
            unt.lng_id = 1
      into
        produce_name,
        prd_type,
        prd_params,
        prd_add_params,
        unit
      ;

      prd_common := upper(coalesce(produce_name, '') || ' ' || coalesce(prd_type, '') || ' ' || coalesce(prd_params, '') || ' ' || coalesce(prd_add_params, ''));
      if ( p_prd_common_in is null or p_prd_common_in like '' or prd_common like('%' || p_prd_common_in || '%') ) then

        if (ord_in_one_spec is null) then
          select ctr_name from dcl_contractor where ctr_id = opr_ctr_id_for into contractor;
  ELSE
          select ctr_name from dcl_contractor where ctr_id = ord_ctr_id_for into contractor;
  END IF;

        select rest_in_minsk from dcl_get_circ_and_rest_for_prd(prd_id) into rest_in_minsk;

        RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_goods_rest(date, integer, integer, date, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_goods_rest(p_date_in date, p_usr_id_in integer, p_dep_id_in integer, p_date_to_in date, p_purpose_id_in integer, p_stf_id_in integer) RETURNS TABLE(lpc_id integer, prd_id integer, produce_name character varying, stf_name character varying, usr_id integer, usr_name character varying, dep_id integer, dep_name character varying, unit character varying, lpc_count numeric, lpc_count_free numeric, prc_date date, prc_number character varying, less_3_month numeric, month_3_6 numeric, month_6_9 numeric, month_9_12 numeric, more_12_month numeric, lpc_count_free_to numeric, less_3_month_to numeric, month_3_6_to numeric, month_6_9_to numeric, month_9_12_to numeric, more_12_month_to numeric, purpose character varying, order_for character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, ctn_number character varying, lpc_1c_number character varying, spc_number character varying, spc_date date, con_number character varying, con_date date, lpc_comment character varying, drp_purpose character varying, produce_name_sort character varying, stf_name_sort character varying, lpc_cost_one_by numeric, lpc_price_list_by numeric, dlr_comment character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  need_suspend integer;
  sum_eur decimal(15,2);
  sum_eur_to decimal(15,2);
  drp_id integer;
  sum_other_charges decimal(15,2);
  lpc_cost_one decimal(15,2);
  date_for_end_date date;
  _rec RECORD;
BEGIN
  date_for_end_date := addday(p_date_in, 1);
  IF ( p_date_to_in is null ) THEN
    FOR _rec IN select lpc.lpc_id, lpc.drp_id, prd.prd_id, prd.prd_name, prd.prd_type, prd.prd_params, prd.prd_add_params, stf.stf_name, ( select ctn.ctn_number from dcl_catalog_number ctn where ctn.stf_id = lpc.stf_id and ctn.prd_id = prd.prd_id ), usr.usr_id, usr_lng.usr_surname || ' ' || usr_lng.usr_name, lpc.dep_id, unt.unt_name, lpc.lpc_count, coalesce (lpc.lpc_count, 0) - ( select  coalesce (sum(lps.lps_count), 0) from dcl_shp_list_produce lps where lps.lpc_id = lpc.lpc_id and lps.shp_date <= date_for_end_date ), prc.prc_date, prc.prc_number, lpc.lpc_sum_transport + lpc.lpc_custom, lpc.lpc_cost_one, lpc.lpc_1c_number, lpc.lpc_cost_one_by, lpc.lpc_price_list_by, lpc.lpc_comment, prs.prs_name from dcl_prc_list_produce lpc, dcl_produce_cost prc, dcl_stuff_category stf, dcl_user usr, dcl_user_language usr_lng, dcl_purpose prs, dcl_produce prd, dcl_unit_language unt where prc.prc_id = lpc.prc_id and stf.stf_id = lpc.stf_id and usr.usr_id = lpc.usr_id and usr_lng.usr_id = usr.usr_id and usr_lng.lng_id = 1 and prc.prc_date <= date_for_end_date and (p_purpose_id_in = -1 or p_purpose_id_in = lpc.prs_id ) and prs.prs_id = lpc.prs_id and prd.prd_id = lpc.prd_id and unt.unt_id = prd.unt_id and unt.lng_id = 1 and (p_usr_id_in is null or p_usr_id_in = -1 or p_usr_id_in = usr.usr_id ) and (p_dep_id_in is null or p_dep_id_in = -1 or p_dep_id_in = lpc.dep_id ) and (p_stf_id_in is null or p_stf_id_in = -1 or p_stf_id_in = stf.stf_id ) order by prc.prc_date
    LOOP
      lpc_id := _rec.lpc_id;
      drp_id := _rec.drp_id;
      prd_id := _rec.prd_id;
      produce_name := _rec.prd_name;
      prd_type := _rec.prd_type;
      prd_params := _rec.prd_params;
      prd_add_params := _rec.prd_add_params;
      stf_name := _rec.stf_name;
      ctn_number := _rec.ctn_number;
      usr_id := _rec.usr_id;
      usr_name := _rec.usr_name;
      dep_id := _rec.dep_id;
      unit := _rec.unit;
      lpc_count := _rec.lpc_count;
      lpc_count_free := _rec.lpc_count_free;
      prc_date := _rec.prc_date;
      prc_number := _rec.prc_number;
      sum_other_charges := _rec.sum_other_charges;
      lpc_cost_one := _rec.lpc_cost_one;
      lpc_1c_number := _rec.lpc_1c_number;
      lpc_cost_one_by := _rec.lpc_cost_one_by;
      lpc_price_list_by := _rec.lpc_price_list_by;
      lpc_comment := _rec.lpc_comment;
      purpose := _rec.purpose;
      dep_name := null;
      IF ( dep_id is not null ) THEN
        select dep_name from dcl_department where dep_id = dep_id into dep_name;
      END IF;
      SELECT ctr_name, spc_number, spc_date, con_number, con_date
        INTO order_for, spc_number, spc_date, con_number, con_date
        from get_contractor_for_for_lpc_id(lpc_id);

      drp_purpose := null;
      dlr_comment := null;
      IF ( drp_id is not null ) THEN
        select drp.drp_purpose from dcl_dlr_list_produce drp where drp.drp_id = drp_id into drp_purpose;

        SELECT dlr.dlr_comment
          INTO dlr_comment
          from dcl_delivery_request dlr, dcl_dlr_list_produce drp where dlr.dlr_id = drp.dlr_id and drp.drp_id = drp_id;

      END IF;
      lpc_count_free := coalesce (lpc_count_free, 0);

      less_3_month := 0;
      month_3_6 := 0;
      month_6_9 := 0;
      month_9_12 := 0;
      more_12_month := 0;

      IF ( lpc_count_free != 0 ) THEN
        IF (prc_date < '2016-07-01') THEN
          lpc_cost_one_by := ROUND(lpc_cost_one_by / 100, 0) / 100;
          lpc_price_list_by := ROUND(lpc_price_list_by / 100, 0) / 100;
        END IF;
        sum_eur := ( lpc_cost_one + sum_other_charges / lpc_count ) * lpc_count_free;

        IF ( prc_date >= addday(p_date_in, -30 * 3) ) THEN
          less_3_month := sum_eur;
        ELSE
          IF ( prc_date >= addday(p_date_in, -30 * 6) ) THEN
            month_3_6 := sum_eur;
          ELSE
            IF ( prc_date >= addday(p_date_in, -30 * 9) ) THEN
              month_6_9 := sum_eur;
            ELSE
              IF ( prc_date >= addday(p_date_in, -30 * 12) ) THEN
                month_9_12 := sum_eur;
              ELSE
                more_12_month := sum_eur;
              END IF;
            END IF;
          END IF;
        END IF;

        produce_name_sort := upper(produce_name || ' ' || prd_type || ' ' || prd_params || ' ' || prd_add_params);
        stf_name_sort := upper(stf_name);
        RETURN NEXT;
      END IF;
    END LOOP;
  ELSE
    FOR _rec IN select lpc.lpc_id, lpc.drp_id, prd.prd_id, prd.prd_name, prd.prd_type, prd.prd_params, prd.prd_add_params, stf.stf_name, ( select ctn.ctn_number from dcl_catalog_number ctn where ctn.stf_id = lpc.stf_id and ctn.prd_id = prd.prd_id ), usr.usr_id, usr_lng.usr_surname || ' ' || usr_lng.usr_name, lpc.dep_id, unt.unt_name, lpc.lpc_count, ( select coalesce (lpc_count, 0) from dcl_prc_list_produce lpc1, dcl_produce_cost prc1 where lpc1.lpc_id = lpc.lpc_id and prc1.prc_id = lpc1.prc_id and prc1.prc_date <= date_for_end_date ) - ( select  coalesce (sum(lps.lps_count), 0) from dcl_shp_list_produce lps where lps.lpc_id = lpc.lpc_id and lps.shp_date <= date_for_end_date ), coalesce (lpc_count, 0) - ( select  coalesce (sum(lps.lps_count), 0) from dcl_shp_list_produce lps where lps.lpc_id = lpc.lpc_id and lps.shp_date <= p_date_to_in ), prc.prc_date, prc.prc_number, lpc.lpc_sum_transport + lpc.lpc_custom, lpc.lpc_cost_one, lpc.lpc_1c_number, lpc.lpc_cost_one_by, lpc.lpc_price_list_by, lpc.lpc_comment, prs.prs_name from dcl_prc_list_produce lpc, dcl_produce_cost prc, dcl_stuff_category stf, dcl_user usr, dcl_user_language usr_lng, dcl_purpose prs, dcl_produce prd, dcl_unit_language unt where prc.prc_id = lpc.prc_id and stf.stf_id = lpc.stf_id and usr.usr_id = lpc.usr_id and usr_lng.usr_id = usr.usr_id and usr_lng.lng_id = 1 and prc.prc_date <= p_date_to_in and (p_purpose_id_in = -1 or p_purpose_id_in = lpc.prs_id ) and prs.prs_id = lpc.prs_id and prd.prd_id = lpc.prd_id and unt.unt_id = prd.unt_id and unt.lng_id = 1 and (p_usr_id_in is null or p_usr_id_in = -1 or p_usr_id_in = usr.usr_id ) and (p_dep_id_in is null or p_dep_id_in = -1 or p_dep_id_in = lpc.dep_id ) and (p_stf_id_in is null or p_stf_id_in = -1 or p_stf_id_in = stf.stf_id ) order by prc.prc_date
    LOOP
      lpc_id := _rec.lpc_id;
      drp_id := _rec.drp_id;
      prd_id := _rec.prd_id;
      produce_name := _rec.prd_name;
      prd_type := _rec.prd_type;
      prd_params := _rec.prd_params;
      prd_add_params := _rec.prd_add_params;
      stf_name := _rec.stf_name;
      ctn_number := _rec.ctn_number;
      usr_id := _rec.usr_id;
      usr_name := _rec.usr_name;
      dep_id := _rec.dep_id;
      unit := _rec.unit;
      lpc_count := _rec.lpc_count;
      lpc_count_free := _rec.lpc_count_free;
      lpc_count_free_to := _rec.lpc_count_free_to;
      prc_date := _rec.prc_date;
      prc_number := _rec.prc_number;
      sum_other_charges := _rec.sum_other_charges;
      lpc_cost_one := _rec.lpc_cost_one;
      lpc_1c_number := _rec.lpc_1c_number;
      lpc_cost_one_by := _rec.lpc_cost_one_by;
      lpc_price_list_by := _rec.lpc_price_list_by;
      lpc_comment := _rec.lpc_comment;
      purpose := _rec.purpose;
      dep_name := null;
      IF ( dep_id is not null ) THEN
        select dep_name from dcl_department where dep_id = dep_id into dep_name;
      END IF;
      SELECT ctr_name, spc_number, spc_date, con_number, con_date
        INTO order_for, spc_number, spc_date, con_number, con_date
        from get_contractor_for_for_lpc_id(lpc_id);

      drp_purpose := null;
      dlr_comment := null;
      IF ( drp_id is not null ) THEN
        select drp.drp_purpose from dcl_dlr_list_produce drp where drp.drp_id = drp_id into drp_purpose;

        SELECT dlr.dlr_comment
          INTO dlr_comment
          from dcl_delivery_request dlr, dcl_dlr_list_produce drp where dlr.dlr_id = drp.dlr_id and drp.drp_id = drp_id;
      END IF;
      lpc_count_free := coalesce (lpc_count_free, 0);
      lpc_count_free_to := coalesce (lpc_count_free_to, 0);

      need_suspend := 1;

      less_3_month := 0;
      month_3_6 := 0;
      month_6_9 := 0;
      month_9_12 := 0;
      more_12_month := 0;

      less_3_month_to := 0;
      month_3_6_to := 0;
      month_6_9_to := 0;
      month_9_12_to := 0;
      more_12_month_to := 0;

      IF ( lpc_count_free = 0 and lpc_count_free_to = 0 ) THEN
        need_suspend := 0;
      END IF;
      IF ( need_suspend = 1 ) THEN
        IF (prc_date < '2016-07-01') THEN
          lpc_cost_one_by := ROUND(lpc_cost_one_by / 100, 0) / 100;
          lpc_price_list_by := ROUND(lpc_price_list_by / 100, 0) / 100;
        END IF;
        sum_eur := ( lpc_cost_one + sum_other_charges / lpc_count ) * lpc_count_free;
        sum_eur_to := ( lpc_cost_one + sum_other_charges / lpc_count ) * lpc_count_free_to;

        IF ( prc_date <= date_for_end_date ) THEN
          IF ( prc_date >= addday(p_date_in, -30 * 3) ) THEN
            less_3_month := sum_eur;
          ELSE
            IF ( prc_date >= addday(p_date_in, -30 * 6) ) THEN
              month_3_6 := sum_eur;
            ELSE
              IF ( prc_date >= addday(p_date_in, -30 * 9) ) THEN
                month_6_9 := sum_eur;
              ELSE
                IF ( prc_date >= addday(p_date_in, -30 * 12) ) THEN
                  month_9_12 := sum_eur;
                ELSE
                  more_12_month := sum_eur;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
        IF ( prc_date >= addday(p_date_to_in, -30 * 3) ) THEN
          less_3_month_to := sum_eur_to;
        ELSE
          IF ( prc_date >= addday(p_date_to_in, -30 * 6) ) THEN
            month_3_6_to := sum_eur_to;
          ELSE
            IF ( prc_date >= addday(p_date_to_in, -30 * 9) ) THEN
              month_6_9_to := sum_eur_to;
            ELSE
              IF ( prc_date >= addday(p_date_to_in, -30 * 12) ) THEN
                month_9_12_to := sum_eur_to;
              ELSE
                more_12_month_to := sum_eur_to;
              END IF;
            END IF;
          END IF;
        END IF;

        produce_name_sort := upper(produce_name || ' ' || prd_type || ' ' || prd_params || ' ' || prd_add_params);
        stf_name_sort := upper(stf_name);
        RETURN NEXT;
      END IF;
    END LOOP;
  END IF;
END
$$;


--
-- Name: dcl_inf_message_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_inf_message_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.INM_ID IS NULL) THEN
    NEW.INM_ID = nextval('gen_dcl_inf_message_id');
  ELSE
        ID = nextval('gen_dcl_inf_message_id');
        IF ( ID < NEW.INM_ID ) THEN
          ID = nextval('gen_dcl_inf_message_id');
  END IF;
  END IF;

  new.inm_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_instruction_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.ins_id and att.att_parent_table = 'DCL_INSTRUCTION';
RETURN OLD;
END
$$;


--
-- Name: dcl_instruction_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.INS_ID IS NULL) THEN
    NEW.INS_ID = nextval('gen_dcl_instruction_id');
  ELSE
        ID = nextval('gen_dcl_instruction_id');
        IF ( ID < NEW.INS_ID ) THEN
          ID = nextval('gen_dcl_instruction_id');
  END IF;
  END IF;
    new.ins_create_date = CURRENT_TIMESTAMP;
    new.usr_id_create = get_context('usr_id');
    new.ins_edit_date = CURRENT_TIMESTAMP;
    new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_instruction_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.ins_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_instruction_filter(integer, character varying, date, date, smallint, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_filter(p_ist_id integer, p_ins_number_in character varying, p_ins_date_begin_in date, p_ins_date_end_in date, p_show_active smallint, p_ins_concerning_in character varying) RETURNS TABLE(ins_id integer, ins_type character varying, ins_number character varying, ins_date_sign date, ins_date_from date, ins_date_to date, ins_concerning character varying, ins_inactive integer, attach_idx integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ins_attach_count integer;
  now_date date;
  _rec RECORD;
BEGIN
  p_ins_number_in = upper(p_ins_number_in);
  p_ins_concerning_in = upper(p_ins_concerning_in);
  now_date := CURRENT_DATE;

  FOR _rec IN select ins.ins_id, ins.ins_number, ins.ins_date_sign, ins.ins_date_from, ins.ins_date_to, ins.ins_concerning, ist.ist_name from dcl_instruction ins, dcl_instruction_type ist where ist.p_ist_id = ins.p_ist_id and  ( p_ist_id is null or p_ist_id = -1 or ist.p_ist_id = p_ist_id ) and  ( p_ins_date_begin_in is null or ins_date_from >= p_ins_date_begin_in ) and  ( p_ins_date_end_in is null or ins_date_to <= p_ins_date_end_in ) and  ( p_ins_number_in is null or p_ins_number_in like '' or upper(ins.ins_number) like('%' || p_ins_number_in || '%') ) and  ( p_show_active is null or ins_date_to is null or now_date < ins_date_to ) and  ( p_ins_concerning_in is null or p_ins_concerning_in like '' or upper(ins.ins_concerning) like('%' || p_ins_concerning_in || '%') ) order by ins_date_from desc
  LOOP
    ins_id := _rec.ins_id;
    ins_number := _rec.ins_number;
    ins_date_sign := _rec.ins_date_sign;
    ins_date_from := _rec.ins_date_from;
    ins_date_to := _rec.ins_date_to;
    ins_concerning := _rec.ins_concerning;
    ins_type := _rec.ist_name;
    select count(*) from dcl_attachment where att_parent_id = ins_id and att_parent_table='DCL_INSTRUCTION' into ins_attach_count;

    attach_idx := null;
    if ( ins_attach_count = 0 ) then
     attach_idx := 1;
  END IF;
    if ( ins_attach_count > 0 ) then
     attach_idx := 6;
  END IF;

    ins_inactive := null;
    if ( ins_date_to is not null and now_date >= ins_date_to ) then
      ins_inactive := 1;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_instruction_insert(integer, character varying, date, date, date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_insert(p_ist_id integer, p_ins_number character varying, p_ins_date_sign date, p_ins_date_from date, p_ins_date_to date, p_ins_concerning character varying) RETURNS TABLE(ins_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_instruction (
     p_ist_id,
     p_ins_number,
     p_ins_date_sign,
     p_ins_date_from,
     p_ins_date_to,
     p_ins_concerning
    )
    values (
     p_ist_id,
     p_ins_number,
     p_ins_date_sign,
     p_ins_date_from,
     p_ins_date_to,
     p_ins_concerning
   )
   returning ins_id into ins_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_instruction_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_load(p_ins_id integer) RETURNS TABLE(usr_id_create integer, usr_id_edit integer, ins_create_date timestamp without time zone, ins_edit_date timestamp without time zone, ist_id integer, ist_name character varying, ins_number character varying, ins_date_sign date, ins_date_from date, ins_date_to date, ins_concerning character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  select ins.usr_id_create,
         ins.usr_id_edit,
         ins.ins_create_date,
         ins.ins_edit_date,
         ins.ist_id,
         ist.ist_name,
         ins.ins_number,
         ins.ins_date_sign,
         ins.ins_date_from,
         ins.ins_date_to,
         ins.ins_concerning
  from   dcl_instruction ins,
         dcl_instruction_type ist
  where ins.p_ins_id = p_ins_id and
        ist.ist_id = ins.ist_id
  into  usr_id_create,
        usr_id_edit,
        ins_create_date,
        ins_edit_date,
        ist_id,
        ist_name,
        ins_number,
        ins_date_sign,
        ins_date_from,
        ins_date_to,
        ins_concerning
  ;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_instruction_type_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_instruction_type_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.IST_ID IS NULL) THEN
    NEW.IST_ID = nextval('gen_dcl_instruction_type_id');
  ELSE
        ID = nextval('gen_dcl_instruction_type_id');
        IF ( ID < NEW.IST_ID ) THEN
          ID = nextval('gen_dcl_instruction_type_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_is_have_empty_date_conf(integer, integer, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_is_have_empty_date_conf(p_ord_id integer, p_opr_id integer, p_ord_date_conf_all smallint) RETURNS TABLE(have_empty_date_conf smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_count_ord_prd integer;
  v_count_ord_prd_in_term_tbl integer;
BEGIN
  have_empty_date_conf := NULL;
  IF p_ord_date_conf_all IS NULL THEN
    SELECT COALESCE(SUM(opr.opr_count), 0)
    FROM dcl_ord_list_produce opr
    WHERE opr.ord_id = p_ord_id AND opr.opr_id = COALESCE(p_opr_id, opr.opr_id)
    INTO v_count_ord_prd;

    SELECT COALESCE(SUM(ptr.ptr_count), 0)
    FROM dcl_ord_list_produce opr, dcl_production_term ptr
    WHERE opr.ord_id = p_ord_id AND opr.opr_id = COALESCE(p_opr_id, opr.opr_id)
      AND ptr.opr_id = opr.opr_id AND ptr.ptr_date IS NOT NULL
    INTO v_count_ord_prd_in_term_tbl;

    IF v_count_ord_prd != v_count_ord_prd_in_term_tbl THEN
      have_empty_date_conf := 1;
    END IF;
  END IF;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_is_pay_closed(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_is_pay_closed(p_pay_id integer) RETURNS TABLE(is_pay_closed integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  count_lines_in_doc integer;
  count_in_not_closed integer;
  is_pay_block smallint;
BEGIN
  count_in_not_closed = null;

  select pay_block from dcl_payment where p_pay_id = p_pay_id into is_pay_block;

  select
      count(psum.lps_id)
  from
      dcl_pay_list_summ psum
  where
      psum.p_pay_id = p_pay_id and
      not exists ( select distinct lps_id from dcl_ctc_pay ctc_pay where ctc_pay.lps_id = psum.lps_id )
  into count_in_not_closed;

  select count(psum.lps_id) from dcl_pay_list_summ psum where psum.p_pay_id = p_pay_id into count_lines_in_doc;

  if ( is_pay_block is not null and count_in_not_closed = 0 and count_lines_in_doc > 0 ) then
    is_pay_closed = 1;
  else
    is_pay_closed = null;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_is_shp_closed(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_is_shp_closed(p_shp_id integer) RETURNS TABLE(is_shp_closed integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_have_spec integer;
  v_count_in_not_closed integer;
BEGIN
  SELECT COUNT(shp.shp_id)
  FROM dcl_shipping shp
  WHERE shp.shp_id = p_shp_id
    AND NOT EXISTS (SELECT DISTINCT ctc_shp.shp_id FROM dcl_ctc_shp ctc_shp WHERE ctc_shp.shp_id = p_shp_id)
  INTO v_count_in_not_closed;

  SELECT COUNT(shp.spc_id) FROM dcl_shipping shp WHERE shp.shp_id = p_shp_id INTO v_have_spec;

  IF v_count_in_not_closed = 0 AND v_have_spec > 0 THEN
    is_shp_closed := 1;
  ELSE
    is_shp_closed := NULL;
  END IF;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_is_warm_by_delivery_date(date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_is_warm_by_delivery_date(p_ord_delivery_date date, p_spc_delivery_date date) RETURNS TABLE(is_warn smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  is_warn := NULL;
  IF p_spc_delivery_date IS NULL OR p_ord_delivery_date IS NULL THEN
    is_warn := NULL;
  ELSIF p_spc_delivery_date - p_ord_delivery_date < 14 THEN
    is_warn := 1;
  END IF;
  RETURN NEXT;
END;
$$;


--
-- Name: dcl_language_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_language_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LNG_ID IS NULL) THEN
    NEW.LNG_ID = nextval('gen_dcl_language_id');
  ELSE
        ID = nextval('gen_dcl_language_id');
        IF ( ID < NEW.LNG_ID ) THEN
          ID = nextval('gen_dcl_language_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_log_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_log_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LOG_ID IS NULL) THEN
    NEW.LOG_ID = nextval('gen_dcl_log_id');
  ELSE
    ID = nextval('gen_dcl_log_id');
    IF ( ID < NEW.LOG_ID ) THEN
      ID = nextval('gen_dcl_log_id');
  END IF;
  END IF;

  new.log_time = CURRENT_TIMESTAMP;
  if ( new.usr_id is null ) then
    new.usr_id = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_log_filter(integer, character varying, character varying, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_log_filter(p_act_id integer, p_user_in character varying, p_ip_in character varying, p_date_begin_in date, p_date_end_in date) RETURNS TABLE(log_id integer, log_action character varying, log_user character varying, log_ip character varying, log_time timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_date_end date;
  _rec RECORD;
BEGIN
  p_user_in = upper(p_user_in);
  p_ip_in = upper(p_ip_in);
  v_date_end := p_date_end_in;
  if ( v_date_end is not null ) then
    v_date_end = v_date_end + interval '1 day';
  END IF;

  FOR _rec IN select log.log_id, coalesce(act.act_name, act.act_system_name) as log_action, 
    usr.usr_surname || ' ' || usr.usr_name as log_user, log.log_ip, log.log_time 
    from dcl_log log, dcl_action act, dcl_user_language usr 
    where ( p_act_id is null or act.act_id = p_act_id ) 
    and log.act_id = act.act_id 
    and usr.usr_id = log.usr_id 
    and usr.lng_id = 1 
    and ( p_date_begin_in is null or log.log_time >= p_date_begin_in ) 
    and ( v_date_end is null or log.log_time <= v_date_end ) 
    and ( p_ip_in is null or p_ip_in like '' or upper(log.log_ip) like('%' || p_ip_in || '%') ) 
    and ( p_user_in is null or p_user_in like '' or 
      (select upper(usrl.usr_surname || ' ' || usrl.usr_name) from dcl_user_language usrl where usrl.usr_id = log.usr_id and usrl.lng_id = 1) like('%' || p_user_in || '%') ) 
    order by log.log_time DESC
  LOOP
    log_id := _rec.log_id;
    log_action := _rec.log_action;
    log_user := _rec.log_user;
    log_ip := _rec.log_ip;
    log_time := _rec.log_time;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_log_insert(integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_log_insert(IN p_usr_id integer, IN p_act_id integer, IN p_log_ip character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_act_logging smallint;
BEGIN
  v_act_logging := null;
  SELECT a.act_logging INTO v_act_logging FROM dcl_action a WHERE a.act_id = p_act_id;
  IF (v_act_logging = 1) THEN
    INSERT INTO dcl_log(usr_id, act_id, log_ip) VALUES (p_usr_id, p_act_id, p_log_ip);
  END IF;
END
$$;


--
-- Name: dcl_log_insert_by_act_sys_name(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_log_insert_by_act_sys_name(IN p_act_system_name character varying, IN p_log_ip character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_act_id integer;
  v_act_logging smallint;
BEGIN
  v_act_id := null;
  v_act_logging := null;
  SELECT a.act_id, a.act_logging INTO v_act_id, v_act_logging
  FROM dcl_action a WHERE a.act_system_name = p_act_system_name;
  
  IF (v_act_logging = 1) THEN
    INSERT INTO dcl_log(act_id, log_ip) VALUES (v_act_id, p_log_ip);
  END IF;

  IF (v_act_id IS NULL) THEN
    INSERT INTO dcl_action(act_system_name) VALUES (p_act_system_name);
  END IF;
END
$$;


--
-- Name: dcl_lps_list_manager_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_lps_list_manager_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LMN_ID IS NULL) THEN
    NEW.LMN_ID = nextval('gen_dcl_lps_list_manager_id');
  ELSE
        ID = nextval('gen_dcl_lps_list_manager_id');
        IF ( ID < NEW.LMN_ID ) THEN
          ID = nextval('gen_dcl_lps_list_manager_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_margin(integer, integer, integer, integer, integer, date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_margin(p_dep_id_in integer, p_usr_id_in integer, p_ctr_id_in integer, p_stf_id_in integer, p_rut_id_in integer, p_date_begin date, p_date_end date, p_ctc_block_in smallint) RETURNS TABLE(lcc_id integer, lps_id integer, ctc_id integer, ctc_date date, ctc_block smallint, ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, con_date date, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, cur_id integer, cur_name character varying, stf_id integer, stf_name character varying, shp_id integer, shp_number character varying, shp_date date, pay_id integer, pay_date date, pay_course numeric, lps_summ_eur numeric, lps_summ numeric, lps_sum_transport numeric, lps_custom numeric, lps_summ_plus_nds numeric, lcc_charges numeric, lcc_montage numeric, lcc_transport numeric, lcc_update_sum numeric, lps_montage_time numeric, summ numeric, summ_zak numeric, margin numeric, usr_id integer, usr_name character varying, dep_id integer, dep_name character varying, rut_id integer, rut_name character varying, con_original smallint, spc_original smallint, spc_group_delivery smallint, lpc_id integer, prd_id integer, montage_cost numeric, cut_id integer, cut_name character varying, have_unblocked_prc smallint, shp_original smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lcc_charges_common decimal(15,2);
  lcc_montage_common decimal(15,2);
  lcc_transport_common decimal(15,2);
  lcc_update_sum_common decimal(15,2);
  spc_nds_rate decimal(15,2);
  sum_pay_closed decimal(15,2);
  lmn_percent decimal(3,0);
  mad_mech_total decimal(15,1);
  mad_el_total decimal(15,1);
  unblocked_prc_count integer;
  shp_sum_update decimal(15,2);
  shp_sum_nds decimal(15,2);
  shp_sum_update_row decimal(15,2);
  _rec RECORD;
BEGIN
  FOR _rec IN select dep.dep_id, dep.dep_name, usr.usr_id, usr_lng.usr_surname || ' ' || usr_lng.usr_name, ctcl.lcc_id, ctcl.lcc_charges, ctcl.lcc_montage, ctcl.lcc_transport, ctcl.lcc_update_sum, coalesce(shp.shp_sum_update, 0), coalesce(shp.shp_summ_plus_nds, 0), lps.lps_id, ctc.ctc_id, ctc.ctc_date, ctc.ctc_block, ctr.ctr_id, ctr.ctr_name, ctr.cut_id, con.con_id, con.con_number, con.con_date, con.con_original, spc.spc_id, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_original, spc.spc_group_delivery, spc.spc_nds_rate, cur.cur_id, cur.cur_name, stf.stf_id, stf.stf_name, shp.shp_id, shp.shp_number, shp.shp_date, shp.shp_original, pay.pay_id, pay.pay_date, pay.pay_course, lpc.lpc_sum_transport / lpc.lpc_count * lps.lps_count, lpc.lpc_custom / lpc.lpc_count * lps.lps_count, lps.lps_summ_plus_nds, lps.lps_montage_time, lpc.lpc_cost_one * lps.lps_count, rut.rut_id, rut.rut_name, lmn.lmn_percent, lps.lpc_id from dcl_department dep, dcl_user usr, dcl_user_language usr_lng, dcl_lps_list_manager lmn, dcl_ctc_list ctcl, dcl_contract_closed ctc, dcl_con_list_spec spc, dcl_contract con, dcl_contractor ctr, dcl_currency cur, dcl_shipping shp, dcl_shp_list_produce lps, dcl_stuff_category stf, dcl_pay_list_summ psum, dcl_payment pay, dcl_prc_list_produce lpc, dcl_produce_cost prc, dcl_route rut, dcl_ctc_shp ctc_shp, dcl_ctc_pay ctc_pay where ( p_dep_id_in = -1 or p_dep_id_in is null or dep.dep_id = p_dep_id_in ) and usr.dep_id = dep.dep_id and ( p_usr_id_in = -1 or p_usr_id_in is null or usr.usr_id = p_usr_id_in ) and usr_lng.usr_id = usr.usr_id and usr_lng.lng_id = 1 and lmn.usr_id = usr.usr_id and lps.lps_id = lmn.lps_id and spc.spc_id = ctcl.spc_id and ctc.ctc_id = ctcl.ctc_id and con.con_id = spc.con_id and ( p_ctr_id_in = -1 or p_ctr_id_in is null or ctr.ctr_id = p_ctr_id_in ) and ctr.ctr_id = con.ctr_id and shp.spc_id = spc.spc_id and shp.shp_id = ctc_shp.shp_id and ctc_shp.lcc_id = ctcl.lcc_id and cur.cur_id = con.cur_id and lps.shp_id = shp.shp_id and ( p_stf_id_in = -1 or p_stf_id_in is null or stf.stf_id = p_stf_id_in ) and stf.stf_id = lps.stf_id and psum.spc_id = spc.spc_id and psum.lps_id = ctc_pay.lps_id and ctc_pay.lcc_id = ctcl.lcc_id and pay.pay_id = psum.pay_id and lpc.lpc_id = lps.lpc_id and prc.prc_id = lpc.prc_id and ( rut.rut_id = p_rut_id_in or p_rut_id_in = -1 or p_rut_id_in is null ) and rut.rut_id = prc.rut_id and ( ctc.ctc_date >= p_date_begin and ctc.ctc_date <= p_date_end ) and ( p_ctc_block_in is null or ctc.ctc_block = p_ctc_block_in )
  LOOP
    dep_id := _rec.dep_id;
    dep_name := _rec.dep_name;
    usr_id := _rec.usr_id;
    usr_name := _rec.usr_name;
    lcc_id := _rec.lcc_id;
    lcc_charges_common := _rec.lcc_charges;
    lcc_montage_common := _rec.lcc_montage;
    lcc_transport_common := _rec.lcc_transport;
    lcc_update_sum_common := _rec.lcc_update_sum;
    shp_sum_update := _rec.lps_id;
    shp_sum_nds := _rec.ctc_id;
    lps_id := _rec.ctc_date;
    ctc_id := _rec.ctc_block;
    ctc_date := _rec.ctr_id;
    ctc_block := _rec.ctr_name;
    ctr_id := _rec.cut_id;
    ctr_name := _rec.con_id;
    cut_id := _rec.con_number;
    con_id := _rec.con_date;
    con_number := _rec.con_original;
    con_date := _rec.spc_id;
    con_original := _rec.spc_number;
    spc_id := _rec.spc_date;
    spc_number := _rec.spc_summ;
    spc_date := _rec.spc_original;
    spc_summ := _rec.spc_group_delivery;
    spc_original := _rec.spc_nds_rate;
    spc_group_delivery := _rec.cur_id;
    spc_nds_rate := _rec.cur_name;
    cur_id := _rec.stf_id;
    cur_name := _rec.stf_name;
    stf_id := _rec.shp_id;
    stf_name := _rec.shp_number;
    shp_id := _rec.shp_date;
    shp_number := _rec.shp_original;
    shp_date := _rec.pay_id;
    shp_original := _rec.pay_date;
    pay_id := _rec.pay_course;
    pay_date := _rec.lps_count;
    pay_course := _rec.lps_count;
    lps_sum_transport := _rec.lps_summ_plus_nds;
    lps_custom := _rec.lps_montage_time;
    lps_summ_plus_nds := _rec.lps_count;
    lps_montage_time := _rec.rut_id;
    summ_zak := _rec.rut_name;
    rut_id := _rec.lmn_percent;
    rut_name := _rec.lpc_id;
    lmn_percent := _rec.lmn_percent;
    lpc_id := _rec.lpc_id;
    cut_name := null;
    IF ( cut_id is not null ) THEN
      SELECT cut_name INTO cut_name FROM dcl_country where cut_id = cut_id;
    END IF;
    prd_id := null;
    SELECT prd_id INTO prd_id FROM dcl_prc_list_produce where lpc_id = lpc_id;

    mad_mech_total := 0.0;
    mad_el_total := 0.0;
    SELECT coalesce(madh.mad_mech_total, 0), coalesce(madh.mad_el_total, 0)
      INTO mad_mech_total, mad_el_total
      from   dcl_montage_adjustment mad left join dcl_montage_adjustment_h madh on ( madh.mad_id = mad.mad_id and madh.mad_date_from = ( select max(mad_date_from) from dcl_montage_adjustment_h where mad_id = mad.mad_id and mad_date_from <= shp_date ) ) where  mad.mad_id = ( select mad_id from dcl_catalog_number where prd_id = prd_id and stf_id = stf_id );
    montage_cost := mad_mech_total + mad_el_total;

    SELECT summ_eur INTO lps_summ_eur FROM dcl_get_row_summ_eur(lcc_id, lps_summ_plus_nds);
    SELECT summ_out_nds INTO lps_summ FROM dcl_get_row_summ_out_nds(lps_summ_eur, spc_nds_rate);

    SELECT sum(pls.lps_summ)
      INTO sum_pay_closed
      from dcl_pay_list_summ pls, dcl_ctc_pay ctc_pay where ctc_pay.lcc_id = lcc_id and pls.lps_id = ctc_pay.lps_id;

    SELECT summ_row INTO lcc_charges FROM dcl_get_row_sum(sum_pay_closed, lps_summ_plus_nds, lcc_charges_common);
    SELECT summ_row INTO lcc_montage FROM dcl_get_row_sum(sum_pay_closed, lps_summ_plus_nds, lcc_montage_common);
    SELECT summ_row INTO lcc_transport FROM dcl_get_row_sum(sum_pay_closed, lps_summ_plus_nds, lcc_transport_common);
    SELECT summ_row INTO lcc_update_sum FROM dcl_get_row_sum(sum_pay_closed, lps_summ_plus_nds, lcc_update_sum_common);

    SELECT summ_row INTO shp_sum_update_row FROM dcl_get_row_sum(shp_sum_nds, lps_summ_plus_nds, shp_sum_update);
    lcc_update_sum := lcc_update_sum + shp_sum_update_row;

    IF ( lmn_percent != 100 ) THEN
      --lps_summ_plus_nds = lps_summ_plus_nds * lmn_percent / 100;
      lps_summ_eur := lps_summ_eur * lmn_percent / 100;
      lps_summ := lps_summ * lmn_percent / 100;
      lps_sum_transport := lps_sum_transport * lmn_percent / 100;
      lps_custom := lps_custom * lmn_percent / 100;
      lps_montage_time := lps_montage_time * lmn_percent / 100;
      summ_zak := summ_zak * lmn_percent / 100;

      sum_pay_closed := sum_pay_closed * lmn_percent / 100;
      lcc_charges := lcc_charges * lmn_percent / 100;
      lcc_montage := lcc_montage * lmn_percent / 100;
      lcc_transport := lcc_transport * lmn_percent / 100;
      lcc_update_sum := lcc_update_sum * lmn_percent / 100;

      montage_cost := montage_cost * lmn_percent / 100;
    END IF;
    summ := lps_summ - lps_sum_transport - lps_custom - lcc_charges - lcc_montage - lcc_transport - lcc_update_sum/* - montage_cost*/;
    margin := summ - summ_zak;

    have_unblocked_prc := null;

    SELECT coalesce(count(lps.lps_id), 0)
      INTO unblocked_prc_count
      from dcl_ctc_shp cshp, dcl_shp_list_produce lps, dcl_prc_list_produce lpc, dcl_produce_cost prc where cshp.lcc_id = lcc_id and lps.shp_id = cshp.shp_id and lpc.lpc_id = lps.lpc_id and prc.prc_id = lpc.prc_id and prc.prc_block is null;

    IF ( unblocked_prc_count != 0 ) THEN
      have_unblocked_prc := 1;
    END IF;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_margin1(integer, integer, integer, integer, integer, date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_margin1(p_dep_id_in integer, p_usr_id_in integer, p_ctr_id_in integer, p_stf_id_in integer, p_rut_id_in integer, p_date_begin date, p_date_end date, p_ctc_block_in smallint) RETURNS TABLE(lps_id integer, ctc_date date, ctc_block smallint, ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, con_date date, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, cur_id integer, cur_name character varying, stf_id integer, stf_name character varying, shp_id integer, shp_number character varying, shp_date date, lps_summ_eur numeric, lps_summ numeric, lps_sum_transport numeric, lps_custom numeric, lps_summ_plus_nds numeric, lcc_charges numeric, lcc_montage numeric, lcc_transport numeric, lcc_update_sum numeric, lps_montage_time numeric, summ numeric, summ_zak numeric, margin numeric, usr_id integer, usr_name character varying, dep_id integer, dep_name character varying, rut_id integer, rut_name character varying, con_original smallint, spc_original smallint, spc_group_delivery smallint, montage_cost numeric, cut_id integer, cut_name character varying, have_unblocked_prc smallint, shp_original smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select lps_id, ctc_date, ctc_block, ctr_id, ctr_name, cut_id, cut_name, con_id, con_number, con_date, spc_id, spc_number, spc_date, spc_summ, cur_id, cur_name, stf_id, stf_name, shp_id, shp_number, shp_date, shp_original, lps_summ_eur, lps_summ, lps_sum_transport, lps_custom, lps_summ_plus_nds, lcc_charges, lcc_montage, lcc_transport, lcc_update_sum, lps_montage_time, summ, summ_zak, margin, usr_id, usr_name, dep_id, dep_name, rut_id, rut_name, con_original, spc_original, spc_group_delivery, montage_cost, have_unblocked_prc from dcl_margin(p_dep_id_in, p_usr_id_in, p_ctr_id_in, p_stf_id_in, p_rut_id_in, p_date_begin, p_date_end, p_ctc_block_in) group by lps_id, ctc_date, ctc_block, ctr_id, ctr_name, cut_id, cut_name, con_id, con_number, con_date, spc_id, spc_number, spc_date, spc_summ, cur_id, cur_name, stf_id, stf_name, shp_id, shp_number, shp_date, shp_original, lps_summ_eur, lps_summ, lps_sum_transport, lps_custom, lps_summ_plus_nds, lcc_charges, lcc_montage, lcc_transport, lcc_update_sum, lps_montage_time, summ, summ_zak, margin, usr_id, usr_name, dep_id, dep_name, rut_id, rut_name, con_original, spc_original, spc_group_delivery, montage_cost, have_unblocked_prc
  LOOP
    lps_id := _rec.lps_id;
    ctc_date := _rec.ctc_date;
    ctc_block := _rec.ctc_block;
    ctr_id := _rec.ctr_id;
    ctr_name := _rec.ctr_name;
    cut_id := _rec.cut_id;
    cut_name := _rec.cut_name;
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    spc_id := _rec.spc_id;
    spc_number := _rec.spc_number;
    spc_date := _rec.spc_date;
    spc_summ := _rec.spc_summ;
    cur_id := _rec.cur_id;
    cur_name := _rec.cur_name;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    shp_id := _rec.shp_id;
    shp_number := _rec.shp_number;
    shp_date := _rec.shp_date;
    shp_original := _rec.shp_original;
    lps_summ_eur := _rec.lps_summ_eur;
    lps_summ := _rec.lps_summ;
    lps_sum_transport := _rec.lps_sum_transport;
    lps_custom := _rec.lps_custom;
    lps_summ_plus_nds := _rec.lps_summ_plus_nds;
    lcc_charges := _rec.lcc_charges;
    lcc_montage := _rec.lcc_montage;
    lcc_transport := _rec.lcc_transport;
    lcc_update_sum := _rec.lcc_update_sum;
    lps_montage_time := _rec.lps_montage_time;
    summ := _rec.summ;
    summ_zak := _rec.summ_zak;
    margin := _rec.margin;
    usr_id := _rec.usr_id;
    usr_name := _rec.usr_name;
    dep_id := _rec.dep_id;
    dep_name := _rec.dep_name;
    rut_id := _rec.rut_id;
    rut_name := _rec.rut_name;
    con_original := _rec.con_original;
    spc_original := _rec.spc_original;
    spc_group_delivery := _rec.spc_group_delivery;
    montage_cost := _rec.montage_cost;
    have_unblocked_prc := _rec.have_unblocked_prc;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_montage_adjustment_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_montage_adjustment_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.MAD_ID IS NULL) THEN
    NEW.MAD_ID = nextval('gen_dcl_montage_adjustment_id');
  ELSE
        ID = nextval('gen_dcl_montage_adjustment_id');
        IF ( ID < NEW.MAD_ID ) THEN
          ID = nextval('gen_dcl_montage_adjustment_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_montage_adjustment_h_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_montage_adjustment_h_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.MADH_ID IS NULL) THEN
    NEW.MADH_ID = nextval('gen_dcl_montage_adjustment_h_id');
  ELSE
        ID = nextval('gen_dcl_montage_adjustment_h_id');
        IF ( ID < NEW.MADH_ID ) THEN
          ID = nextval('gen_dcl_montage_adjustment_h_id');
  END IF;
  END IF;

  NEW.MAD_MECH_TOTAL = (NEW.MAD_MECH_WORK_TARIFF * (NEW.MAD_MECH_WORK_RULE_MONTAGE + NEW.MAD_MECH_WORK_RULE_ADJUSTMENT)) + ( NEW.MAD_MECH_ROAD_TARIFF * NEW.MAD_MECH_ROAD_RULE );
  NEW.MAD_EL_TOTAL = (NEW.MAD_EL_WORK_TARIFF * (NEW.MAD_EL_WORK_RULE_MONTAGE + NEW.MAD_EL_WORK_RULE_ADJUSTMENT)) + ( NEW.MAD_EL_ROAD_TARIFF * NEW.MAD_EL_ROAD_RULE );
RETURN NEW;
END
$$;


--
-- Name: dcl_montage_adjustment_h_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_montage_adjustment_h_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.MAD_MECH_TOTAL = (NEW.MAD_MECH_WORK_TARIFF * (NEW.MAD_MECH_WORK_RULE_MONTAGE + NEW.MAD_MECH_WORK_RULE_ADJUSTMENT)) + ( NEW.MAD_MECH_ROAD_TARIFF * NEW.MAD_MECH_ROAD_RULE );
  NEW.MAD_EL_TOTAL = (NEW.MAD_EL_WORK_TARIFF * (NEW.MAD_EL_WORK_RULE_MONTAGE + NEW.MAD_EL_WORK_RULE_ADJUSTMENT)) + ( NEW.MAD_EL_ROAD_TARIFF * NEW.MAD_EL_ROAD_RULE );
RETURN NEW;
END
$$;


--
-- Name: dcl_montage_adjustment_insert(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_montage_adjustment_insert(p_stf_id integer, p_mad_machine_type character varying, p_mad_complexity character varying) RETURNS TABLE(mad_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_montage_adjustment (
    p_stf_id,
    p_mad_machine_type,
    p_mad_complexity
  )
  values(
    p_stf_id,
    p_mad_machine_type,
    p_mad_complexity
  )
  returning mad_id into mad_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_movement_load(integer, integer, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_movement_load(p_prd_id integer, p_stf_id integer, p_koef numeric, p_opr_parent_id_in integer) RETURNS TABLE(shp_id integer, shp_date date, shp_number character varying, shp_produce_cnt numeric, shp_contractor character varying, lpc_id integer, prc_id integer, prc_date date, prc_number character varying, prc_produce_cnt numeric, prc_produce_cnt_rest numeric, lpc_1c_number character varying, asm_id integer, dlr_id integer, spi_id integer, trn_id integer, trn_date date, trn_number character varying, trn_produce_cnt numeric, trn_produce_cnt_rest numeric, dlr_minsk smallint, opr_id integer, ord_id integer, ord_number character varying, ord_date date, ord_executed_date date, ord_produce_cnt numeric, ord_produce_cnt_executed numeric, ord_produce_cnt_rest numeric, ord_annul smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  apr_id integer;
  drp_id integer;
  sip_id integer;
  opr_parent_id integer;
  prd_id_inner integer;
  opr_count decimal(15,2);
  koef_inner decimal(15,5);
  shp_count integer;
  asm_type smallint;
  _rec9 RECORD;
  _rec3 RECORD;
  _rec RECORD;
  _rec7 RECORD;
  _rec5 RECORD;
  _rec4 RECORD;
  _rec2 RECORD;
  _rec8 RECORD;
  _rec6 RECORD;
BEGIN
  -- prc & shipping & chains
  FOR _rec IN select lpc.lpc_id, prc.prc_id, prc.prc_date, prc.prc_number, lpc.lpc_count, lpc.lpc_count - (select coalesce(sum(lps_count), 0) from dcl_shp_list_produce where lpc_id = lpc.lpc_id), lpc.lpc_1c_number, lpc.asm_id, lpc.apr_id, lpc.drp_id, lpc.sip_id, lpc.opr_id from dcl_prc_list_produce lpc, dcl_produce_cost prc where prc.prc_id = lpc.prc_id and lpc.stf_id = p_stf_id and lpc.prd_id = p_prd_id order by prc_date
  LOOP
    lpc_id := _rec.lpc_id;
    prc_id := _rec.prc_id;
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
    prc_produce_cnt := _rec.lpc_count;
    prc_produce_cnt_rest := _rec.lpc_1c_number;
    lpc_1c_number := _rec.asm_id;
    asm_id := _rec.apr_id;
    apr_id := _rec.drp_id;
    drp_id := _rec.sip_id;
    sip_id := _rec.opr_id;
    opr_id := _rec.opr_id;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (asm_id is not null) THEN
  SELECT asm.asm_id,
asm.asm_id,
asm.asm_number,
asm.asm_date,
asm.asm_count,
(
asm.asm_count -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.asm_id = asm_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.asm_id = asm_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
)
),
asm.asm_type
    INTO asm_id,
trn_id,
trn_number,
trn_date,
trn_produce_cnt,
trn_produce_cnt_rest,
asm_type
    from dcl_assemble asm
where asm.asm_id = asm_id;

  if (asm_type = 1) THEN
  trn_produce_cnt_rest := 0;
  END IF;
  END IF;
  if (apr_id is not null) THEN
  SELECT asm.asm_id,
asm.asm_number,
asm.asm_date,
apr.apr_id,
apr.apr_count * asm.asm_count,
(
apr.apr_count * asm.asm_count -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.apr_id = apr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
)
),
asm_type
    INTO asm_id,
trn_number,
trn_date,
trn_id,
trn_produce_cnt,
trn_produce_cnt_rest,
asm_type
    from dcl_asm_list_produce apr,
dcl_assemble asm
where apr.apr_id = apr_id and
asm.asm_id = apr.asm_id;

  if (asm_type = 0) THEN
  trn_produce_cnt_rest := 0;
  END IF;
  END IF;
  if (drp_id is not null) THEN
  SELECT dlr.dlr_id,
dlr.dlr_number,
dlr.dlr_date,
dlr.dlr_minsk,
drp.drp_id,
drp.drp_count
    INTO dlr_id,
trn_number,
trn_date,
dlr_minsk,
trn_id,
trn_produce_cnt
    from dcl_dlr_list_produce drp,
dcl_delivery_request dlr
where drp.drp_id = drp_id and
dlr.dlr_id = drp.dlr_id and
(dlr.dlr_need_deliver is null or dlr.dlr_need_deliver = 0);
  if (dlr_minsk = 0) THEN
  SELECT (drp.drp_count -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.drp_id = drp_id ) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.drp_id = drp_id ))
    INTO trn_produce_cnt_rest
    from dcl_dlr_list_produce drp,
dcl_delivery_request dlr
where drp.drp_id = drp_id and
dlr.dlr_id = drp.dlr_id;
  END IF;
  END IF;
  if (sip_id is not null) THEN
  SELECT spi.spi_id,
spi.spi_number,
spi.spi_date,
sip.sip_id,
sip.sip_count,
(sip.sip_count -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip_id )
)
    INTO spi_id,
trn_number,
trn_date,
trn_id,
trn_produce_cnt,
trn_produce_cnt_rest
    from dcl_spi_list_produce sip,
dcl_specification_import spi
where sip.sip_id = sip_id and
spi.spi_id = sip.spi_id;
  END IF;
  if (opr_id is null) THEN
  SELECT opr_id
    INTO opr_id
    from dcl_get_opr_id_by_lpc(asm_id, apr_id, drp_id, sip_id);
  END IF;
  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
(  select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;

  SELECT count(lps_id)
    INTO shp_count
    from dcl_shp_list_produce where lpc_id = lpc_id;

  if (shp_count = 0) THEN
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  ELSE
  FOR _rec2 IN select shp.shp_id, shp.shp_date, shp.shp_number, ctr.ctr_name, coalesce(sum(lps.lps_count), 0) from dcl_shp_list_produce lps, dcl_shipping shp, dcl_contractor ctr where shp.shp_id = lps.shp_id and lps.lpc_id = lpc_id and ctr.ctr_id = shp.ctr_id group by 1, 2, 3, 4 order by shp_date
  LOOP
    shp_id := _rec2.shp_id;
    shp_date := _rec2.shp_date;
    shp_number := _rec2.shp_number;
    shp_contractor := _rec2.ctr_name;
    shp_produce_cnt := _rec2.shp_produce_cnt;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;

  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  END LOOP;
  END IF;
  END LOOP;

  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  -- last transit doc is disassemble
  FOR _rec3 IN select asm.asm_id, asm.asm_id, asm.asm_number, asm.asm_date, asm.asm_count, ( asm.asm_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.asm_id = asm.asm_id ) - ( select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.asm_id = asm.asm_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) ), asm.opr_id, asm.asm_type from dcl_assemble asm where asm.prd_id = p_prd_id and asm.stf_id = p_stf_id and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.asm_id = asm.asm_id ) = 0 and ( select count(drp_id) from  dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.asm_id = asm.asm_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) = 0
  LOOP
    asm_id := _rec3.asm_id;
    trn_id := _rec3.asm_id;
    trn_number := _rec3.asm_number;
    trn_date := _rec3.asm_date;
    trn_produce_cnt := _rec3.asm_count;
    trn_produce_cnt_rest := _rec3.opr_id;
    opr_id := _rec3.asm_type;
    asm_type := _rec3.asm_type;
  if (asm_type = 1) THEN
  trn_produce_cnt_rest := 0;
  END IF;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  END LOOP;

  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  -- last transit doc is assemble
  FOR _rec4 IN select asm.asm_id, apr.apr_id, asm.asm_number, asm.asm_date, apr.apr_count * asm.asm_count, ( apr.apr_count * asm.asm_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id ) - ( select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) ), apr.opr_id, asm.asm_type from dcl_asm_list_produce apr, dcl_assemble asm, dcl_ord_list_produce opr, dcl_order ord where apr.prd_id = p_prd_id and asm.asm_id = apr.asm_id and opr.opr_id = apr.opr_id and ord.ord_id = opr.ord_id and ord.stf_id = p_stf_id and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.apr_id = apr.apr_id ) = 0 and ( select count(drp_id) from  dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.apr_id = apr.apr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) = 0
  LOOP
    asm_id := _rec4.asm_id;
    trn_id := _rec4.apr_id;
    trn_number := _rec4.asm_number;
    trn_date := _rec4.asm_date;
    trn_produce_cnt := _rec4.asm_count;
    trn_produce_cnt_rest := _rec4.opr_id;
    opr_id := _rec4.asm_type;
    asm_type := _rec4.asm_type;
  if (asm_type = 0) THEN
  trn_produce_cnt_rest := 0;
  END IF;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  END LOOP;



  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;


  -- last transit doc is specification import (from delivery request)
  FOR _rec5 IN select spi.spi_id, spi.spi_number, spi.spi_date, sip.sip_id, sip.sip_count, (sip.sip_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) ), drp.opr_id from dcl_spi_list_produce sip, dcl_dlr_list_produce drp, dcl_specification_import spi where sip.prd_id = p_prd_id and drp.drp_id = sip.drp_id and drp.stf_id = p_stf_id and spi.spi_id = sip.spi_id and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) = 0 and ( select count(drp_id) from  dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.sip_id = sip.sip_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) = 0
  LOOP
    spi_id := _rec5.spi_id;
    trn_number := _rec5.spi_number;
    trn_date := _rec5.spi_date;
    trn_id := _rec5.sip_id;
    trn_produce_cnt := _rec5.sip_count;
    trn_produce_cnt_rest := _rec5.opr_id;
    opr_id := _rec5.opr_id;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  END LOOP;


  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;


  -- last transit doc is specification import (from order)
  FOR _rec6 IN select spi.spi_id, spi.spi_number, spi.spi_date, sip.sip_id, sip.sip_count, (sip.sip_count - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) ), opr.opr_id from dcl_spi_list_produce sip, dcl_ord_list_produce opr, dcl_order ord, dcl_specification_import spi where sip.prd_id = p_prd_id and opr.opr_id = sip.opr_id and ord.ord_id = opr.ord_id and ord.stf_id = p_stf_id and spi.spi_id = sip.spi_id and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.sip_id = sip.sip_id ) = 0 and ( select count(drp_id) from  dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.sip_id = sip.sip_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) = 0
  LOOP
    spi_id := _rec6.spi_id;
    trn_number := _rec6.spi_number;
    trn_date := _rec6.spi_date;
    trn_id := _rec6.sip_id;
    trn_produce_cnt := _rec6.sip_count;
    trn_produce_cnt_rest := _rec6.opr_id;
    opr_id := _rec6.opr_id;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  END LOOP;

  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;


  -- last transit doc is delivery request
  FOR _rec7 IN select dlr.dlr_id, dlr.dlr_number, dlr.dlr_date, dlr.dlr_minsk, drp.drp_id, drp.drp_count, drp.opr_id from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.prd_id = p_prd_id and drp.stf_id = p_stf_id and dlr.dlr_id = drp.dlr_id and (dlr.dlr_need_deliver is null or dlr.dlr_need_deliver = 0)and dlr.dlr_annul is null and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.drp_id = drp.drp_id ) = 0 and ( select count(sip_id) from  dcl_spi_list_produce sip where sip.drp_id = drp.drp_id ) = 0
  LOOP
    dlr_id := _rec7.dlr_id;
    trn_number := _rec7.dlr_number;
    trn_date := _rec7.dlr_date;
    dlr_minsk := _rec7.dlr_minsk;
    trn_id := _rec7.drp_id;
    trn_produce_cnt := _rec7.drp_count;
    opr_id := _rec7.opr_id;
  if (dlr_minsk = 0) THEN
  SELECT (drp.drp_count -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.drp_id = drp.drp_id ) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.drp_id = drp.drp_id ))
    INTO trn_produce_cnt_rest
    from dcl_dlr_list_produce drp,
dcl_delivery_request dlr
where drp.prd_id = p_prd_id and
drp.stf_id = p_stf_id and
dlr.dlr_id = drp.dlr_id and
(dlr.dlr_need_deliver is null or dlr.dlr_need_deliver = 0) and
dlr.dlr_annul is null and
dlr.dlr_id=dlr_id
and
(
select count(lpc_id)
from  dcl_prc_list_produce lpc
where lpc.drp_id = drp.drp_id
) = 0
and
(
select count(sip_id)
from  dcl_spi_list_produce sip
where sip.drp_id = drp.drp_id
) = 0;
  END IF;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  if (opr_id is not null) THEN
  SELECT ord.ord_id,
ord.ord_date,
ord.ord_number,
ord.ord_executed_date,
opr.opr_count,
( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ),
(
(select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr_id and exe.opr_fictive_executed is null ) -
(select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr_id ) -
(
select coalesce(sum(drp.drp_count), 0)
from dcl_dlr_list_produce drp, dcl_delivery_request dlr
where drp.opr_id = opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null
) -
(select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr_id ) -
(select out_count from dcl_get_count_opr_used_in_asm(opr_id) )
),
ord.ord_annul
    INTO ord_id,
ord_date,
ord_number,
ord_executed_date,
ord_produce_cnt,
ord_produce_cnt_executed,
ord_produce_cnt_rest,
ord_annul
    from
dcl_order ord,
dcl_ord_list_produce opr
where
opr.opr_id = opr_id and
ord.ord_id = opr.ord_id;
  END IF;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;

  RETURN NEXT;
  END LOOP;


  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;
  ord_id := null;
  ord_date := null;
  ord_number := null;
  ord_executed_date := null;
  ord_produce_cnt := null;
  ord_produce_cnt_executed := null;
  ord_produce_cnt_rest := null;
  ord_annul := null;

  -- last doc is order
  FOR _rec8 IN select ord.ord_id, ord.ord_date, ord.ord_number, ord.ord_executed_date, opr.opr_count, ( select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ), ( (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ) - (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) - ( select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) - (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) - (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) ) ), ord.ord_annul, opr.opr_parent_id from dcl_order ord, dcl_ord_list_produce opr where ord.ord_id = opr.ord_id and opr.prd_id = p_prd_id and ord.stf_id = p_stf_id and ( select count(lpc_id) from  dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id ) = 0 and ( select count(asm_id) from  dcl_assemble asm where asm.opr_id = opr.opr_id ) = 0 and ( select count(apr_id) from  dcl_asm_list_produce apr where apr.opr_id = opr.opr_id ) = 0 and ( select count(sip_id) from  dcl_spi_list_produce sip where sip.opr_id = opr.opr_id ) = 0 and ( select count(drp_id) from  dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null ) = 0 and ((p_opr_parent_id_in is null and opr.opr_parent_id is null) or opr.opr_parent_id = p_opr_parent_id_in)
  LOOP
    ord_id := _rec8.ord_id;
    ord_date := _rec8.ord_date;
    ord_number := _rec8.ord_number;
    ord_executed_date := _rec8.ord_executed_date;
    ord_produce_cnt := _rec8.opr_count;
    ord_produce_cnt_executed := _rec8.ord_annul;
    ord_produce_cnt_rest := _rec8.opr_parent_id;
    ord_annul := _rec8.ord_annul;
    opr_parent_id := _rec8.opr_parent_id;
  shp_id := null;
  shp_date := null;
  shp_number := null;
  shp_produce_cnt := null;
  shp_contractor := null;
  lpc_id := null;
  prc_id := null;
  prc_date := null;
  prc_number := null;
  prc_produce_cnt := null;
  prc_produce_cnt_rest := null;
  lpc_1c_number := null;
  asm_id := null;
  apr_id := null;
  drp_id := null;
  sip_id := null;
  opr_id := null;
  dlr_id := null;
  spi_id := null;
  trn_id := null;
  trn_number := null;
  trn_date := null;
  trn_produce_cnt := null;
  trn_produce_cnt_rest := null;
  dlr_minsk := null;

  if (opr_parent_id is not null) THEN
  SELECT p_prd_id, opr_count
    INTO prd_id_inner, opr_count
    from dcl_ord_list_produce opr where opr.opr_id = opr_parent_id;
  koef_inner := 1;
  if (ord_produce_cnt is not null and ord_produce_cnt != 0) THEN
  koef_inner := ord_produce_cnt / opr_count;
  END IF;
  FOR _rec9 IN select prc_id, prc_date, prc_number, prc_produce_cnt, prc_produce_cnt_rest, lpc_1c_number, shp_id, shp_date, shp_number, shp_produce_cnt, shp_contractor, asm_id, dlr_id, spi_id, trn_id, trn_number, trn_date, trn_produce_cnt, trn_produce_cnt_rest, dlr_minsk, opr_id, ord_id, ord_date, ord_number, ord_executed_date, ord_produce_cnt, ord_produce_cnt_executed, ord_produce_cnt_rest, ord_annul from dcl_movement_load(prd_id_inner, p_stf_id, koef_inner, opr_parent_id) p where p.ord_id = ord_id
  LOOP
    prc_id := _rec9.prc_id;
    prc_date := _rec9.prc_date;
    prc_number := _rec9.prc_number;
    prc_produce_cnt := _rec9.prc_produce_cnt;
    prc_produce_cnt_rest := _rec9.prc_produce_cnt_rest;
    lpc_1c_number := _rec9.lpc_1c_number;
    shp_id := _rec9.shp_id;
    shp_date := _rec9.shp_date;
    shp_number := _rec9.shp_number;
    shp_produce_cnt := _rec9.shp_produce_cnt;
    shp_contractor := _rec9.shp_contractor;
    asm_id := _rec9.asm_id;
    dlr_id := _rec9.dlr_id;
    spi_id := _rec9.spi_id;
    trn_id := _rec9.trn_id;
    trn_number := _rec9.trn_number;
    trn_date := _rec9.trn_date;
    trn_produce_cnt := _rec9.trn_produce_cnt;
    trn_produce_cnt_rest := _rec9.trn_produce_cnt_rest;
    dlr_minsk := _rec9.dlr_minsk;
    opr_id := _rec9.opr_id;
    ord_id := _rec9.ord_id;
    ord_date := _rec9.ord_date;
    ord_number := _rec9.ord_number;
    ord_executed_date := _rec9.ord_executed_date;
    ord_produce_cnt := _rec9.ord_produce_cnt;
    ord_produce_cnt_executed := _rec9.ord_produce_cnt_executed;
    ord_produce_cnt_rest := _rec9.ord_produce_cnt_rest;
    ord_annul := _rec9.ord_annul;
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;
  ord_produce_cnt := ord_produce_cnt * koef_inner;
  ord_produce_cnt_rest := ord_produce_cnt_rest * koef_inner;
  ord_produce_cnt_executed := ord_produce_cnt_executed * koef_inner;
  RETURN NEXT;
  END LOOP;
  ELSE
  prc_produce_cnt := prc_produce_cnt * p_koef;
  prc_produce_cnt_rest := prc_produce_cnt_rest * p_koef;
  shp_produce_cnt := shp_produce_cnt * p_koef;
  trn_produce_cnt := trn_produce_cnt * p_koef;
  RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_ord_list_pay_sum_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_pay_sum_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.OPS_ID IS NULL) THEN
    NEW.OPS_ID = nextval('gen_dcl_ord_list_pay_sum_id');
  ELSE
        ID = nextval('gen_dcl_ord_list_pay_sum_id');
        IF ( ID < NEW.OPS_ID ) THEN
          ID = nextval('gen_dcl_ord_list_pay_sum_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ord_list_payment_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_payment_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ORP_ID IS NULL) THEN
    NEW.ORP_ID = nextval('gen_dcl_ord_list_payment_id');
  ELSE
        ID = nextval('gen_dcl_ord_list_payment_id');
        IF ( ID < NEW.ORP_ID ) THEN
          ID = nextval('gen_dcl_ord_list_payment_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ord_list_prd_load_parent(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_prd_load_parent(p_opr_parent_id_in integer) RETURNS TABLE(opr_id integer, prd_id integer, stf_id integer, opr_count_executed integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  FOR opr_id IN select opr_id from dcl_ord_list_produce opr where opr.opr_parent_id = p_opr_parent_id_in order by opr_id
  LOOP
    select
      opr_id,
      prd_id,
      stf_id,
      opr_count_executed
    from dcl_ord_list_produce_load(opr_id)
    into
      opr_id,
      prd_id,
      stf_id,
      opr_count_executed
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_ord_list_produce_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_produce_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  usr_count integer;
  usr_id integer;
BEGIN
  if (new.ctr_id is not null) then
    select usr_id from get_context into usr_id;
    select count(usr_id) from dcl_contractor_user t where t.usr_id = usr_id and t.ctr_id = new.ctr_id into usr_count;
    if (usr_count = 0) then
      insert into dcl_contractor_user (ctr_id, usr_id) values (new.ctr_id, usr_id);
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ord_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.OPR_ID IS NULL) THEN
    NEW.OPR_ID = nextval('gen_dcl_ord_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_ord_list_produce_id');
        IF ( ID < NEW.OPR_ID ) THEN
          ID = nextval('gen_dcl_ord_list_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ord_list_produce_insert(integer, character varying, character varying, numeric, numeric, numeric, numeric, numeric, character, integer, character varying, numeric, integer, integer, integer, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_produce_insert(p_ord_id integer, p_opr_produce_name character varying, p_opr_catalog_num character varying, p_opr_count numeric, p_opr_price_brutto numeric, p_opr_discount numeric, p_opr_price_netto numeric, p_opr_summ numeric, p_opr_use_prev_number character, p_prd_id integer, p_opr_comment character varying, p_drp_price numeric, p_ctr_id integer, p_spc_id integer, p_opr_parent_id integer, p_opr_have_depend smallint, p_drp_max_extra smallint) RETURNS TABLE(opr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_ord_list_produce (
      p_ord_id,
      p_opr_produce_name,
      p_opr_catalog_num,
      p_opr_count,
      p_opr_price_brutto,
      p_opr_discount,
      p_opr_price_netto,
      p_opr_summ,
      p_opr_use_prev_number,
      p_prd_id,
      p_opr_comment,
      p_drp_price,
      p_ctr_id,
      p_spc_id,
      p_opr_parent_id,
      p_opr_have_depend,
      p_drp_max_extra
  )
  values (
      p_ord_id,
      p_opr_produce_name,
      p_opr_catalog_num,
      p_opr_count,
      p_opr_price_brutto,
      p_opr_discount,
      p_opr_price_netto,
      p_opr_summ,
      p_opr_use_prev_number,
      p_prd_id,
      p_opr_comment,
      p_drp_price,
      p_ctr_id,
      p_spc_id,
      p_opr_parent_id,
      p_opr_have_depend,
      p_drp_max_extra
  )
  returning opr_id into opr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_ord_list_produce_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_produce_load(p_opr_id_in integer) RETURNS TABLE(opr_id integer, ord_id integer, opr_produce_name character varying, opr_catalog_num character varying, opr_count numeric, opr_price_brutto numeric, opr_discount numeric, opr_price_netto numeric, opr_summ numeric, opr_use_prev_number character, prd_id integer, prd_block smallint, opr_count_executed numeric, opr_comment character varying, drp_price numeric, ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, con_date date, cur_name character varying, spc_id integer, spc_number character varying, spc_date character varying, spc_delivery_date date, stf_id integer, opr_count_occupied numeric, opr_occupied integer, specification_numbers character varying, opr_parent_id integer, opr_have_depend smallint, drp_max_extra smallint, sln_id integer, sln_name character varying, sln_is_resident smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spi_number varchar(100);
BEGIN
  opr_id = null;
  ord_id = null;
  opr_produce_name = null;
  opr_catalog_num = null;
  opr_count = null;
  opr_price_brutto = null;
  opr_discount = null;
  opr_price_netto = null;
  opr_summ = null;
  opr_use_prev_number = null;
  prd_id = null;
  prd_block = null;
  opr_count_executed = null;
  opr_comment = null;
  drp_price = null;
  ctr_id = null;
  ctr_name = null;
  con_id = null;
  con_number = null;
  con_date = null;
  cur_name = null;
  spc_id = null;
  spc_number = null;
  spc_date = null;
  spc_delivery_date = null;
  stf_id = null;
  opr_count_occupied = null;
  opr_occupied = null;
  specification_numbers = '';
  opr_parent_id = null;
  opr_have_depend = null;
  drp_max_extra = null;

  select
    opr.opr_id,
    opr.ord_id,
    opr.opr_produce_name,
    opr.opr_catalog_num,
    opr.opr_count,
    opr.opr_price_brutto,
    opr.opr_discount,
    opr.opr_price_netto,
    opr.opr_summ,
    opr.opr_use_prev_number,
    opr.prd_id,
    (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id and exe.opr_fictive_executed is null ),
    opr.opr_comment,
    opr.drp_price,
    opr.ctr_id,
    (select ctr_name from dcl_contractor where ctr_id = opr.ctr_id),
    opr.spc_id,
    ord.stf_id,
    (
      (select coalesce(sum(drp.drp_count), 0) from dcl_dlr_list_produce drp, dcl_delivery_request dlr where drp.opr_id = opr.opr_id and dlr.dlr_id = drp.dlr_id and dlr.dlr_annul is null)
      +
      (select coalesce(sum(lpc.lpc_count), 0) from dcl_prc_list_produce lpc where lpc.opr_id = opr.opr_id)
      +
      (select coalesce(sum(sip.sip_count), 0) from dcl_spi_list_produce sip where sip.opr_id = opr.opr_id)
      +
      (select out_count from dcl_get_count_opr_used_in_asm(opr.opr_id) )
    ),
    (select opr_id from DCL_OCCUPIED_ORD_PRODUCE_V where opr_id = opr.opr_id),
    opr.opr_parent_id,
    opr.opr_have_depend,
    opr.drp_max_extra
  from dcl_ord_list_produce opr,
       dcl_order ord
  where opr.opr_id = p_opr_id_in and
        ord.ord_id = opr.ord_id
  into
    opr_id,
    ord_id,
    opr_produce_name,
    opr_catalog_num,
    opr_count,
    opr_price_brutto,
    opr_discount,
    opr_price_netto,
    opr_summ,
    opr_use_prev_number,
    prd_id,
    opr_count_executed,
    opr_comment,
    drp_price,
    ctr_id,
    ctr_name,
    spc_id,
    stf_id,
    opr_count_occupied,
    opr_occupied,
    opr_parent_id,
    opr_have_depend,
    drp_max_extra
  ;

  if ( spc_id is not null ) then
    select 
      spc.spc_number,
      spc.spc_date,
      spc.spc_delivery_date,
      con.con_id,
      con.con_number,
      con.con_date,
      cur.cur_name,
      con.sln_id,
      sln.sln_name,
      sln.sln_is_resident
    from dcl_con_list_spec spc,
         dcl_contract con,
         dcl_currency cur,
         dcl_seller sln
    where spc.spc_id = spc_id and
          con.con_id = spc.con_id and
          cur.cur_id = con.cur_id and
          sln.sln_id = con.sln_id
    into
      spc_number,
      spc_date,
      spc_delivery_date,
      con_id,
      con_number,
      con_date,
      cur_name,
      sln_id,
      sln_name,
      sln_is_resident
    ;
  END IF;

  FOR spi_number IN select distinct(spi.spi_number) from dcl_spi_list_produce sip, dcl_specification_import spi where sip.opr_id = opr_id and spi.spi_id = sip.spi_id
  LOOP
    specification_numbers = specification_numbers || spi_number || ', ';
  END LOOP;

  if ( prd_id is not null ) then
    select prd_block from dcl_produce where prd_id = prd_id into prd_block;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_ord_list_produces_load(integer, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_list_produces_load(p_ord_id_in integer, p_clone smallint) RETURNS TABLE(opr_id integer, ord_id integer, opr_produce_name character varying, opr_catalog_num character varying, opr_count numeric, opr_price_brutto numeric, opr_discount numeric, opr_price_netto numeric, opr_summ numeric, opr_use_prev_number character, prd_id integer, opr_count_executed numeric, opr_comment character varying, drp_price numeric, ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, spc_id integer, spc_number character varying, stf_id integer, opr_count_occupied numeric, opr_occupied integer, specification_numbers character varying, opr_parent_id integer, opr_have_depend smallint, drp_max_extra smallint, sln_id integer, sln_name character varying, sln_is_resident smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prd_block smallint;
  _rec RECORD;
BEGIN
  ord_id := p_ord_id_in;

  FOR _rec IN select opr_id from dcl_ord_list_produce opr where opr.ord_id = p_ord_id_in order by opr_id
  LOOP
    opr_id := _rec.opr_id;
    select
      opr_id,
      ord_id,
      opr_produce_name,
      opr_catalog_num,
      opr_count,
      opr_price_brutto,
      opr_discount,
      opr_price_netto,
      opr_summ,
      opr_use_prev_number,
      prd_id,
      prd_block,
      opr_count_executed,
      opr_comment,
      drp_price,
      ctr_id,
      ctr_name,
      con_id,
      con_number,
      spc_id,
      spc_number,
      stf_id,
      opr_count_occupied,
      opr_occupied,
      specification_numbers,
      opr_parent_id,
      opr_have_depend,
      drp_max_extra,
      sln_id,
      sln_name,
      sln_is_resident
    from dcl_ord_list_produce_load(opr_id)
    into
      opr_id,
      ord_id,
      opr_produce_name,
      opr_catalog_num,
      opr_count,
      opr_price_brutto,
      opr_discount,
      opr_price_netto,
      opr_summ,
      opr_use_prev_number,
      prd_id,
      prd_block,
      opr_count_executed,
      opr_comment,
      drp_price,
      ctr_id,
      ctr_name,
      con_id,
      con_number,
      spc_id,
      spc_number,
      stf_id,
      opr_count_occupied,
      opr_occupied,
      specification_numbers,
      opr_parent_id,
      opr_have_depend,
      drp_max_extra,
      sln_id,
      sln_name,
      sln_is_resident
    ;

    if ( p_clone is null or prd_block is null ) then
      RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_ord_message_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_message_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ORM_ID IS NULL) THEN
    NEW.ORM_ID = nextval('gen_dcl_ord_message_id');
  ELSE
        ID = nextval('gen_dcl_ord_message_id');
        IF ( ID < NEW.ORM_ID ) THEN
          ID = nextval('gen_dcl_ord_message_id');
  END IF;
  END IF;

  new.orm_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_ord_messages_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ord_messages_load(p_usr_id_in integer) RETURNS TABLE(orm_id integer, orm_create_date timestamp without time zone, orm_message character varying, ord_id integer, ord_number character varying, ctr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
  _rec2 RECORD;
  v_ctr_name_local VARCHAR(200);
BEGIN
  FOR _rec IN SELECT om.orm_id, om.orm_create_date, om.orm_message, om.ord_id
    FROM dcl_ord_message om WHERE om.usr_id = p_usr_id_in ORDER BY om.orm_create_date DESC
  LOOP
    orm_id := _rec.orm_id; orm_create_date := _rec.orm_create_date;
    orm_message := _rec.orm_message; ord_id := _rec.ord_id;
    ctr_name := NULL; ord_number := NULL;
    IF (ord_id IS NOT NULL) THEN
      SELECT o.ord_number INTO ord_number FROM dcl_order o WHERE o.ord_id = _rec.ord_id;
      ctr_name := '';
      FOR _rec2 IN SELECT ct.ctr_name FROM dcl_contractor ct
        JOIN dcl_con_list_spec spc ON spc.ctr_id = ct.ctr_id
        JOIN dcl_order o ON o.spc_id = spc.spc_id
        WHERE o.ord_id = _rec.ord_id
      LOOP
        v_ctr_name_local := _rec2.ctr_name;
        IF (POSITION(v_ctr_name_local IN ctr_name) = 0) THEN
          ctr_name := ctr_name || v_ctr_name_local || ', ';
        END IF;
      END LOOP;
    END IF;
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_order_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  usr_count integer;
BEGIN
  if (new.ctr_id_for is not null) then
    select count(usr_id) from dcl_contractor_user t where t.usr_id = new.usr_id_create and t.ctr_id = new.ctr_id_for into usr_count;
    if (usr_count = 0) then
      insert into dcl_contractor_user (ctr_id, usr_id) values (new.ctr_id_for, new.usr_id_create);
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_order_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.ord_id and att.att_parent_table = 'DCL_ORDER';
RETURN OLD;
END
$$;


--
-- Name: dcl_order_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ord_ID IS NULL) THEN
    NEW.ord_ID = nextval('gen_dcl_order_id');
  ELSE
        ID = nextval('gen_dcl_order_id');
        IF ( ID < NEW.ord_ID ) THEN
          ID = nextval('gen_dcl_order_id');
  END IF;
  END IF;
  new.ord_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.ord_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_order_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.ord_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_order_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_filter(p_number character varying, p_contractor character varying, p_contractor_for character varying, p_stuff_category character varying, p_date_begin character varying, p_date_end character varying, p_summ_min character varying, p_summ_max character varying, p_user character varying, p_dep_id character varying, p_executed character varying, p_ready_for_deliv character varying, p_seller_for_who character varying, p_state_a character varying, p_state_3 character varying, p_state_b character varying, p_state_excl character varying, p_state_c character varying, p_num_conf character varying, p_annul_not_show character varying, p_con_number character varying, p_spc_number character varying) RETURNS TABLE(ord_id integer, ord_number character varying, ord_date date, ord_contractor character varying, ord_contractor_for character varying, ord_summ numeric, ord_sent_to_prod_date date, ord_received_conf_date date, ord_conf_sent_date date, ord_ready_for_deliv_date date, ord_ready_for_deliv smallint, ord_executed_date date, ord_user character varying, ord_department character varying, is_warn smallint, usr_id_create integer, ord_block smallint, ord_date_conf date, count_day_curr_minus_sent integer, ord_annul smallint, ord_num_conf character varying, ord_arrive_in_lithuania date, dep_id integer, have_empty_date_conf smallint, ord_comment_flag integer, ord_ship_from_stock date, ord_link_to_spec integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_number VARCHAR; v_contractor VARCHAR; v_contractor_for VARCHAR; v_stuff_cat VARCHAR;
  v_user VARCHAR; v_num_conf VARCHAR; v_seller_for_who VARCHAR;
  v_date_begin DATE; v_date_end DATE;
  v_summ_min DECIMAL(18,2); v_summ_max DECIMAL(18,2);
  v_dep_id INTEGER; v_executed SMALLINT; v_ready_for_deliv SMALLINT;
  v_state_a SMALLINT; v_state_3 SMALLINT; v_state_b SMALLINT;
  v_state_excl SMALLINT; v_state_c SMALLINT; v_annul_not_show SMALLINT;
  v_con_number VARCHAR; v_spc_number VARCHAR;
  rec RECORD;
  v_spc_delivery_date DATE; v_ord_date_conf_all SMALLINT;
  v_ord_ready_for_deliv_date_all SMALLINT; v_ord_in_one_spec SMALLINT; v_spc_id INTEGER;
  v_warn_count INTEGER;
  rfs_rec RECORD; opr_rec RECORD;
  v_rfs_count_sum DECIMAL(15,2);
  v_opr_count INTEGER; v_opr_count_with_spec INTEGER;
  v_dep_id_found INTEGER;
BEGIN
  v_number := UPPER(p_number); v_contractor := UPPER(p_contractor);
  v_contractor_for := UPPER(p_contractor_for); v_stuff_cat := UPPER(p_stuff_category);
  v_user := UPPER(p_user); v_num_conf := UPPER(p_num_conf);
  v_seller_for_who := UPPER(p_seller_for_who);
  v_date_begin := CASE WHEN p_date_begin IS NOT NULL AND p_date_begin != '' THEN p_date_begin::DATE ELSE NULL END;
  v_date_end := CASE WHEN p_date_end IS NOT NULL AND p_date_end != '' THEN p_date_end::DATE ELSE NULL END;
  v_summ_min := CASE WHEN p_summ_min IS NOT NULL AND p_summ_min != '' THEN p_summ_min::DECIMAL(18,2) ELSE NULL END;
  v_summ_max := CASE WHEN p_summ_max IS NOT NULL AND p_summ_max != '' THEN p_summ_max::DECIMAL(18,2) ELSE NULL END;
  v_dep_id := CASE WHEN p_dep_id IS NOT NULL AND p_dep_id != '' THEN p_dep_id::INTEGER ELSE NULL END;
  v_executed := CASE WHEN p_executed IS NOT NULL AND p_executed != '' THEN p_executed::SMALLINT ELSE NULL END;
  v_ready_for_deliv := CASE WHEN p_ready_for_deliv IS NOT NULL AND p_ready_for_deliv != '' THEN p_ready_for_deliv::SMALLINT ELSE NULL END;
  v_state_a := CASE WHEN p_state_a IS NOT NULL AND p_state_a != '' THEN p_state_a::SMALLINT ELSE NULL END;
  v_state_3 := CASE WHEN p_state_3 IS NOT NULL AND p_state_3 != '' THEN p_state_3::SMALLINT ELSE NULL END;
  v_state_b := CASE WHEN p_state_b IS NOT NULL AND p_state_b != '' THEN p_state_b::SMALLINT ELSE NULL END;
  v_state_excl := CASE WHEN p_state_excl IS NOT NULL AND p_state_excl != '' THEN p_state_excl::SMALLINT ELSE NULL END;
  v_state_c := CASE WHEN p_state_c IS NOT NULL AND p_state_c != '' THEN p_state_c::SMALLINT ELSE NULL END;
  v_annul_not_show := CASE WHEN p_annul_not_show IS NOT NULL AND p_annul_not_show != '' THEN p_annul_not_show::SMALLINT ELSE NULL END;
  v_con_number := p_con_number; v_spc_number := p_spc_number;

  FOR rec IN
    SELECT ord.ord_id, ord.ord_number, ord.ord_date, ctr.ctr_name,
           ord.ord_summ, ord.ord_sent_to_prod_date, ord.ord_received_conf_date,
           ord.ord_date_conf,
           (SELECT spc.spc_delivery_date FROM dcl_con_list_spec spc WHERE spc.spc_id = ord.spc_id) AS v_spc_dd,
           ord.ord_conf_sent_date, ord.ord_ready_for_deliv_date, ord.ord_executed_date,
           (SELECT ul.usr_surname || ' ' || ul.usr_name FROM dcl_user_language ul WHERE ul.usr_id = ord.usr_id_create AND ul.lng_id = 1) AS v_user_name,
           ord.usr_id_create, ord.ord_block,
           CASE WHEN ord.ord_sent_to_prod_date IS NOT NULL THEN (CURRENT_DATE - ord.ord_sent_to_prod_date) ELSE NULL END AS v_count_day,
           ord.ord_annul, ord.ord_num_conf,
           ord.ord_date_conf_all, ord.ord_ready_for_deliv_date_all,
           ord.ord_ship_from_stock, ord.ord_arrive_in_lithuania,
           ord.ord_in_one_spec, ord.spc_id,
           strlen(ord.ord_comment) AS v_comment_flag
    FROM dcl_order ord, dcl_contractor ctr
    WHERE ctr.ctr_id = ord.ctr_id
      AND (v_annul_not_show IS NULL OR ord.ord_annul IS NULL)
      AND (v_contractor IS NULL OR v_contractor = '' OR (SELECT UPPER(c.ctr_name) FROM dcl_contractor c WHERE c.ctr_id = ord.ctr_id) LIKE '%' || v_contractor || '%')
      AND (v_contractor_for IS NULL OR v_contractor_for = ''
           OR (ord.ord_in_one_spec IS NOT NULL AND (SELECT UPPER(c1.ctr_name) FROM dcl_contractor c1 WHERE c1.ctr_id = ord.ctr_id_for) LIKE '%' || v_contractor_for || '%')
           OR (ord.ord_in_one_spec IS NULL AND (SELECT COUNT(opr.opr_id) FROM dcl_ord_list_produce opr WHERE opr.ord_id = ord.ord_id AND (SELECT UPPER(c1.ctr_name) FROM dcl_contractor c1 WHERE c1.ctr_id = opr.ctr_id) LIKE '%' || v_contractor_for || '%') > 0))
      AND (v_stuff_cat IS NULL OR v_stuff_cat = '' OR (SELECT UPPER(stf.stf_name) FROM dcl_stuff_category stf WHERE stf.stf_id = ord.stf_id) LIKE '%' || v_stuff_cat || '%')
      AND (v_executed IS NULL OR (v_executed = 1 AND ord.ord_executed_date IS NOT NULL) OR (v_executed = 0 AND ord.ord_executed_date IS NULL))
      AND ((v_num_conf IS NOT NULL AND v_num_conf != '') OR v_state_a IS NULL OR (v_state_a = 1 AND ord.ord_sent_to_prod_date IS NOT NULL AND ord.ord_received_conf_date IS NULL))
      AND ((v_num_conf IS NOT NULL AND v_num_conf != '') OR v_state_3 IS NULL OR (v_state_3 = 1 AND (CURRENT_DATE - ord.ord_sent_to_prod_date > 3) AND ord.ord_received_conf_date IS NULL))
      AND ((v_num_conf IS NOT NULL AND v_num_conf != '') OR v_state_b IS NULL OR (v_state_b = 1 AND ord.ord_received_conf_date IS NOT NULL AND ord.ord_conf_sent_date IS NULL))
      AND ((v_num_conf IS NOT NULL AND v_num_conf != '') OR v_state_c IS NULL OR (v_state_c = 1 AND ord.ord_conf_sent_date IS NOT NULL AND ord.ord_executed_date IS NULL))
      AND (v_date_begin IS NULL OR ord.ord_date >= v_date_begin)
      AND (v_date_end IS NULL OR ord.ord_date <= v_date_end)
      AND (v_summ_min IS NULL OR ord.ord_summ >= v_summ_min)
      AND (v_summ_max IS NULL OR ord.ord_summ <= v_summ_max)
      AND (v_user IS NULL OR v_user = '' OR (SELECT UPPER(u.usr_surname || ' ' || u.usr_name) FROM dcl_user_language u WHERE u.usr_id = ord.usr_id_create AND u.lng_id = 1) LIKE '%' || v_user || '%')
      AND (v_dep_id IS NULL OR v_dep_id = -1 OR (SELECT u.dep_id FROM dcl_user u WHERE u.usr_id = ord.usr_id_create) = v_dep_id)
      AND (v_number IS NULL OR v_number = '' OR UPPER(ord.ord_number) LIKE '%' || v_number || '%')
      AND (v_num_conf IS NULL OR v_num_conf = '' OR UPPER(ord.ord_num_conf) LIKE '%' || v_num_conf || '%')
      AND (v_con_number IS NULL OR v_con_number = ''
           OR (ord.ord_in_one_spec IS NOT NULL AND EXISTS(SELECT 1 FROM dcl_con_list_spec spc2 LEFT JOIN dcl_contract con ON spc2.con_id = con.con_id WHERE ord.spc_id = spc2.spc_id AND UPPER(con.con_number) LIKE UPPER(v_con_number)))
           OR (ord.ord_in_one_spec IS NULL AND EXISTS(SELECT 1 FROM dcl_ord_list_produce opr LEFT JOIN dcl_con_list_spec spc2 ON opr.spc_id = spc2.spc_id LEFT JOIN dcl_contract con ON spc2.con_id = con.con_id WHERE opr.ord_id = ord.ord_id AND UPPER(con.con_number) LIKE UPPER(v_con_number))))
      AND (v_spc_number IS NULL OR v_spc_number = ''
           OR (ord.ord_in_one_spec IS NOT NULL AND EXISTS(SELECT 1 FROM dcl_con_list_spec spc2 WHERE ord.spc_id = spc2.spc_id AND UPPER(spc2.spc_number) LIKE UPPER(v_spc_number)))
           OR (ord.ord_in_one_spec IS NULL AND EXISTS(SELECT 1 FROM dcl_ord_list_produce opr LEFT JOIN dcl_con_list_spec spc2 ON opr.spc_id = spc2.spc_id WHERE opr.ord_id = ord.ord_id AND UPPER(spc2.spc_number) LIKE UPPER(v_spc_number))))
      AND (v_seller_for_who IS NULL OR v_seller_for_who = '' OR (SELECT UPPER(sln.sln_name) FROM dcl_seller sln WHERE sln.sln_id = ord.sln_id_for_who) LIKE '%' || v_seller_for_who || '%')
  LOOP
    ord_id := rec.ord_id; ord_number := rec.ord_number; ord_date := rec.ord_date;
    ord_contractor := rec.ctr_name; ord_summ := rec.ord_summ;
    ord_sent_to_prod_date := rec.ord_sent_to_prod_date;
    ord_received_conf_date := rec.ord_received_conf_date;
    ord_date_conf := rec.ord_date_conf;
    v_spc_delivery_date := rec.v_spc_dd;
    ord_conf_sent_date := rec.ord_conf_sent_date;
    ord_ready_for_deliv_date := rec.ord_ready_for_deliv_date;
    ord_executed_date := rec.ord_executed_date;
    ord_user := rec.v_user_name;
    usr_id_create := rec.usr_id_create;
    ord_block := rec.ord_block;
    count_day_curr_minus_sent := rec.v_count_day;
    ord_annul := rec.ord_annul;
    ord_num_conf := rec.ord_num_conf;
    v_ord_date_conf_all := rec.ord_date_conf_all;
    v_ord_ready_for_deliv_date_all := rec.ord_ready_for_deliv_date_all;
    ord_ship_from_stock := rec.ord_ship_from_stock;
    ord_arrive_in_lithuania := rec.ord_arrive_in_lithuania;
    v_ord_in_one_spec := rec.ord_in_one_spec;
    v_spc_id := rec.spc_id;
    ord_comment_flag := rec.v_comment_flag;

    IF v_ord_ready_for_deliv_date_all IS NULL AND ord_ready_for_deliv_date IS NULL THEN
      FOR opr_rec IN
        SELECT opr.opr_id, exe.opr_count_executed
        FROM dcl_ord_list_produce opr, dcl_opr_list_executed exe
        WHERE opr.ord_id = rec.ord_id AND exe.opr_id = opr.opr_id
      LOOP
        v_rfs_count_sum := 0;
        FOR rfs_rec IN
          SELECT rfs.rfs_count, rfs.rfs_date, rfs.rfs_ship_from_stock, rfs.rfs_arrive_in_lithuania
          FROM dcl_ready_for_shipping rfs WHERE rfs.opr_id = opr_rec.opr_id ORDER BY rfs.rfs_date
        LOOP
          v_rfs_count_sum := v_rfs_count_sum + rfs_rec.rfs_count;
          IF v_rfs_count_sum > opr_rec.opr_count_executed THEN
            IF ord_ready_for_deliv_date IS NULL THEN ord_ready_for_deliv_date := rfs_rec.rfs_date; END IF;
            IF rfs_rec.rfs_date < ord_ready_for_deliv_date THEN ord_ready_for_deliv_date := rfs_rec.rfs_date; END IF;
            IF ord_arrive_in_lithuania IS NULL THEN ord_arrive_in_lithuania := rfs_rec.rfs_arrive_in_lithuania; END IF;
            IF rfs_rec.rfs_arrive_in_lithuania IS NOT NULL AND rfs_rec.rfs_arrive_in_lithuania < ord_arrive_in_lithuania THEN ord_arrive_in_lithuania := rfs_rec.rfs_arrive_in_lithuania; END IF;
            IF ord_ship_from_stock IS NULL THEN ord_ship_from_stock := rfs_rec.rfs_ship_from_stock; END IF;
            IF rfs_rec.rfs_ship_from_stock IS NOT NULL AND rfs_rec.rfs_ship_from_stock < ord_ship_from_stock THEN ord_ship_from_stock := rfs_rec.rfs_ship_from_stock; END IF;
            EXIT;
          END IF;
        END LOOP;
      END LOOP;
    END IF;

    ord_ready_for_deliv := NULL;
    IF v_ready_for_deliv IS NOT NULL AND ord_ready_for_deliv_date IS NOT NULL THEN
      ord_ready_for_deliv := 1;
    END IF;

    IF ord_executed_date IS NULL THEN
      is_warn := NULL;
      IF ord_date_conf IS NOT NULL OR v_ord_date_conf_all IS NOT NULL THEN
        SELECT w.is_warn FROM dcl_is_warm_by_delivery_date(ord_date_conf, v_spc_delivery_date) w INTO is_warn;
      END IF;
      IF ord_date_conf IS NULL AND v_ord_date_conf_all IS NULL THEN
        SELECT COUNT(ptr.ptr_id)
        FROM dcl_ord_list_produce opr, dcl_production_term ptr
        WHERE opr.ord_id = rec.ord_id AND ptr.opr_id = opr.opr_id
          AND (SELECT w.is_warn FROM dcl_is_warm_by_delivery_date(ptr.ptr_date, v_spc_delivery_date) w) IS NOT NULL
        INTO v_warn_count;
        IF v_warn_count > 0 THEN is_warn := 1; END IF;
      END IF;
    ELSE
      is_warn := NULL;
    END IF;

    IF v_state_excl IS NULL OR (v_num_conf IS NOT NULL AND v_num_conf != '') OR (v_state_excl = 1 AND is_warn = 1) THEN
      SELECT cf.contractors FROM dcl_get_contractor_for_for_ord(rec.ord_id, '<br>') cf INTO ord_contractor_for;
      dep_id := NULL;
      ord_department := NULL;
      SELECT u.dep_id FROM dcl_user u WHERE u.usr_id = rec.usr_id_create INTO v_dep_id_found;
      dep_id := v_dep_id_found;
      SELECT d.dep_name FROM dcl_department d WHERE d.dep_id = v_dep_id_found INTO ord_department;
      SELECT h.have_empty_date_conf FROM dcl_is_have_empty_date_conf(rec.ord_id, NULL, v_ord_date_conf_all) h INTO have_empty_date_conf;

      IF v_ord_in_one_spec IS NOT NULL THEN
        IF v_spc_id IS NULL THEN ord_link_to_spec := 1;
        ELSE ord_link_to_spec := 3; END IF;
      ELSE
        SELECT COUNT(opr.opr_id) FROM dcl_ord_list_produce opr WHERE opr.ord_id = rec.ord_id INTO v_opr_count;
        SELECT COUNT(opr.opr_id) FROM dcl_ord_list_produce opr WHERE opr.ord_id = rec.ord_id AND opr.spc_id IS NOT NULL INTO v_opr_count_with_spec;
        IF v_opr_count_with_spec = 0 THEN ord_link_to_spec := 1;
        ELSIF v_opr_count_with_spec = v_opr_count THEN ord_link_to_spec := 3;
        ELSE ord_link_to_spec := 2; END IF;
      END IF;

      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_order_insert(date, character varying, integer, integer, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, integer, integer, integer, date, date, character varying, date, date, date, date, smallint, numeric, character varying, numeric, smallint, integer, smallint, numeric, integer, integer, smallint, numeric, smallint, smallint, numeric, smallint, numeric, smallint, smallint, smallint, character varying, character varying, smallint, smallint, integer, character varying, smallint, date, date, integer, integer, smallint, smallint, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_insert(p_ord_date date, p_ord_number character varying, p_bln_id integer, p_ctr_id integer, p_cps_id integer, p_ord_concerning character varying, p_ord_preamble character varying, p_trm_id integer, p_ord_addr character varying, p_ord_pay_condition character varying, p_ord_delivery_term character varying, p_ord_add_info character varying, p_usr_id_director integer, p_usr_id_logist integer, p_usr_id_director_rb integer, p_usr_id_chief_dep integer, p_usr_id_manager integer, p_ctr_id_for integer, p_spc_id integer, p_stf_id integer, p_ord_sent_to_prod_date date, p_ord_received_conf_date date, p_ord_num_conf character varying, p_ord_date_conf date, p_ord_conf_sent_date date, p_ord_ready_for_deliv_date date, p_ord_executed_date date, p_ord_block smallint, p_ord_summ numeric, p_ord_delivery_cost_by character varying, p_ord_delivery_cost numeric, p_ord_donot_calculate_netto smallint, p_cur_id integer, p_ord_include_nds smallint, p_ord_nds_rate numeric, p_sln_id_for_who integer, p_sln_id integer, p_ord_discount_all smallint, p_ord_discount numeric, p_ord_count_itog_flag smallint, p_ord_add_reduction_flag smallint, p_ord_add_reduction numeric, p_ord_add_red_pre_pay_flag smallint, p_ord_add_red_pre_pay numeric, p_ord_all_include_in_spec smallint, p_ord_annul smallint, p_ord_in_one_spec smallint, p_ord_comment character varying, p_ord_comment_covering_letter character varying, p_ord_date_conf_all smallint, p_ord_ready_for_deliv_date_all smallint, p_sdt_id integer, p_ord_shp_doc_number character varying, p_ord_by_guaranty smallint, p_ord_ship_from_stock date, p_ord_arrive_in_lithuania date, p_ord_print_scale integer, p_ord_letter_scale integer, p_ord_logist_signature smallint, p_ord_director_rb_signature smallint, p_ord_chief_dep_signature smallint, p_ord_manager_signature smallint) RETURNS TABLE(ord_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN

  insert into dcl_order (
      p_ord_number,
      p_ord_date,
      p_bln_id,
      p_ctr_id,
      p_cps_id,
      p_ord_concerning,
      p_ord_preamble,
      p_ord_delivery_term,
      p_ord_pay_condition,
      p_ord_addr,
      p_trm_id,
      p_ord_add_info,
      p_usr_id_director,
      p_usr_id_logist,
      p_usr_id_director_rb,
      p_usr_id_chief_dep,
      p_usr_id_manager,
      p_ctr_id_for,
      p_spc_id,
      p_stf_id,
      p_ord_sent_to_prod_date,
      p_ord_received_conf_date,
      p_ord_num_conf,
      p_ord_date_conf,
      p_ord_conf_sent_date,
      p_ord_ready_for_deliv_date,
      p_ord_executed_date,
      p_ord_block,
      p_ord_summ,
      p_ord_delivery_cost_by,
      p_ord_delivery_cost,
      p_ord_donot_calculate_netto,
      p_cur_id,
      p_ord_include_nds,
      p_ord_nds_rate,
      p_sln_id_for_who,
      p_sln_id,
      p_ord_discount_all,
      p_ord_discount,
      p_ord_count_itog_flag,
      p_ord_add_reduction_flag,
      p_ord_add_reduction,
      p_ord_add_red_pre_pay_flag,
      p_ord_add_red_pre_pay,
      p_ord_all_include_in_spec,
      p_ord_annul,
      p_ord_in_one_spec,
      p_ord_comment,
      p_ord_comment_covering_letter,
      p_ord_date_conf_all,
      p_ord_ready_for_deliv_date_all,
      p_sdt_id,
      p_ord_shp_doc_number,
      p_ord_by_guaranty,
      p_ord_ship_from_stock,
      p_ord_arrive_in_lithuania,
      p_ord_print_scale,
      p_ord_letter_scale,
      p_ord_logist_signature,
      p_ord_director_rb_signature,
      p_ord_chief_dep_signature,
      p_ord_manager_signature
    )
    values (
      p_ord_number,
      p_ord_date,
      p_bln_id,
      p_ctr_id,
      p_cps_id,
      p_ord_concerning,
      p_ord_preamble,
      p_ord_delivery_term,
      p_ord_pay_condition,
      p_ord_addr,
      p_trm_id,
      p_ord_add_info,
      p_usr_id_director,
      p_usr_id_logist,
      p_usr_id_director_rb,
      p_usr_id_chief_dep,
      p_usr_id_manager,
      p_ctr_id_for,
      p_spc_id,
      p_stf_id,
      p_ord_sent_to_prod_date,
      p_ord_received_conf_date,
      p_ord_num_conf,
      p_ord_date_conf,
      p_ord_conf_sent_date,
      p_ord_ready_for_deliv_date,
      p_ord_executed_date,
      p_ord_block,
      p_ord_summ,
      p_ord_delivery_cost_by,
      p_ord_delivery_cost,
      p_ord_donot_calculate_netto,
      p_cur_id,
      p_ord_include_nds,
      p_ord_nds_rate,
      p_sln_id_for_who,
      p_sln_id,
      p_ord_discount_all,
      p_ord_discount,
      p_ord_count_itog_flag,
      p_ord_add_reduction_flag,
      p_ord_add_reduction,
      p_ord_add_red_pre_pay_flag,
      p_ord_add_red_pre_pay,
      p_ord_all_include_in_spec,
      p_ord_annul,
      p_ord_in_one_spec,
      p_ord_comment,
      p_ord_comment_covering_letter,
      p_ord_date_conf_all,
      p_ord_ready_for_deliv_date_all,
      p_sdt_id,
      p_ord_shp_doc_number,
      p_ord_by_guaranty,
      p_ord_ship_from_stock,
      p_ord_arrive_in_lithuania,
      p_ord_print_scale,
      p_ord_letter_scale,
      p_ord_logist_signature,
      p_ord_director_rb_signature,
      p_ord_chief_dep_signature,
      p_ord_manager_signature
    )
    returning ord_id into ord_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_order_load_contract(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_order_load_contract(p_ord_id integer) RETURNS TABLE(con_number character varying, con_date date, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spc_id integer;
BEGIN
  con_number = null;
  con_date = null;
  cur_name = null;

  select spc_id from dcl_order where p_ord_id = p_ord_id into spc_id;
  if ( spc_id is not null ) then
    select 
      con.con_number,
      con.con_date,
      cur.cur_name
    from dcl_con_list_spec spc,
         dcl_contract con,
         dcl_currency cur
    where spc.spc_id = spc_id and
          con.con_id = spc.con_id and
          cur.cur_id = con.cur_id
    into
      con_number,
      con_date,
      cur_name
    ;
  END IF;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_orders_logistics(date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_orders_logistics(p_ord_date_begin date, p_ord_date_end date, p_include_empty_dates smallint) RETURNS TABLE(ord_num character varying, contractor character varying, conf_date character varying, conf_num character varying, contact_person character varying, shp_doc_type_num character varying, weight numeric, comment character varying, include_empty_dates_sort smallint, conf_date_sort date, have_empty_date_conf smallint, ord_received_conf_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ord_id INTEGER; v_shp_doc_type VARCHAR(100); v_shp_doc_number VARCHAR(60);
  v_ord_date_conf_all SMALLINT; v_ord_ready_for_deliv_date_all SMALLINT;
  v_opr_id INTEGER; v_strdate VARCHAR(10); v_ord_date_conf DATE;
  v_ord_ready_for_deliv_date DATE; v_con_id INTEGER; v_spc_id INTEGER;
  v_ord_number VARCHAR(50); v_shp_id INTEGER;
  _rec RECORD; _rec2 RECORD; _rec3 RECORD;
BEGIN
  FOR _rec IN SELECT o.ord_id, o.ord_number, o.ord_date_conf, o.ord_ready_for_deliv_date,
      o.ord_received_conf_date, o.ord_weight, o.ord_comment
    FROM dcl_order o
    WHERE (p_ord_date_begin IS NULL OR o.ord_date >= p_ord_date_begin)
      AND (p_ord_date_end IS NULL OR o.ord_date <= p_ord_date_end)
    ORDER BY o.ord_date_conf NULLS FIRST, o.ord_number
  LOOP
    v_ord_id := _rec.ord_id;
    ord_num := _rec.ord_number;
    weight := _rec.ord_weight;
    "comment" := _rec.ord_comment;
    ord_received_conf_date := _rec.ord_received_conf_date;
    conf_date_sort := _rec.ord_date_conf;
    have_empty_date_conf := CASE WHEN _rec.ord_date_conf IS NULL THEN 1 ELSE 0 END;
    include_empty_dates_sort := p_include_empty_dates;
    
    contractor := '';
    FOR _rec2 IN SELECT DISTINCT ct.ctr_name FROM dcl_contractor ct
      JOIN dcl_con_list_spec spc ON spc.ctr_id = ct.ctr_id
      JOIN dcl_order o2 ON o2.spc_id = spc.spc_id WHERE o2.ord_id = v_ord_id
    LOOP
      IF (LENGTH(contractor) > 0) THEN contractor := contractor || ', '; END IF;
      contractor := contractor || _rec2.ctr_name;
    END LOOP;
    
    conf_date := '';
    IF (_rec.ord_date_conf IS NOT NULL) THEN
      SELECT d.strdate INTO v_strdate FROM date2str(_rec.ord_date_conf) d;
      conf_date := v_strdate;
    END IF;
    
    conf_num := '';
    contact_person := '';
    shp_doc_type_num := '';
    
    FOR _rec3 IN SELECT s.shp_id, s.shp_doc_type, s.shp_doc_number 
      FROM dcl_shipping s
      JOIN dcl_con_list_spec spc ON s.spc_id = spc.spc_id
      JOIN dcl_order o3 ON o3.spc_id = spc.spc_id
      WHERE o3.ord_id = v_ord_id
    LOOP
      IF (_rec3.shp_doc_type IS NOT NULL OR _rec3.shp_doc_number IS NOT NULL) THEN
        IF (LENGTH(shp_doc_type_num) > 0) THEN shp_doc_type_num := shp_doc_type_num || '; '; END IF;
        shp_doc_type_num := shp_doc_type_num || COALESCE(_rec3.shp_doc_type, '') || ' ' || COALESCE(_rec3.shp_doc_number, '');
      END IF;
    END LOOP;
    
    IF (p_include_empty_dates = 1 OR _rec.ord_date_conf IS NOT NULL) THEN
      RETURN NEXT;
    END IF;
  END LOOP;
END $$;


--
-- Name: dcl_orders_statistics(date, date, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_orders_statistics(p_date_begin date, p_date_end date, p_dep_id_in integer, p_stf_id_in integer, p_ctr_id_in integer, p_ctr_id_for_in integer) RETURNS TABLE(stf_id integer, stf_name character varying, ord_summ numeric, ord_summ_sent_to_prod numeric, ord_summ_part_executed numeric, ord_summ_executed numeric, ord_summ_executed_before numeric, cur_id integer, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ord_sent_to_prod_date date;
  ord_executed_date date;
  ord_id integer;
  opr_id integer;
  opr_count decimal(15,2);
  opr_count_executed decimal(15,2);
  opr_summ decimal(15,2);
  ord_in_one_spec smallint;
  ord_sum_total decimal(15,2);
  opr_summ_all decimal(15,2);
  opr_min_date_executed date;
  opr_max_date_executed date;
  ord_date date;
  _rec RECORD;
BEGIN
  FOR _rec IN select stf.stf_id, stf.stf_name, ord.ord_id, ord.ord_date, ord.ord_summ, cur.cur_id, cur.cur_name, ord.ord_sent_to_prod_date, ord.ord_executed_date, ord.ord_in_one_spec from   dcl_order ord, dcl_stuff_category stf, dcl_currency cur, dcl_user usr, dcl_department dep, dcl_user_language usr_lng where  stf.stf_id = ord.stf_id and (p_stf_id_in is null or p_stf_id_in = -1 or stf.stf_id = p_stf_id_in ) and cur.cur_id = ord.cur_id and usr.usr_id = ord.usr_id_manager and dep.dep_id = usr.dep_id and (p_dep_id_in is null or p_dep_id_in = -1 or dep.dep_id = p_dep_id_in ) and usr_lng.usr_id = usr.usr_id and usr_lng.lng_id = 1 and ( (ord.ord_date >= p_date_begin and ord.ord_date <= p_date_end ) or (ord.ord_sent_to_prod_date >= p_date_begin and ord.ord_sent_to_prod_date <= p_date_end ) or (ord.ord_executed_date is null or (ord.ord_executed_date >= p_date_begin and ord.ord_executed_date <= p_date_end) ) ) and (p_ctr_id_in is null or p_ctr_id_in = -1 or ord.ctr_id = p_ctr_id_in ) and ( p_ctr_id_for_in is null or p_ctr_id_for_in = -1 or ( ord.ctr_id_for = p_ctr_id_for_in and ord.ord_in_one_spec is not null ) or ( ord.ord_in_one_spec is null and (select count(opr_id) from dcl_ord_list_produce where ord_id = ord.ord_id and ctr_id = p_ctr_id_for_in ) > 0 ) ) and ord.ord_annul is null
  LOOP
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    ord_id := _rec.ord_id;
    ord_date := _rec.ord_date;
    ord_summ := _rec.ord_summ;
    cur_id := _rec.cur_id;
    cur_name := _rec.cur_name;
    ord_sent_to_prod_date := _rec.ord_sent_to_prod_date;
    ord_executed_date := _rec.ord_executed_date;
    ord_in_one_spec := _rec.ord_in_one_spec;
    select sum(opr_summ) from dcl_ord_list_produce where ord_id = ord_id into opr_summ_all;

    if ( ord_in_one_spec is null and p_ctr_id_for_in is not null and p_ctr_id_for_in != -1 ) then --calculate part of order sum
      ord_sum_total := ord_summ; -- for clearness of calculation
      ord_summ := 0;
  FOR _rec IN select opr_summ from dcl_ord_list_produce opr where opr.ord_id = ord_id and opr.ctr_id = p_ctr_id_for_in
  LOOP
    opr_summ := _rec.opr_summ;
          if ( opr_summ_all != 0 ) then
            ord_summ := ord_summ + ord_sum_total / opr_summ_all * opr_summ;
  END IF;
  END LOOP;
  END IF;
    --in other case - take all sum for order (ord_summ)

    ord_summ_sent_to_prod := 0;
    if ( ord_sent_to_prod_date >= p_date_begin and ord_sent_to_prod_date <= p_date_end ) then
      ord_summ_sent_to_prod := ord_summ;
  END IF;

    ord_summ_part_executed := 0;
    ord_summ_executed := 0;
    ord_summ_executed_before := 0;
  FOR _rec IN select opr_id, opr_summ, opr_count from dcl_ord_list_produce opr, dcl_order ord where opr.ord_id = ord_id and ord.ord_id = opr.ord_id and (p_ctr_id_for_in is null or p_ctr_id_for_in = -1 or opr.ctr_id = p_ctr_id_for_in or ord.ctr_id_for = p_ctr_id_for_in )
  LOOP
    opr_id := _rec.opr_id;
    opr_summ := _rec.opr_summ;
    opr_count := _rec.opr_count;
      select
        min(opr_date_executed),
        max(opr_date_executed)
      from dcl_opr_list_executed ord_ex,
           dcl_ord_list_produce opr,
           dcl_order ord
      where opr.ord_id = ord_id and
            ord_ex.opr_id = opr.opr_id and
            ord.ord_id = opr.ord_id and
            (p_ctr_id_for_in is null or p_ctr_id_for_in = -1 or opr.ctr_id = p_ctr_id_for_in or ord.ctr_id_for = p_ctr_id_for_in )
      into
        opr_min_date_executed,
        opr_max_date_executed;

      if ( ord_sent_to_prod_date >= p_date_begin and ord_sent_to_prod_date <= p_date_end ) then

        if ( ord_executed_date is not null and
             opr_min_date_executed >= p_date_begin and opr_max_date_executed <= p_date_end
           ) then
          ord_summ_executed := ord_summ_executed + opr_summ;
  END IF;

        if ( opr_min_date_executed < p_date_begin or opr_max_date_executed > p_date_end or ord_executed_date is null or ord_executed_date < p_date_begin or ord_executed_date > p_date_end ) then
          SELECT coalesce(sum(exe.opr_count_executed), 0)
            INTO opr_count_executed
            from dcl_opr_list_executed exe
          where exe.opr_id = opr_id and
                exe.opr_date_executed >= p_date_begin and
                exe.opr_date_executed <= p_date_end;

          if (opr_count != 0) then
            ord_summ_part_executed := ord_summ_part_executed + opr_summ / opr_count * opr_count_executed;
  END IF;
  END IF;

  END IF;

      if ( ord_sent_to_prod_date < p_date_begin ) then
        SELECT coalesce(sum(exe.opr_count_executed), 0)
          INTO opr_count_executed
          from dcl_opr_list_executed exe
        where exe.opr_id = opr_id and
              exe.opr_date_executed >= p_date_begin and
              exe.opr_date_executed <= p_date_end;

        if (opr_count != 0) then
          ord_summ_executed_before := ord_summ_executed_before + opr_summ / opr_count * opr_count_executed;
  END IF;
  END IF;

  END LOOP;

    if ( ord_date < p_date_begin or ord_date > p_date_end ) then
      ord_summ := 0;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_orders_unexecuted(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_orders_unexecuted() RETURNS TABLE(stf_id integer, stf_name character varying, stf_name_sort character varying, ord_id integer, ord_date date, ord_number character varying, ord_number_sort character varying, prd_id integer, produce_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, produce_full_name_sort character varying, ctn_number character varying, ctn_number_sort character varying, ord_count numeric, ord_count_executed numeric, ord_count_unexecuted numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select ord.ord_id, ord.ord_date, ord.ord_number, opr.opr_count, (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id ), stf.stf_id, stf.stf_name, prd.prd_id, prd.prd_name, prd.prd_type, prd.prd_params, prd.prd_add_params, ctn.ctn_number from   dcl_order ord, dcl_ord_list_produce opr, dcl_stuff_category stf, dcl_produce prd, dcl_catalog_number ctn where  opr.ord_id = ord.ord_id and stf.stf_id = ord.stf_id and prd.prd_id = opr.prd_id and ctn.stf_id = ord.stf_id and ctn.prd_id = opr.prd_id and ord.ord_executed_date is null and ord.ord_sent_to_prod_date is not null and opr.opr_count > (select coalesce(sum(exe.opr_count_executed), 0) from dcl_opr_list_executed exe where exe.opr_id = opr.opr_id )
  LOOP
    ord_id := _rec.ord_id;
    ord_date := _rec.ord_date;
    ord_number := _rec.ord_number;
    ord_count := _rec.ord_count;
    ord_count_executed := _rec.ord_count_executed;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    prd_id := _rec.prd_id;
    produce_name := _rec.produce_name;
    prd_type := _rec.prd_type;
    prd_params := _rec.prd_params;
    prd_add_params := _rec.prd_add_params;
    ctn_number := _rec.ctn_number;
    ord_count_unexecuted = ord_count - ord_count_executed;

    ord_number_sort = upper(ord_number);
    produce_full_name_sort = upper(produce_name || ' ' || prd_type || ' ' || prd_params || ' ' || prd_add_params);
    stf_name_sort = upper(stf_name);
    ctn_number_sort = upper(ctn_number);

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_outgoing_letter_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.otl_id and att.att_parent_table = 'DCL_OUTGOING_LETTER';
RETURN OLD;
END
$$;


--
-- Name: dcl_outgoing_letter_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.OTL_ID IS NULL) THEN
    NEW.OTL_ID = nextval('gen_dcl_outgoing_letter_id');
  ELSE
        ID = nextval('gen_dcl_outgoing_letter_id');
        IF ( ID < NEW.OTL_ID ) THEN
          ID = nextval('gen_dcl_outgoing_letter_id');
  END IF;
  END IF;

  new.otl_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.otl_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_outgoing_letter_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.otl_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_outgoing_letter_filter(character varying, character varying, date, date, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_filter(p_otl_number_in character varying, p_otl_contractor_in character varying, p_otl_date_begin_in date, p_otl_date_end_in date, p_otl_user_in character varying, p_sln_seller_in character varying) RETURNS TABLE(otl_id integer, otl_number character varying, otl_date date, otl_contractor character varying, attach_idx integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  otl_attach_count integer;
  _rec RECORD;
BEGIN
  p_otl_number_in = upper(p_otl_number_in);
  p_otl_contractor_in = upper(p_otl_contractor_in);
  p_otl_user_in = upper(p_otl_user_in);
  p_sln_seller_in = upper(p_sln_seller_in);

  FOR _rec IN select otl.otl_id, otl.otl_number, otl.otl_date, ctr.ctr_name from dcl_outgoing_letter otl, dcl_contractor ctr where ctr.ctr_id = otl.ctr_id and  ( p_otl_date_begin_in is null or otl_date >= p_otl_date_begin_in ) and  ( p_otl_date_end_in is null or otl_date <= p_otl_date_end_in ) and  ( p_otl_number_in is null or p_otl_number_in like '' or upper(otl.otl_number) like('%' || p_otl_number_in || '%') ) and  ( p_otl_contractor_in is null or p_otl_contractor_in like '' or upper(ctr.ctr_name) like('%' || p_otl_contractor_in || '%') ) and  ( p_otl_user_in is null or p_otl_user_in like '' or (select upper(usr.usr_surname || ' ' || usr.usr_name) from dcl_user_language usr where usr_id = otl.usr_id_create and lng_id = 1) like('%' || p_otl_user_in || '%') ) and  ( p_sln_seller_in is null or p_sln_seller_in like '' or ( (select upper(sln.sln_name) from dcl_seller sln where sln_id = otl.sln_id) like('%' || p_sln_seller_in || '%') )) order by otl_date DESC, otl_number DESC
  LOOP
    otl_id := _rec.otl_id;
    otl_number := _rec.otl_number;
    otl_date := _rec.otl_date;
    otl_contractor := _rec.ctr_name;
    select count(*) from dcl_attachment where att_parent_id = otl_id and att_parent_table='DCL_OUTGOING_LETTER' into otl_attach_count;

    attach_idx := null;
    if ( otl_attach_count = 0 ) then
     attach_idx := 1;
  END IF;
    if ( otl_attach_count > 0 ) then
     attach_idx := 6;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_outgoing_letter_insert(character varying, date, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_insert(p_otl_number character varying, p_otl_date date, p_sln_id integer, p_ctr_id integer, p_cps_id integer, p_otl_comment character varying) RETURNS TABLE(otl_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_outgoing_letter (
     p_otl_number,
     p_otl_date,
     p_sln_id,
     p_ctr_id,
     p_cps_id,
     p_otl_comment
    )
    values (
     p_otl_number,
     p_otl_date,
     p_sln_id,
     p_ctr_id,
     p_cps_id,
     p_otl_comment
   )
   returning otl_id into otl_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_outgoing_letter_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_outgoing_letter_load(p_otl_id integer) RETURNS TABLE(usr_id_create integer, usr_id_edit integer, otl_create_date timestamp without time zone, otl_edit_date timestamp without time zone, otl_number character varying, otl_date date, sln_id integer, sln_name character varying, ctr_id integer, ctr_name character varying, cps_id integer, cps_name character varying, otl_comment character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  select otl.usr_id_create,
         otl.usr_id_edit,
         otl.otl_create_date,
         otl.otl_edit_date,
         otl.otl_number,
         otl.otl_date,
         otl.sln_id,
         sln.sln_name,
         otl.ctr_id,
         ctr.ctr_name,
         otl.cps_id,
         cps.cps_name,
         otl.otl_comment
  from   dcl_outgoing_letter otl
         left join dcl_contact_person cps on cps.cps_id = otl.cps_id,
         dcl_contractor ctr,
         dcl_seller sln
  where otl.p_otl_id = p_otl_id and
        ctr.ctr_id = otl.ctr_id and
        sln.sln_id = otl.sln_id
  into  usr_id_create,
        usr_id_edit,
        otl_create_date,
        otl_edit_date,
        otl_number,
        otl_date,
        sln_id,
        sln_name,
        ctr_id,
        ctr_name,
        cps_id,
        cps_name,
        otl_comment
  ;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_pay_list_summ_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_pay_list_summ_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LPS_ID IS NULL) THEN
    NEW.LPS_ID = nextval('gen_dcl_pay_list_summ_id');
  ELSE
        ID = nextval('gen_dcl_pay_list_summ_id');
        IF ( ID < NEW.LPS_ID ) THEN
          ID = nextval('gen_dcl_pay_list_summ_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_pay_message_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_pay_message_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PMS_ID IS NULL) THEN
    NEW.PMS_ID = nextval('gen_dcl_pay_message_id');
  ELSE
        ID = nextval('gen_dcl_pay_message_id');
        IF ( ID < NEW.PMS_ID ) THEN
          ID = nextval('gen_dcl_pay_message_id');
  END IF;
  END IF;

  new.pms_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_pay_messages_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_pay_messages_load(p_usr_id_in integer) RETURNS TABLE(pms_id integer, pms_create_date timestamp without time zone, pms_message character varying, pms_sum numeric, ctr_id integer, ctr_name character varying, pms_percent numeric, pms_updated smallint, cur_id integer, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select pms_id, pms_create_date, pms_message, pms_sum, ctr_id, pms_percent, pms_updated, cur_id from dcl_pay_message pms where pms.usr_id = p_usr_id_in order by pms_create_date DESC
  LOOP
    pms_id := _rec.pms_id;
    pms_create_date := _rec.pms_create_date;
    pms_message := _rec.pms_message;
    pms_sum := _rec.pms_sum;
    ctr_id := _rec.ctr_id;
    pms_percent := _rec.pms_percent;
    pms_updated := _rec.pms_updated;
    cur_id := _rec.cur_id;
    ctr_name := null;
    if (ctr_id is not null) then
      select ctr_name from dcl_contractor where ctr_id = ctr_id into ctr_name;
  END IF;

    cur_name := null;
    if (cur_id is not null) then
      select cur_name from dcl_currency where cur_id = cur_id into cur_name;
  END IF;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_payment_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_payment_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PAY_ID IS NULL) THEN
    NEW.PAY_ID = nextval('gen_dcl_payment_id');
  ELSE
        ID = nextval('gen_dcl_payment_id');
        IF ( ID < NEW.PAY_ID ) THEN
          ID = nextval('gen_dcl_payment_id');
  END IF;
  END IF;

  new.pay_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.pay_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_payment_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_payment_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.pay_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_payment_filter(character varying, integer, date, date, numeric, numeric, smallint, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_payment_filter(p_pay_contractor_in character varying, p_pay_contractor_id_in integer, p_pay_date_begin_in date, p_pay_date_end_in date, p_pay_summ_min_in numeric, p_pay_summ_max_in numeric, p_pay_block_in smallint, p_cur_id_in integer, p_pay_closed_in integer, p_pay_account_in character varying) RETURNS TABLE(pay_id integer, pay_date date, pay_contractor character varying, pay_summ numeric, pay_currency character varying, pay_block smallint, usr_id_create integer, pay_account character varying, pay_course numeric, pay_summ_eur numeric, double_account smallint, double_contractors character varying, pay_course_nbrb numeric, pay_summ_eur_nbrb numeric, pay_comment character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  check_pay_id integer;
  ctr_id integer;
  _rec RECORD;
BEGIN
  p_pay_contractor_in = upper(p_pay_contractor_in);
  p_pay_account_in = upper(p_pay_account_in);

  FOR _rec IN select pay_id, pay_date, ctr_id, (select ctr_name from dcl_contractor  where ctr_id = pay.ctr_id), pay_account, pay_summ, (select cur_name from dcl_currency  where cur_id = pay.cur_id), pay_course, pay_block, usr_id_create, pay_course_nbrb, pay_comment from dcl_payment pay where ( p_pay_contractor_in is null or p_pay_contractor_in like '' or ( p_pay_contractor_id_in = -2 and pay.ctr_id is null ) or ( (select upper(ctr.ctr_name) from dcl_contractor ctr where ctr_id=pay.ctr_id) like('%' || p_pay_contractor_in || '%') )) and  ( p_cur_id_in is null or cur_id = p_cur_id_in ) and  ( p_pay_date_begin_in is null or pay_date >=p_pay_date_begin_in ) and  ( p_pay_date_end_in is null or pay_date <=p_pay_date_end_in ) and  ( p_pay_summ_min_in is null or pay_summ >=p_pay_summ_min_in ) and  ( p_pay_summ_max_in is null or pay_summ <=p_pay_summ_max_in ) and  ( p_pay_account_in is null or p_pay_account_in like '' or upper(pay.pay_account) like('%' || p_pay_account_in || '%') ) order by pay_date DESC
  LOOP
    pay_id := _rec.pay_id;
    pay_date := _rec.pay_date;
    ctr_id := _rec.ctr_id;
    pay_contractor := _rec.ctr_name;
    pay_account := _rec.pay_account;
    pay_summ := _rec.pay_summ;
    pay_currency := _rec.pay_currency;
    pay_course := _rec.pay_course;
    pay_block := _rec.pay_block;
    usr_id_create := _rec.usr_id_create;
    pay_course_nbrb := _rec.pay_course_nbrb;
    pay_comment := _rec.pay_comment;
    if (pay_course != 0) then
      pay_summ_eur := pay_summ / pay_course;
  ELSE
      pay_summ_eur := 0;
  END IF;

    if (pay_course_nbrb != 0) then
      pay_summ_eur_nbrb := pay_summ / pay_course_nbrb;
  ELSE
      pay_summ_eur_nbrb := 0;
  END IF;

    if ( (p_pay_block_in = 1 and pay_block is null) or ( p_pay_block_in is null )  ) then
        double_account := null;
        double_contractors := null;
        select ctr_double_account from dcl_contractor where ctr_id = ctr_id into double_account;
        if ( double_account is not null ) then
          select contractors from dcl_get_double_contractor(ctr_id, pay_account) into double_contractors;
          if ( double_contractors = '' ) then
            double_account := null;
  END IF;
  END IF;

        if ( p_pay_closed_in = 0 ) then
          RETURN NEXT;
  ELSE

          check_pay_id := null;
          select is_pay_closed from dcl_is_pay_closed(pay_id) into check_pay_id;

          if ( p_pay_closed_in = 1 ) then
            if ( check_pay_id is not null ) then
              RETURN NEXT;
  END IF;
  END IF;

          if ( p_pay_closed_in = -1 ) then
            if ( check_pay_id is null ) then
              RETURN NEXT;
  END IF;
  END IF;

  END IF;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_payment_insert(date, character varying, integer, integer, smallint, numeric, numeric, character varying, numeric, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_payment_insert(p_pay_date date, p_pay_account character varying, p_ctr_id integer, p_cur_id integer, p_pay_block smallint, p_pay_summ numeric, p_pay_course numeric, p_pay_comment character varying, p_pay_course_nbrb numeric, p_pay_course_nbrb_date date) RETURNS TABLE(pay_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_payment (
      p_pay_date,
      p_pay_account,
      p_ctr_id,
      p_cur_id,
      p_pay_block,
      p_pay_summ,
      p_pay_course,
      p_pay_comment,
      p_pay_course_nbrb,
      p_pay_course_nbrb_date
  )
  values (
      p_pay_date,
      p_pay_account,
      p_ctr_id,
      p_cur_id,
      p_pay_block,
      p_pay_summ,
      p_pay_course,
      p_pay_comment,
      p_pay_course_nbrb,
      p_pay_course_nbrb_date
  )
  returning pay_id into pay_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_prc_list_produce_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ctr_id integer;
  con_id integer;
  spc_id integer;
BEGIN
  SELECT ctr_id,
         con_id,
         spc_id INTO ctr_id, con_id, spc_id from get_contractor_for_for_lpc_id(new.lpc_id);

  if ( ctr_id is not null ) then
    insert into dcl_prc_ctr_for_calcstate(
         lpc_id,
         prc_id,
         ctr_id,
         con_id,
         spc_id
    )
    values(
         new.lpc_id,
         new.prc_id,
         ctr_id,
         con_id,
         spc_id
    );
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_prc_list_produce_au0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_au0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ctr_id integer;
  con_id integer;
  spc_id integer;
BEGIN
  update dcl_shp_list_produce set stf_id = new.stf_id where lpc_id = old.lpc_id and (stf_id is null or stf_id != new.stf_id);

  SELECT ctr_id,
         con_id,
         spc_id INTO ctr_id, con_id, spc_id from get_contractor_for_for_lpc_id(old.lpc_id);
  if ( ctr_id is not null ) then
    UPDATE dcl_prc_ctr_for_calcstate SET ctr_id = ctr_id, con_id = con_id, spc_id = spc_id
    where
      lpc_id = old.lpc_id;
  else
    DELETE FROM dcl_prc_ctr_for_calcstate WHERE lpc_id = old.lpc_id;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_prc_list_produce_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_count integer;
  apr_count integer;
  asm_id_old integer;
BEGIN
  if ( old.asm_id is not null ) then
    asm_count = 0;
    select count(asm_id) from dcl_dlr_list_produce where asm_id = old.asm_id into asm_count;
    if ( asm_count = 0 ) then
      select count(asm_id) from dcl_prc_list_produce where asm_id = old.asm_id and lpc_id != old.lpc_id into asm_count;
  END IF;
    if ( asm_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = old.asm_id;
  END IF;
  END IF;
  if ( old.apr_id is not null ) then
    apr_count = 0;
    select asm_id from dcl_asm_list_produce where apr_id = old.apr_id into asm_id_old;
    select count(apr_id) from dcl_dlr_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) into apr_count;
    if ( apr_count = 0 ) then
      select count(apr_id) from dcl_prc_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) and lpc_id != old.lpc_id into apr_count;
  END IF;
    if ( apr_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = asm_id_old;
  END IF;
  END IF;
RETURN OLD;
END
$$;


--
-- Name: dcl_prc_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.LPC_ID IS NULL) THEN
    NEW.LPC_ID = nextval('gen_dcl_prc_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_prc_list_produce_id');
        IF ( ID < NEW.LPC_ID ) THEN
          ID = nextval('gen_dcl_prc_list_produce_id');
  END IF;
  END IF;

  if ( new.asm_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 where asm_id = new.asm_id;
  END IF;
  if ( new.apr_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 where asm_id = (select asm_id from dcl_asm_list_produce where apr_id = new.apr_id);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_prc_list_produce_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_count integer;
  apr_count integer;
  asm_id_old integer;
BEGIN
  if ( new.asm_id != old.asm_id or ( new.asm_id is null and old.asm_id is not null ) ) then
    asm_count = 0;
    select count(asm_id) from dcl_dlr_list_produce where asm_id = old.asm_id into asm_count;
    if ( asm_count = 0 ) then
      select count(asm_id) from dcl_prc_list_produce where asm_id = old.asm_id and lpc_id != old.lpc_id into asm_count;
  END IF;
    if ( asm_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = old.asm_id;
  END IF;
  END IF;
  if ( new.apr_id != old.apr_id or ( new.apr_id is null and old.apr_id is not null ) ) then
    apr_count = 0;
    select asm_id from dcl_asm_list_produce where apr_id = old.apr_id into asm_id_old;
    select count(apr_id) from dcl_dlr_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) into apr_count;
    if ( apr_count = 0 ) then
      select count(apr_id) from dcl_prc_list_produce where apr_id in ( select apr_id from dcl_asm_list_produce where asm_id = asm_id_old ) and lpc_id != old.lpc_id into apr_count;
  END IF;
    if ( apr_count = 0 ) then
      UPDATE dcl_assemble SET asm_block = null where asm_id = asm_id_old;
  END IF;
  END IF;

  if ( new.asm_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 WHERE asm_id = new.asm_id;
  END IF;
  if ( new.apr_id is not null ) then
    UPDATE dcl_assemble SET asm_block = 1 WHERE asm_id = (select asm_id from dcl_asm_list_produce where apr_id = new.apr_id);
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_prc_list_produce_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produce_load(p_lpc_id_in integer) RETURNS TABLE(lpc_id integer, prc_id integer, prc_date date, lpc_produce_name character varying, stf_id integer, stf_name character varying, usr_id integer, lpc_count numeric, lpc_cost_one_ltl numeric, lpc_cost_one_by numeric, lpc_price_list_by numeric, lpc_cost_one numeric, lpc_weight numeric, lpc_summ numeric, lpc_sum_transport numeric, lpc_custom numeric, lpc_percent character varying, lpc_1c_number character varying, prs_id integer, prs_name character varying, prd_id integer, opr_id integer, drp_id integer, sip_id integer, apr_id integer, asm_id integer, dep_id integer, dep_name character varying, lpc_comment character varying, spi_id integer, dlr_id integer, no_round smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  lpc_id = null;
  prc_id = null;
  prc_date = null;
  lpc_produce_name = null;
  stf_id = null;
  stf_name = null;
  usr_id = null;
  lpc_count = null;
  lpc_cost_one_ltl = null;
  lpc_cost_one_by = null;
  lpc_price_list_by = null;
  lpc_cost_one = null;
  lpc_weight = null;
  lpc_summ = null;
  lpc_sum_transport = null;
  lpc_custom = null;
  lpc_percent = null;
  lpc_1c_number = null;
  prs_id = null;
  prs_name = null;
  prd_id = null;
  opr_id = null;
  drp_id = null;
  sip_id = null;
  apr_id = null;
  asm_id = null;
  dep_id = null;
  dep_name = null;
  lpc_comment = null;
  spi_id = null;
  dlr_id = null;
  no_round = null;

  select
    lpc.lpc_id,
    lpc.prc_id,
    prc.prc_date, 
    lpc.lpc_produce_name,
    lpc.stf_id,
    stf.stf_name,
    lpc.usr_id,
    lpc.lpc_count,
    lpc.lpc_cost_one_ltl,
    lpc.lpc_cost_one_by,
    lpc.lpc_price_list_by,
    lpc.lpc_cost_one,
    lpc.lpc_weight,
    lpc.lpc_summ,
    lpc.lpc_sum_transport,
    lpc.lpc_custom,
    lpc.lpc_percent,
    lpc.lpc_1c_number,
    lpc.prs_id,
    prs.prs_name,
    lpc.prd_id,
    lpc.opr_id,
    lpc.drp_id,
    lpc.sip_id,
    lpc.apr_id,
    lpc.asm_id,
    lpc.dep_id,
    lpc.lpc_comment
  from dcl_prc_list_produce lpc,
       dcl_stuff_category stf,
       dcl_purpose prs,
       dcl_produce_cost prc
  where lpc_id = p_lpc_id_in and
        stf.stf_id = lpc.stf_id and
        prs.prs_id = lpc.prs_id and
        prc.prc_id = lpc.prc_id
  into
    lpc_id,
    prc_id,
    prc_date,
    lpc_produce_name,
    stf_id,
    stf_name,
    usr_id,
    lpc_count,
    lpc_cost_one_ltl,
    lpc_cost_one_by,
    lpc_price_list_by,
    lpc_cost_one,
    lpc_weight,
    lpc_summ,
    lpc_sum_transport,
    lpc_custom,
    lpc_percent,
    lpc_1c_number,
    prs_id,
    prs_name,
    prd_id,
    opr_id,
    drp_id,
    sip_id,
    apr_id,
    asm_id,
    dep_id,
    lpc_comment
  ;

  if ( dep_id is not null ) then
    select dep_name from dcl_department where dep_id = dep_id into dep_name;
  END IF;

  if ( sip_id is not null ) then
    select spi_id from dcl_spi_list_produce where sip_id = sip_id into spi_id;
  END IF;

  if ( drp_id is not null ) then
    select dlr_id from dcl_dlr_list_produce where drp_id = drp_id into dlr_id;
  END IF;

  select cur_no_round from dcl_currency cur where cur.cur_name like 'BYN' into no_round;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_prc_list_produces_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_prc_list_produces_load(p_prc_id_in integer) RETURNS TABLE(lpc_id integer, prc_id integer, stf_id integer, stf_name character varying, prd_id integer, prd_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, lpc_count numeric, lpc_cost_one numeric, lpc_1c_number character varying, lpc_comment character varying, lpc_sum_transport numeric, lpc_custom numeric, usr_id integer, usr_code character varying, dep_id integer, dep_name character varying, prs_id integer, prs_name character varying, ctn_number character varying, lpc_occupied integer)
    LANGUAGE plpgsql
    AS $$
DECLARE _rec RECORD;
BEGIN
  FOR _rec IN SELECT l.lpc_id, l.prc_id, l.stf_id, l.prd_id,
      l.lpc_count, l.lpc_cost_one, l.lpc_1c_number, l.lpc_comment,
      l.lpc_sum_transport, l.lpc_custom, l.usr_id, l.dep_id, l.prs_id
    FROM dcl_prc_list_produce l WHERE l.prc_id = p_prc_id_in ORDER BY l.lpc_id
  LOOP
    lpc_id := _rec.lpc_id; prc_id := _rec.prc_id; stf_id := _rec.stf_id;
    prd_id := _rec.prd_id; lpc_count := _rec.lpc_count;
    lpc_cost_one := _rec.lpc_cost_one; lpc_1c_number := _rec.lpc_1c_number;
    lpc_comment := _rec.lpc_comment; lpc_sum_transport := _rec.lpc_sum_transport;
    lpc_custom := _rec.lpc_custom; usr_id := _rec.usr_id; dep_id := _rec.dep_id;
    prs_id := _rec.prs_id;
    stf_name := NULL; prd_name := NULL; prd_type := NULL; prd_params := NULL;
    prd_add_params := NULL; usr_code := NULL; dep_name := NULL; prs_name := NULL;
    ctn_number := NULL; lpc_occupied := NULL;
    IF (stf_id IS NOT NULL) THEN
      SELECT s.stf_name INTO stf_name FROM dcl_stuff_category s WHERE s.stf_id = _rec.stf_id;
    END IF;
    IF (prd_id IS NOT NULL) THEN
      SELECT p.prd_name, p.prd_type, p.prd_params, p.prd_add_params
        INTO prd_name, prd_type, prd_params, prd_add_params
        FROM dcl_produce p WHERE p.prd_id = _rec.prd_id;
    END IF;
    IF (usr_id IS NOT NULL) THEN
      SELECT u.usr_code INTO usr_code FROM dcl_user u WHERE u.usr_id = _rec.usr_id;
    END IF;
    IF (dep_id IS NOT NULL) THEN
      SELECT d.dep_name INTO dep_name FROM dcl_department d WHERE d.dep_id = _rec.dep_id;
    END IF;
    IF (prs_id IS NOT NULL) THEN
      SELECT ps.prs_name INTO prs_name FROM dcl_purpose ps WHERE ps.prs_id = _rec.prs_id;
    END IF;
    BEGIN
      SELECT cn.ctn_number_list INTO ctn_number FROM dcl_get_ctn_num_list_by_prd_id(_rec.prd_id) cn;
    EXCEPTION WHEN OTHERS THEN ctn_number := NULL;
    END;
    SELECT v.lpc_id INTO lpc_occupied FROM dcl_occupied_prc_produce_v v WHERE v.lpc_id = _rec.lpc_id;
    RETURN NEXT;
  END LOOP;
END $$;


--
-- Name: dcl_process_opr_unexecuted(integer, date); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_process_opr_unexecuted(IN p_ord_id integer, IN p_ord_executed_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_opr_id integer;
  v_opr_count_executed decimal(15,2);
  _rec RECORD;
BEGIN
  IF (p_ord_executed_date IS NULL) THEN
    p_ord_executed_date := CURRENT_DATE;
  END IF;
  FOR _rec IN SELECT opr.opr_id, 
    opr.opr_count - COALESCE((SELECT SUM(exe.opr_count_executed) FROM dcl_opr_list_executed exe WHERE exe.opr_id = opr.opr_id), 0) as remaining
  FROM dcl_ord_list_produce opr 
  WHERE opr.ord_id = p_ord_id 
    AND (opr.opr_count - COALESCE((SELECT SUM(exe.opr_count_executed) FROM dcl_opr_list_executed exe WHERE exe.opr_id = opr.opr_id), 0) > 0)
  LOOP
    v_opr_id := _rec.opr_id;
    v_opr_count_executed := _rec.remaining;
    INSERT INTO dcl_opr_list_executed (opr_id, opr_count_executed, opr_date_executed, opr_fictive_executed)
    VALUES (v_opr_id, v_opr_count_executed, p_ord_executed_date, 1);
  END LOOP;
END
$$;


--
-- Name: dcl_produce_bd0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_bd0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_attachment WHERE att_parent_id = old.prd_id and att.att_parent_table = 'DCL_PRODUCE';
RETURN OLD;
END
$$;


--
-- Name: dcl_produce_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PRD_ID IS NULL) THEN
    NEW.PRD_ID = nextval('gen_dcl_produce_id');
  ELSE
        ID = nextval('gen_dcl_produce_id');
        IF ( ID < NEW.PRD_ID ) THEN
          ID = nextval('gen_dcl_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_produce_cost_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PRC_ID IS NULL) THEN
    NEW.PRC_ID = nextval('gen_dcl_produce_cost_id');
  ELSE
        ID = nextval('gen_dcl_produce_cost_id');
        IF ( ID < NEW.PRC_ID ) THEN
          ID = nextval('gen_dcl_produce_cost_id');
  END IF;
  END IF;

  new.prc_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.prc_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_produce_cost_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.prc_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_produce_cost_filter(character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_filter(p_number character varying, p_route character varying, p_date_begin character varying, p_date_end character varying, p_number_1c character varying, p_block character varying) RETURNS TABLE(prc_id integer, prc_number character varying, prc_route character varying, prc_date date, prc_block smallint, usr_id_create integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_date_begin DATE;
  v_date_end DATE;
  v_number VARCHAR;
  v_route VARCHAR;
  v_number_1c VARCHAR;
  v_block SMALLINT;
  rec RECORD;
  v_lpc_count integer;
BEGIN
  v_date_begin := CASE WHEN p_date_begin IS NOT NULL AND p_date_begin != '' THEN p_date_begin::DATE ELSE NULL END;
  v_date_end := CASE WHEN p_date_end IS NOT NULL AND p_date_end != '' THEN p_date_end::DATE ELSE NULL END;
  v_number := UPPER(p_number);
  v_route := UPPER(p_route);
  v_number_1c := UPPER(p_number_1c);
  v_block := CASE WHEN p_block IS NOT NULL AND p_block != '' THEN p_block::SMALLINT ELSE NULL END;

  FOR rec IN
    SELECT prc.prc_id, prc.prc_number, prc.prc_date,
           (SELECT rut.rut_name FROM dcl_route rut WHERE rut.rut_id = prc.rut_id) AS r_route,
           prc.prc_block, prc.usr_id_create
    FROM dcl_produce_cost prc
    WHERE (v_route IS NULL OR (SELECT UPPER(r.rut_name) FROM dcl_route r WHERE r.rut_id = prc.rut_id) LIKE '%' || v_route || '%')
      AND (v_date_begin IS NULL OR prc.prc_date >= v_date_begin)
      AND (v_date_end IS NULL OR prc.prc_date <= v_date_end)
      AND (v_number IS NULL OR v_number = '' OR UPPER(prc.prc_number) LIKE '%' || v_number || '%')
      AND (v_block IS NULL OR (v_block = 1 AND prc.prc_block IS NULL))
    ORDER BY prc.prc_date DESC
  LOOP
    prc_id := rec.prc_id;
    prc_number := rec.prc_number;
    prc_route := rec.r_route;
    prc_date := rec.prc_date;
    prc_block := rec.prc_block;
    usr_id_create := rec.usr_id_create;

    IF v_number_1c IS NULL OR v_number_1c = '' THEN
      RETURN NEXT;
    ELSE
      SELECT COUNT(lpc.lpc_id) FROM dcl_prc_list_produce lpc WHERE lpc.prc_id = rec.prc_id AND UPPER(lpc.lpc_1c_number) LIKE '%' || v_number_1c || '%' INTO v_lpc_count;
      IF v_lpc_count != 0 THEN
        RETURN NEXT;
      END IF;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_produce_cost_insert(date, integer, character varying, smallint, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_insert(p_prc_date date, p_rut_id integer, p_prc_number character varying, p_prc_block smallint, p_prc_sum_transport numeric, p_prc_weight numeric, p_prc_course_ltl_eur numeric) RETURNS TABLE(prc_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_produce_cost (
      p_prc_number,
      p_prc_date,
      p_rut_id,
      p_prc_block,
      p_prc_sum_transport,
      p_prc_weight,
      p_prc_course_ltl_eur
  )
  values (
      p_prc_number,
      p_prc_date,
      p_rut_id,
      p_prc_block,
      p_prc_sum_transport,
      p_prc_weight,
      p_prc_course_ltl_eur
  )
  returning prc_id into prc_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_produce_cost_report(date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_report(p_date_begin date, p_date_end date, p_only_block smallint) RETURNS TABLE(prc_id integer, prc_date date, prc_number character varying, route character varying, weight numeric, transport numeric, custom numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  FOR _rec IN select prc.prc_id, prc.prc_date, prc.prc_number, prc.prc_weight, rut.rut_name from dcl_produce_cost prc, dcl_route rut where prc.prc_date >= p_date_begin and prc.prc_date <= p_date_end and rut.rut_id = prc.rut_id and (p_only_block is null or prc.prc_block = p_only_block )
  LOOP
    prc_id := _rec.prc_id;
    prc_date := _rec.prc_date;
    prc_number := _rec.prc_number;
    weight := _rec.weight;
    route := _rec.route;
      select sum(lpc.lpc_sum_transport),
             sum(lpc.lpc_custom)
      from dcl_prc_list_produce lpc
      where lpc.prc_id = prc_id
      into
        transport,
        custom
      ;

      RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_produce_cost_report_sum(date, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_cost_report_sum(p_date_begin date, p_date_end date, p_only_block smallint) RETURNS TABLE(prc_date date, weight numeric, transport numeric, custom numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  lt_begin timestamp;
  lt_end timestamp;
  _rec RECORD;
BEGIN
  FOR _rec IN select t_begin, t_end from DCL_GET_TIMESTAMP_BREAKDOWN(p_date_begin, p_date_end, 'MONTH')
  LOOP
    lt_begin := _rec.lt_begin;
    lt_end := _rec.lt_end;
    prc_date = lt_begin;

    select sum(weight),
           sum(transport),
           sum(custom)
    from dcl_produce_cost_report(lt_begin, lt_end, p_only_block)
    into weight,
         transport,
         custom
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_produce_in_spc_import(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_produce_in_spc_import(p_spc_id integer, p_prd_id integer, p_stf_id integer) RETURNS TABLE(opr_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_iterator INTEGER;
  _rec RECORD;
BEGIN
  opr_id := NULL;
  v_iterator := 0;
  FOR _rec IN SELECT opr.opr_id FROM dcl_ord_list_produce opr
    JOIN dcl_order ord ON opr.ord_id = ord.ord_id
    JOIN dcl_con_list_spec spc ON ord.spc_id = spc.spc_id
    WHERE spc.spc_id = p_spc_id AND opr.prd_id = p_prd_id AND opr.stf_id = p_stf_id
    ORDER BY opr.opr_id
  LOOP
    v_iterator := v_iterator + 1;
    IF (v_iterator = 1) THEN
      opr_id := _rec.opr_id;
    END IF;
  END LOOP;
  RETURN NEXT;
END $$;


--
-- Name: dcl_production_term_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_production_term_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PTR_ID IS NULL) THEN
    NEW.PTR_ID = nextval('gen_dcl_production_term_id');
  ELSE
        ID = nextval('gen_dcl_production_term_id');
        IF ( ID < NEW.PTR_ID ) THEN
          ID = nextval('gen_dcl_production_term_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_purchase_purpose_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_purchase_purpose_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PPS_ID IS NULL) THEN
    NEW.PPS_ID = nextval('gen_dcl_purchase_purpose_id');
  ELSE
        ID = nextval('gen_dcl_purchase_purpose_id');
        IF ( ID < NEW.PPS_ID ) THEN
          ID = nextval('gen_dcl_purchase_purpose_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_purpose_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_purpose_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.PRS_ID IS NULL) THEN
    NEW.PRS_ID = nextval('gen_dcl_purpose_id');
  ELSE
        ID = nextval('gen_dcl_purpose_id');
        IF ( ID < NEW.PRS_ID ) THEN
          ID = nextval('gen_dcl_purpose_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_rate_nds_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_rate_nds_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.RTN_ID IS NULL) THEN
    NEW.RTN_ID = nextval('gen_dcl_rate_nds_id');
  ELSE
        ID = nextval('gen_dcl_rate_nds_id');
        IF ( ID < NEW.RTN_ID ) THEN
          ID = nextval('gen_dcl_rate_nds_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_ready_for_shipping_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_ready_for_shipping_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.RFS_ID IS NULL) THEN
    NEW.RFS_ID = nextval('gen_dcl_ready_for_shipping_id');
  ELSE
        ID = nextval('gen_dcl_ready_for_shipping_id');
        IF ( ID < NEW.RFS_ID ) THEN
          ID = nextval('gen_dcl_ready_for_shipping_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_reputation_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_reputation_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.RPT_ID IS NULL) THEN
    NEW.RPT_ID = nextval('gen_dcl_reputation_id');
  ELSE
        ID = nextval('gen_dcl_reputation_id');
        IF ( ID < NEW.RPT_ID ) THEN
          ID = nextval('gen_dcl_reputation_id');
  END IF;
  END IF;

  if ( new.rpt_default_in_ctc = 1 ) then
    UPDATE dcl_reputation SET rpt_default_in_ctc = null where rpt_id != new.rpt_id and rpt_default_in_ctc = 1;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_reputation_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_reputation_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  if ( new.rpt_default_in_ctc = 1 ) then
    UPDATE dcl_reputation SET rpt_default_in_ctc = null where rpt_id != old.rpt_id and rpt_default_in_ctc = 1;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_role_bio_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_role_bio_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ROL_ID IS NULL) THEN
    NEW.ROL_ID = nextval('gen_dcl_role_id');
  ELSE
        ID = nextval('gen_dcl_role_id');
        IF ( ID < NEW.ROL_ID ) THEN
          ID = nextval('gen_dcl_role_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_route_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_route_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.RUT_ID IS NULL) THEN
    NEW.RUT_ID = nextval('gen_dcl_route_id');
  ELSE
        ID = nextval('gen_dcl_route_id');
        IF ( ID < NEW.RUT_ID ) THEN
          ID = nextval('gen_dcl_route_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_save_cfc_eco_msg(integer, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_save_cfc_eco_msg(IN p_economist_role_id integer, IN p_uln_url character varying, IN p_uln_parameters character varying, IN p_uln_text character varying, IN p_uln_menu_id character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM dcl_user_link uln WHERE uln.uln_url = p_uln_url AND uln.uln_parameters = p_uln_parameters;

  INSERT INTO dcl_user_link (usr_id, uln_url, uln_parameters, uln_text, uln_menu_id)
  SELECT ur.usr_id, p_uln_url, p_uln_parameters, p_uln_text, p_uln_menu_id
  FROM dcl_user_role ur
  WHERE ur.rol_id = p_economist_role_id;
END
$$;


--
-- Name: dcl_save_cfc_messages(integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_save_cfc_messages(IN p_cfc_id integer, IN p_ctr_id integer, IN p_msg character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_usr_id_create integer;
  v_usr_id_place integer;
BEGIN
   SELECT cfc.usr_id_create, cfc.usr_id_place INTO v_usr_id_create, v_usr_id_place 
   FROM dcl_cond_for_contract cfc WHERE cfc.cfc_id = p_cfc_id;
   
   INSERT INTO dcl_cfc_message (cfc_id, usr_id, ccm_message, ctr_id) VALUES (p_cfc_id, v_usr_id_create, p_msg, p_ctr_id);
   IF (v_usr_id_create != v_usr_id_place) THEN
     INSERT INTO dcl_cfc_message (cfc_id, usr_id, ccm_message, ctr_id) VALUES (p_cfc_id, v_usr_id_place, p_msg, p_ctr_id);
   END IF;
END
$$;


--
-- Name: dcl_save_contract_messages(integer, integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_save_contract_messages(IN p_con_id integer, IN p_spc_id integer, IN p_ctr_id integer, IN p_msg character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_usr_id integer;
BEGIN
  IF (p_spc_id IS NOT NULL) THEN
    SELECT cls.usr_id INTO v_usr_id FROM dcl_con_list_spec cls WHERE cls.spc_id = p_spc_id;
    INSERT INTO dcl_con_message (spc_id, usr_id, cms_message, ctr_id) VALUES (p_spc_id, v_usr_id, p_msg, p_ctr_id);
  END IF;
  IF (p_con_id IS NOT NULL) THEN
    FOR v_usr_id IN SELECT DISTINCT cls.usr_id FROM dcl_con_list_spec cls WHERE cls.con_id = p_con_id
    LOOP
      INSERT INTO dcl_con_message (con_id, usr_id, cms_message, ctr_id) VALUES (p_con_id, v_usr_id, p_msg, p_ctr_id);
    END LOOP;
  END IF;
END
$$;


--
-- Name: dcl_save_ord_messages(integer, integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_save_ord_messages(IN p_ord_id integer, IN p_prc_id integer, IN p_manager_role_id integer, IN p_msg character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_usr_id_create integer;
  v_dep_id integer;
  v_usr_chief_dep smallint;
  v_user_count integer;
  v_usr_chief_id integer;
  _rec RECORD;
BEGIN
  SELECT o.usr_id_create INTO v_usr_id_create FROM dcl_order o WHERE o.ord_id = p_ord_id;

  SELECT COUNT(ur.usr_id) INTO v_user_count FROM dcl_user_role ur WHERE ur.usr_id = v_usr_id_create AND ur.rol_id = p_manager_role_id;

  IF (v_user_count > 0) THEN
    SELECT u.dep_id, u.usr_chief_dep INTO v_dep_id, v_usr_chief_dep FROM dcl_user u WHERE u.usr_id = v_usr_id_create;

    INSERT INTO dcl_ord_message (usr_id, orm_message, ord_id, prc_id) VALUES (v_usr_id_create, p_msg, p_ord_id, p_prc_id);
    
    IF (v_usr_chief_dep IS NULL) THEN
      FOR _rec IN SELECT u.usr_id FROM dcl_user u WHERE u.dep_id = v_dep_id AND u.usr_chief_dep = 1 AND u.usr_no_login IS NULL
      LOOP
        v_usr_chief_id := _rec.usr_id;
        IF (v_usr_id_create != v_usr_chief_id) THEN
          INSERT INTO dcl_ord_message (usr_id, orm_message, ord_id, prc_id) VALUES (v_usr_chief_id, p_msg, p_ord_id, p_prc_id);
        END IF;
      END LOOP;
    END IF;
  END IF;
END
$$;


--
-- Name: dcl_save_payment_messages(integer, integer, character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_save_payment_messages(IN p_pay_id integer, IN p_manager_role_id integer, IN p_msg_received_payment character varying, IN p_msg_received_payment_by_con character varying, IN p_msg_from character varying, IN p_msg_spec character varying, IN p_msg_comment character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_ctr_id INTEGER; v_pay_summ DECIMAL(15,2); v_pay_sum_count INTEGER;
  v_pay_block SMALLINT; v_lps_summ DECIMAL(15,2); v_spc_number VARCHAR(50);
  v_con_number VARCHAR(50); v_usr_id INTEGER; v_spc_date DATE; v_con_date DATE;
  v_spc_date_str VARCHAR(10); v_con_date_str VARCHAR(10);
  v_pms_percent DECIMAL(15,2); v_lps_all_sum DECIMAL(15,2);
  v_cur_id INTEGER; v_spc_sum DECIMAL(15,2);
  v_contractor_user_count INTEGER; v_usr_id1 INTEGER;
  _rec RECORD; _rec2 RECORD;
BEGIN
  UPDATE dcl_pay_message SET pms_check_for_delete = 1 WHERE pay_id = p_pay_id;
  
  SELECT ctr_id, pay_summ, pay_block, cur_id
    INTO v_ctr_id, v_pay_summ, v_pay_block, v_cur_id
    FROM dcl_payment WHERE pay_id = p_pay_id;
  
  IF (v_ctr_id IS NULL) THEN
    INSERT INTO dcl_pay_message (pay_id, usr_id, pms_message, pms_sum, cur_id)
      SELECT p_pay_id, usr_role.usr_id, p_msg_received_payment || COALESCE(p_msg_comment, ''), v_pay_summ, v_cur_id
      FROM dcl_user_role usr_role WHERE usr_role.rol_id = p_manager_role_id;
  ELSE
    v_contractor_user_count := 0;
    SELECT COUNT(ctr_usr.usr_id) INTO v_contractor_user_count
      FROM dcl_contractor_user ctr_usr
      JOIN dcl_user_role usr_role ON ctr_usr.usr_id = usr_role.usr_id
      WHERE ctr_usr.ctr_id = COALESCE(v_ctr_id, -1)
        AND usr_role.rol_id = p_manager_role_id;
    
    SELECT COUNT(lps_id) INTO v_pay_sum_count FROM dcl_pay_list_summ WHERE pay_id = p_pay_id;
    
    IF (v_pay_sum_count = 0 AND v_contractor_user_count > 0) THEN
      FOR _rec IN SELECT usr_role.usr_id FROM dcl_user_role usr_role
        JOIN dcl_contractor_user ctr_usr ON ctr_usr.usr_id = usr_role.usr_id
        WHERE usr_role.rol_id = p_manager_role_id AND ctr_usr.ctr_id = COALESCE(v_ctr_id, -1)
      LOOP
        INSERT INTO dcl_pay_message (pay_id, usr_id, pms_message, pms_sum, cur_id)
          VALUES (p_pay_id, _rec.usr_id, p_msg_received_payment || COALESCE(p_msg_comment, ''), v_pay_summ, v_cur_id);
      END LOOP;
    ELSIF (v_pay_sum_count > 0) THEN
      FOR _rec IN SELECT lps.spc_id, lps.lps_summ, spc.spc_number, spc.spc_date,
          con.con_number, con.con_date
        FROM dcl_pay_list_summ lps
        JOIN dcl_con_list_spec spc ON spc.spc_id = lps.spc_id
        JOIN dcl_contract con ON con.con_id = spc.con_id
        WHERE lps.pay_id = p_pay_id
      LOOP
        v_spc_number := _rec.spc_number; v_con_number := _rec.con_number;
        v_lps_summ := _rec.lps_summ; v_spc_date := _rec.spc_date; v_con_date := _rec.con_date;
        v_spc_date_str := ''; v_con_date_str := '';
        IF (v_spc_date IS NOT NULL) THEN
          SELECT d.strdate INTO v_spc_date_str FROM date2str(v_spc_date) d;
        END IF;
        IF (v_con_date IS NOT NULL) THEN
          SELECT d.strdate INTO v_con_date_str FROM date2str(v_con_date) d;
        END IF;
        
        v_lps_all_sum := 0; v_spc_sum := 0;
        SELECT COALESCE(SUM(l2.lps_summ), 0) INTO v_lps_all_sum FROM dcl_pay_list_summ l2 WHERE l2.pay_id = p_pay_id;
        IF (v_lps_all_sum > 0) THEN
          v_pms_percent := (v_lps_summ / v_lps_all_sum) * 100;
        ELSE
          v_pms_percent := 0;
        END IF;
        
        FOR _rec2 IN SELECT usr_role.usr_id FROM dcl_user_role usr_role
          JOIN dcl_contractor_user ctr_usr ON ctr_usr.usr_id = usr_role.usr_id
          WHERE usr_role.rol_id = p_manager_role_id AND ctr_usr.ctr_id = COALESCE(v_ctr_id, -1)
        LOOP
          INSERT INTO dcl_pay_message (pay_id, usr_id, pms_message, pms_sum, pms_percent, cur_id)
            VALUES (p_pay_id, _rec2.usr_id,
              p_msg_received_payment_by_con || p_msg_from || ' ' || v_con_number || ' ' || v_con_date_str || ' ' || p_msg_spec || ' ' || v_spc_number || ' ' || v_spc_date_str || COALESCE(p_msg_comment, ''),
              v_lps_summ, v_pms_percent, v_cur_id);
        END LOOP;
      END LOOP;
    ELSE
      FOR _rec IN SELECT usr_role.usr_id FROM dcl_user_role usr_role
        WHERE usr_role.rol_id = p_manager_role_id
      LOOP
        INSERT INTO dcl_pay_message (pay_id, usr_id, pms_message, pms_sum, cur_id)
          VALUES (p_pay_id, _rec.usr_id, p_msg_received_payment || COALESCE(p_msg_comment, ''), v_pay_summ, v_cur_id);
      END LOOP;
    END IF;
  END IF;
  
  DELETE FROM dcl_pay_message WHERE pay_id = p_pay_id AND pms_check_for_delete = 1;
END $$;


--
-- Name: dcl_seller_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_seller_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SLN_ID IS NULL) THEN
    NEW.SLN_ID = nextval('gen_dcl_seller_id');
  ELSE
        ID = nextval('gen_dcl_seller_id');
        IF ( ID < NEW.SLN_ID ) THEN
          ID = nextval('gen_dcl_seller_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_serial_number_filter(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_serial_number_filter(p_prd_id_in integer, p_serial_number_in character varying) RETURNS TABLE(lps_id integer, stf_name character varying, lps_serial_num character varying, lps_year_out character varying, mad_complexity character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  p_serial_number_in = upper(p_serial_number_in);

  FOR _rec IN select lps.lps_id, lps.lps_serial_num, lps.lps_year_out, (select stf_name from dcl_stuff_category stf where stf.stf_id = lps.stf_id) as stf_name, mad.mad_complexity from dcl_prc_list_produce lpc, dcl_shp_list_produce lps, dcl_catalog_number ctn left join dcl_montage_adjustment mad on mad.mad_id = ctn.mad_id where lpc.prd_id = p_prd_id_in and lps.lpc_id = lpc.lpc_id and ctn.prd_id = p_prd_id_in and ctn.stf_id = lps.stf_id and ( p_serial_number_in is null or p_serial_number_in like '' or upper(lps.lps_serial_num) like '%' || p_serial_number_in || '%' )
  LOOP
    lps_id := _rec.lps_id;
    lps_serial_num := _rec.lps_serial_num;
    lps_year_out := _rec.lps_year_out;
    stf_name := _rec.stf_name;
    mad_complexity := _rec.mad_complexity;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_setting_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_setting_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.STN_ID IS NULL) THEN
    NEW.STN_ID = nextval('gen_dcl_setting_id');
  ELSE
        ID = nextval('gen_dcl_setting_id');
        IF ( ID < NEW.STN_ID ) THEN
          ID = nextval('gen_dcl_setting_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_shipping_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SHP_ID IS NULL) THEN
    NEW.SHP_ID = nextval('gen_dcl_shipping_id');
  ELSE
        ID = nextval('gen_dcl_shipping_id');
        IF ( ID < NEW.SHP_ID ) THEN
          ID = nextval('gen_dcl_shipping_id');
  END IF;
  END IF;

  new.shp_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.shp_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_shipping_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.shp_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_shipping_filter(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_filter(p_number character varying, p_contractor character varying, p_date_begin character varying, p_date_end character varying, p_summ_min character varying, p_summ_max character varying, p_block character varying, p_closed character varying, p_cur_id character varying, p_seller character varying) RETURNS TABLE(shp_id integer, shp_number character varying, shp_date date, shp_contractor character varying, shp_summ_plus_nds numeric, shp_currency character varying, shp_block smallint, usr_id_create integer, count_day integer, shp_date_expiration date, shp_summ numeric, pay_summ numeric, not_show_msg smallint, shp_closed smallint, usr_id_list character varying, dep_id_list character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_number VARCHAR; v_contractor VARCHAR; v_seller VARCHAR;
  v_date_begin DATE; v_date_end DATE;
  v_summ_min DECIMAL(15,2); v_summ_max DECIMAL(15,2);
  v_block SMALLINT; v_closed INTEGER; v_cur_id INTEGER;
  rec RECORD;
  v_spc_id INTEGER;
  v_shp_closed SMALLINT;
BEGIN
  v_number := UPPER(p_number);
  v_contractor := UPPER(p_contractor);
  v_seller := UPPER(p_seller);
  v_date_begin := CASE WHEN p_date_begin IS NOT NULL AND p_date_begin != '' THEN p_date_begin::DATE ELSE NULL END;
  v_date_end := CASE WHEN p_date_end IS NOT NULL AND p_date_end != '' THEN p_date_end::DATE ELSE NULL END;
  v_summ_min := CASE WHEN p_summ_min IS NOT NULL AND p_summ_min != '' THEN p_summ_min::DECIMAL(15,2) ELSE NULL END;
  v_summ_max := CASE WHEN p_summ_max IS NOT NULL AND p_summ_max != '' THEN p_summ_max::DECIMAL(15,2) ELSE NULL END;
  v_block := CASE WHEN p_block IS NOT NULL AND p_block != '' THEN p_block::SMALLINT ELSE NULL END;
  v_closed := CASE WHEN p_closed IS NOT NULL AND p_closed != '' THEN p_closed::INTEGER ELSE NULL END;
  v_cur_id := CASE WHEN p_cur_id IS NOT NULL AND p_cur_id != '' THEN p_cur_id::INTEGER ELSE NULL END;

  FOR rec IN
    SELECT s.shp_id, s.shp_number, s.shp_date,
           (SELECT ctr.ctr_name FROM dcl_contractor ctr WHERE ctr.ctr_id = s.ctr_id) AS r_contractor,
           s.shp_summ_plus_nds,
           (SELECT cur.cur_name FROM dcl_currency cur WHERE cur.cur_id = s.cur_id) AS r_currency,
           s.shp_block, s.usr_id_create,
           (SELECT cd.count_day FROM dcl_get_count_day(CURRENT_DATE, s.shp_date_expiration) cd) AS r_count_day,
           s.shp_date_expiration, s.spc_id
    FROM dcl_shipping s
    WHERE (v_contractor IS NULL OR (SELECT UPPER(c.ctr_name) FROM dcl_contractor c WHERE c.ctr_id = s.ctr_id) LIKE '%' || v_contractor || '%')
      AND (v_cur_id IS NULL OR s.cur_id = v_cur_id)
      AND (v_block IS NULL OR s.shp_block = v_block)
      AND (v_date_begin IS NULL OR s.shp_date >= v_date_begin)
      AND (v_date_end IS NULL OR s.shp_date <= v_date_end)
      AND (v_summ_min IS NULL OR s.shp_summ_plus_nds >= v_summ_min)
      AND (v_summ_max IS NULL OR s.shp_summ_plus_nds <= v_summ_max)
      AND (v_number IS NULL OR UPPER(s.shp_number) LIKE '%' || v_number || '%')
      AND (v_seller IS NULL OR v_seller = '' OR
           (SELECT UPPER(sln.sln_name) FROM dcl_seller sln, dcl_contract con, dcl_con_list_spec spc
            WHERE sln.sln_id = con.sln_id AND con.con_id = spc.con_id AND spc.spc_id = s.spc_id) LIKE '%' || v_seller || '%')
    ORDER BY s.shp_date DESC
  LOOP
    shp_id := rec.shp_id;
    shp_number := rec.shp_number;
    shp_date := rec.shp_date;
    shp_contractor := rec.r_contractor;
    shp_summ_plus_nds := rec.shp_summ_plus_nds;
    shp_currency := rec.r_currency;
    shp_block := rec.shp_block;
    usr_id_create := rec.usr_id_create;
    count_day := rec.r_count_day;
    shp_date_expiration := rec.shp_date_expiration;
    v_spc_id := rec.spc_id;

    SELECT h.usr_id_list, h.dep_id_list FROM dcl_get_usr_id_list_shp(rec.shp_id, v_spc_id) h INTO usr_id_list, dep_id_list;

    not_show_msg := NULL;
    SELECT isc.is_shp_closed FROM dcl_is_shp_closed(rec.shp_id) isc INTO v_shp_closed;
    shp_closed := v_shp_closed;

    IF v_closed = 0 THEN
      RETURN NEXT;
    ELSIF v_closed = 1 THEN
      IF v_shp_closed IS NOT NULL THEN
        RETURN NEXT;
      END IF;
    ELSIF v_closed = -1 THEN
      IF v_shp_closed IS NULL THEN
        IF v_spc_id IS NOT NULL THEN
          SELECT SUM(sh.shp_summ_plus_nds) FROM dcl_shipping sh WHERE sh.spc_id = v_spc_id INTO shp_summ;
          SELECT SUM(pls.lps_summ) FROM dcl_pay_list_summ pls WHERE pls.spc_id = v_spc_id INTO pay_summ;
          IF shp_summ <= pay_summ THEN
            not_show_msg := 1;
          END IF;
        END IF;
        RETURN NEXT;
      END IF;
    ELSE
      RETURN NEXT;
    END IF;
  END LOOP;
END;
$$;


--
-- Name: dcl_shipping_goods(date, integer, integer, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_goods(p_date_in date, p_usr_id_in integer, p_dep_id_in integer, p_date_to_in date, p_stf_id_in integer) RETURNS TABLE(lpc_id integer, prd_id integer, produce_name character varying, stf_name character varying, usr_id integer, usr_name character varying, dep_id integer, dep_name character varying, unit character varying, lpc_count numeric, lpc_count_free numeric, shp_date date, ctr_name character varying, less_3_month numeric, month_3_6 numeric, month_6_9 numeric, month_9_12 numeric, more_12_month numeric, lpc_count_free_to numeric, less_3_month_to numeric, month_3_6_to numeric, month_6_9_to numeric, month_9_12_to numeric, more_12_month_to numeric, debt_summ numeric, debt_currency character varying, purpose character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, ctn_number character varying, lpc_1c_number character varying, lpc_comment character varying, usr_shipping character varying, produce_name_sort character varying, stf_name_sort character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  need_suspend integer;
  sum_eur decimal(15,2);
  sum_eur_to decimal(15,2);
  shp_id integer;
  lmn_usr_id integer;
  stf_id integer;
  date_check date;
  lmn_percent decimal(3,0);
  sum_other_charges decimal(15,2);
  lpc_cost_one decimal(15,2);
  _rec RECORD;
  _rec2 RECORD;
BEGIN
  if ( p_date_to_in is null ) THEN
  date_check := p_date_in;
  ELSE
  date_check := p_date_to_in;
  END IF;

  FOR _rec IN select shp.shp_id, shp.shp_date, ctr.ctr_name, cur.cur_name from dcl_shipping shp, dcl_contractor ctr, dcl_currency cur where shp.shp_date <= date_check and shp.shp_summ_plus_nds > 0 and ( shp.spc_id is null or not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id ) ) and ctr.ctr_id = shp.ctr_id and cur.cur_id = shp.cur_id
  LOOP
    shp_id := _rec.shp_id;
    shp_date := _rec.shp_date;
    ctr_name := _rec.ctr_name;
    debt_currency := _rec.cur_name;
  FOR _rec2 IN select coalesce (lps.lps_count, 0), lps.lps_summ_plus_nds, lmn.usr_id, lmn.lmn_percent, lpc.lpc_id, lpc.lpc_count, lpc.lpc_sum_transport + lpc.lpc_custom, lpc.lpc_cost_one, lpc.lpc_1c_number, lpc.lpc_comment, stf.stf_id, stf.stf_name, prs.prs_name, lpc.prd_id, lpc.usr_id, lpc.dep_id from dcl_shp_list_produce lps, dcl_prc_list_produce lpc, dcl_lps_list_manager lmn, dcl_stuff_category stf, dcl_purpose prs where lps.shp_id = shp_id and lps.lpc_id = lpc.lpc_id and lmn.lps_id = lps.lps_id and stf.stf_id = lpc.stf_id and prs.prs_id = lpc.prs_id and lpc.lpc_count != 0 and coalesce (lps.lps_count, 0) != 0 and (p_stf_id_in is null or p_stf_id_in = -1 or p_stf_id_in = stf.stf_id )
  LOOP
    lpc_count_free := _rec2.lps_summ_plus_nds;
    debt_summ := _rec2.usr_id;
    lmn_usr_id := _rec2.lmn_percent;
    lmn_percent := _rec2.lpc_id;
    lpc_id := _rec2.lpc_count;
    lpc_count := _rec2.lpc_custom;
    sum_other_charges := _rec2.lpc_cost_one;
    lpc_cost_one := _rec2.lpc_1c_number;
    lpc_1c_number := _rec2.lpc_comment;
    lpc_comment := _rec2.stf_id;
    stf_id := _rec2.stf_name;
    stf_name := _rec2.prs_name;
    purpose := _rec2.prd_id;
    prd_id := _rec2.usr_id;
    usr_id := _rec2.dep_id;
    dep_id := _rec2.dep_id;
  if ( lmn_percent != 100 ) THEN
  debt_summ := debt_summ * lmn_percent / 100;
  END IF;
  if ( lmn_usr_id is not null ) THEN
  SELECT usr_lng_shp.usr_surname || ' ' || usr_lng_shp.usr_name
    INTO usr_shipping
    from dcl_user_language usr_lng_shp
where usr_lng_shp.usr_id = lmn_usr_id and
usr_lng_shp.lng_id = 1;
  END IF;
  SELECT prd.prd_name,
prd.prd_type,
prd.prd_params,
prd.prd_add_params,
(
select ctn.ctn_number
from dcl_catalog_number ctn
where ctn.stf_id = stf_id and
ctn.prd_id = prd.prd_id
),
unt.unt_name
    INTO produce_name,
prd_type,
prd_params,
prd_add_params,
ctn_number,
unit

    from  dcl_produce prd,
dcl_unit_language unt
where prd.prd_id = prd_id and
unt.unt_id = prd.unt_id and
unt.lng_id = 1;

  need_suspend := 1;
  if ( p_usr_id_in is null or p_usr_id_in = -1 ) THEN
  need_suspend := 1;
  ELSE
  if ( p_usr_id_in != usr_id or usr_id is null  ) THEN
  need_suspend := 0;
  END IF;
  END IF;

  usr_name := null;
  dep_name := null;
  if ( need_suspend = 1 and usr_id is not null ) THEN
  SELECT usr_lng.usr_surname || ' ' || usr_lng.usr_name
    INTO usr_name
    from dcl_user_language usr_lng
where usr_lng.usr_id = usr_id and
usr_lng.lng_id = 1;
  END IF;
  if ( need_suspend = 1 and p_dep_id_in is null or p_dep_id_in = -1 ) THEN
  need_suspend := 1;
  ELSE
  if ( p_dep_id_in != dep_id or dep_id is null ) THEN
  need_suspend := 0;
  END IF;
  END IF;

  if ( need_suspend = 1 and dep_id is not null ) THEN
  SELECT dep_name
    INTO dep_name
    from dcl_department where dep_id = dep_id;
  END IF;
  if ( p_date_to_in is not null ) THEN
  lpc_count_free_to := lpc_count_free;
  if ( shp_date > p_date_in ) THEN
  lpc_count_free := 0;
  END IF;
  if ( lpc_count_free = 0 and lpc_count_free_to = 0 ) THEN
  need_suspend := 0;
  END IF;
  END IF;
  if ( need_suspend = 1 ) THEN
  less_3_month := 0;
  month_3_6 := 0;
  month_6_9 := 0;
  month_9_12 := 0;
  more_12_month := 0;

  sum_eur := ( lpc_cost_one + sum_other_charges / lpc_count ) * lpc_count_free;
  if ( lmn_percent != 100 ) THEN
  sum_eur := sum_eur * lmn_percent / 100;
  END IF;
  if ( shp_date >= addday(p_date_in, -30 * 1) ) THEN
  less_3_month := sum_eur;
  ELSE
  if ( shp_date >= addday(p_date_in, -30 * 2) ) THEN
  month_3_6 := sum_eur;
  ELSE
  if ( shp_date >= addday(p_date_in, -30 * 3) ) THEN
  month_6_9 := sum_eur;
  ELSE
  if ( shp_date >= addday(p_date_in, -30 * 6) ) THEN
  month_9_12 := sum_eur;
  ELSE
  more_12_month := sum_eur;
  END IF;
  END IF;
  END IF;
  END IF;

  if ( p_date_to_in is not null ) THEN
  less_3_month_to := 0;
  month_3_6_to := 0;
  month_6_9_to := 0;
  month_9_12_to := 0;
  more_12_month_to := 0;

  sum_eur_to := ( lpc_cost_one + sum_other_charges / lpc_count ) * lpc_count_free_to;
  if ( lmn_percent != 100 ) THEN
  sum_eur_to := sum_eur_to * lmn_percent / 100;
  END IF;
  if ( shp_date >= addday(p_date_to_in, -30 * 1) ) THEN
  less_3_month_to := sum_eur_to;
  ELSE
  if ( shp_date >= addday(p_date_to_in, -30 * 2) ) THEN
  month_3_6_to := sum_eur_to;
  ELSE
  if ( shp_date >= addday(p_date_to_in, -30 * 3) ) THEN
  month_6_9_to := sum_eur_to;
  ELSE
  if ( shp_date >= addday(p_date_to_in, -30 * 6) ) THEN
  month_9_12_to := sum_eur_to;
  ELSE
  more_12_month_to := sum_eur_to;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  produce_name_sort := upper(produce_name || ' ' || prd_type || ' ' || prd_params || ' ' || prd_add_params);
  stf_name_sort := upper(stf_name);
  RETURN NEXT;
  END IF;
  END LOOP;
  END LOOP;
END
$$;


--
-- Name: dcl_shipping_insert(character varying, date, date, integer, numeric, integer, integer, date, date, date, date, character varying, smallint, smallint, integer, integer, date, numeric, smallint, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_insert(p_shp_number character varying, p_shp_date date, p_shp_date_expiration date, p_spc_id integer, p_shp_summ_plus_nds numeric, p_cur_id integer, p_ctr_id integer, p_shp_letter1_date date, p_shp_letter2_date date, p_shp_letter3_date date, p_shp_complaint_in_court_date date, p_shp_comment character varying, p_shp_montage smallint, p_shp_serial_num_year_out smallint, p_ctr_id_where integer, p_con_id_where integer, p_shp_notice_date date, p_shp_summ_transport numeric, p_shp_original smallint, p_shp_sum_update numeric) RETURNS TABLE(shp_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_shipping (
    p_shp_number,
    p_shp_date,
    p_shp_date_expiration,
    p_spc_id,
    p_shp_summ_plus_nds,
    p_cur_id,
    p_ctr_id,
    p_shp_letter1_date,
    p_shp_letter2_date,
    p_shp_letter3_date,
    p_shp_complaint_in_court_date,
    p_shp_comment,
    p_shp_montage,
    p_shp_serial_num_year_out,
    p_ctr_id_where,
    p_con_id_where,
    p_shp_notice_date,
    p_shp_summ_transport,
    p_shp_original,
    p_shp_sum_update
  )
  values (
    p_shp_number,
    p_shp_date,
    p_shp_date_expiration,
    p_spc_id,
    p_shp_summ_plus_nds,
    p_cur_id,
    p_ctr_id,
    p_shp_letter1_date,
    p_shp_letter2_date,
    p_shp_letter3_date,
    p_shp_complaint_in_court_date,
    p_shp_comment,
    p_shp_montage,
    p_shp_serial_num_year_out,
    p_ctr_id_where,
    p_con_id_where,
    p_shp_notice_date,
    p_shp_summ_transport,
    p_shp_original,
    p_shp_sum_update
  )
  returning shp_id into shp_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_shipping_report(date, date, integer, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_report(p_date_begin date, p_date_end date, p_ctr_id integer, p_not_include_zero smallint, p_include_type smallint) RETURNS TABLE(shp_id integer, shp_number character varying, shp_date date, shp_contractor character varying, shp_prd_count integer, shp_summ_plus_nds numeric, shp_sum_nr numeric, con_number character varying, con_date date, spc_number character varying, spc_date date, spc_summ numeric, shp_closed integer, currency character varying, prd_id integer, prd_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, ctn_number character varying, stf_id integer, stf_name character varying, lps_id integer, lps_count numeric, lps_summ_plus_nds numeric, lps_summ_out_nds numeric, lps_summ_out_nds_eur numeric, lps_summ_zak numeric, manager_id integer, manager character varying, department character varying, lps_sum_transport numeric, lps_custom numeric, country character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spc_id integer;
  spc_nds_rate decimal(15,2);
  need_suspend smallint;
  temporary_f float;
  shp_cut_id integer;
  manager_local varchar(50);
  department_local varchar(100);
  eur_cur_id integer;
  eur_crt_rate decimal(15,2);
  cur_id integer;
  crt_rate decimal(15,2);
  _rec RECORD;
BEGIN
  SELECT cur_id INTO eur_cur_id FROM dcl_currency where cur_name = 'EUR';

  FOR _rec IN select shp.shp_id, shp.shp_number, shp.shp_date, shp.shp_summ_plus_nds - coalesce((select sum(lps.lps_summ_plus_nds) from dcl_shp_list_produce lps where lps.shp_id = shp.shp_id), 0), ctr.ctr_name, ctr.cut_id, shp.spc_id, shp.shp_summ_plus_nds, cur.cur_id, cur.cur_name from dcl_shipping shp, dcl_contractor ctr, dcl_currency cur where shp_date >= p_date_begin and shp_date <= p_date_end and ( p_ctr_id is null or p_ctr_id = -1 or shp.p_ctr_id = p_ctr_id ) and ctr.p_ctr_id = shp.p_ctr_id and cur.cur_id = shp.cur_id
  LOOP
    shp_id := _rec.shp_id;
    shp_number := _rec.shp_number;
    shp_date := _rec.shp_date;
    shp_sum_nr := _rec.shp_sum_nr;
    shp_contractor := _rec.shp_contractor;
    shp_cut_id := _rec.shp_cut_id;
    spc_id := _rec.spc_id;
    shp_summ_plus_nds := _rec.shp_summ_plus_nds;
    cur_id := _rec.cur_id;
    currency := _rec.currency;
    shp_closed := null;
    SELECT shp_id INTO shp_closed FROM dcl_ctc_shp where shp_id = shp_id;

    country := null;
    SELECT cut_name INTO country FROM dcl_country where cut_id = shp_cut_id;

    need_suspend := null;
    IF ( p_include_type = 1 or p_include_type = 2 ) THEN
      IF ( (shp_closed is not null and p_include_type = 1) or (shp_closed is null and p_include_type = 2) ) THEN
        need_suspend := 1;
      END IF;
    ELSE
      need_suspend := 1;
    END IF;

    IF ( need_suspend = 1 ) THEN
      con_number := null;
      con_date := null;
      spc_number := null;
      spc_date := null;
      spc_summ := null;
      spc_nds_rate := null;
      lps_count := null;
      lps_summ_plus_nds := null;
      lps_summ_zak := null;
      lps_sum_transport := null;
      lps_custom := null;
      lps_summ_out_nds := null;
      lps_summ_out_nds_eur := null;

      SELECT con.con_number, con.con_date, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_nds_rate
        INTO con_number, con_date, spc_number, spc_date, spc_summ, spc_nds_rate
        from   dcl_contract con, dcl_con_list_spec spc where  spc.spc_id = spc_id and con.con_id = spc.con_id;

      SELECT count(lps.lps_id) INTO shp_prd_count FROM dcl_shp_list_produce lps where shp_id = shp_id;
      IF ( p_not_include_zero is null or ( p_not_include_zero is not null and shp_summ_plus_nds != 0 ) ) THEN
        FOR _rec IN select lps.lps_id, lpc.prd_id, lpc.stf_id, ( select stf.stf_name from dcl_stuff_category stf where stf.stf_id = lpc.stf_id ), lps.lps_count, lps.lps_summ_plus_nds, lpc.lpc_cost_one * lps.lps_count, lpc.lpc_sum_transport / lpc.lpc_count * lps.lps_count, lpc.lpc_custom / lpc.lpc_count * lps.lps_count from dcl_shp_list_produce lps, dcl_prc_list_produce lpc where shp_id = shp_id and lpc.lpc_id = lps.lpc_id
        LOOP
          lps_id := _rec.lps_id;
          prd_id := _rec.prd_id;
          stf_id := _rec.stf_id;
          stf_name := _rec.stf_name;
          lps_count := _rec.lps_count;
          lps_summ_plus_nds := _rec.lps_summ_plus_nds;
          lps_summ_zak := _rec.lps_summ_zak;
          lps_sum_transport := _rec.lps_sum_transport;
          lps_custom := _rec.lps_custom;
          prd_name := null;
          prd_type := null;
          prd_params := null;
          prd_add_params := null;
          ctn_number := null;

          SELECT prd.prd_name, prd.prd_type, prd.prd_params, prd.prd_add_params, ( select ctn.ctn_number
            INTO prd_name, prd_type, prd_params, prd_add_params, ctn_number
            from dcl_catalog_number ctn where ctn.stf_id = stf_id and ctn.prd_id = prd.prd_id ) from dcl_produce prd where prd.prd_id = prd_id;

          manager_id := null;
          department := '';
          manager := '';
          FOR _rec IN select distinct usr_lng.usr_surname || ' ' || usr_lng.usr_name from dcl_lps_list_manager lmn, dcl_user_language usr_lng where lmn.lps_id = lps_id and usr_lng.usr_id = lmn.usr_id and usr_lng.lng_id = 1
          LOOP
            manager_local := _rec.usr_name;
            manager := manager || manager_local || ' ';
          END LOOP;

          FOR _rec IN select distinct dep.dep_name from dcl_lps_list_manager lmn, dcl_user usr, dcl_department dep where lmn.lps_id = lps_id and usr.usr_id = lmn.usr_id and dep.dep_id = usr.dep_id
          LOOP
            department_local := _rec.dep_name;
            department := department || department_local || ' ';
          END LOOP;

          lps_summ_out_nds := 0;
          IF ( spc_nds_rate is not null ) THEN
            lps_summ_out_nds := lps_summ_plus_nds / ( (cast (100 as DECIMAL(15,2))) + spc_nds_rate ) * (cast (100 as DECIMAL(15,2)));
          END IF;
          lps_summ_out_nds_eur := 0;
          SELECT crt_rate INTO eur_crt_rate FROM dcl_currency_rate_for_date(eur_cur_id, shp_date);
          IF ( eur_cur_id = cur_id ) THEN
            lps_summ_out_nds_eur := lps_summ_out_nds;
          ELSIF ( currency = 'BYN' ) THEN
            lps_summ_out_nds_eur := lps_summ_out_nds / eur_crt_rate;
          ELSE
            SELECT crt_rate INTO crt_rate FROM dcl_currency_rate_for_date(cur_id, shp_date);
            temporary_f := lps_summ_out_nds * crt_rate / eur_crt_rate;
            lps_summ_out_nds_eur := temporary_f;
          END IF;

          RETURN NEXT;
        END LOOP;
      END IF;
      if (
      ( p_not_include_zero is null and shp_summ_plus_nds = 0 ) or
      ( shp_summ_plus_nds != 0 and shp_prd_count = 0 )
      ) then
      lps_id := null;
      prd_id := null;
      prd_name := null;
      prd_type := null;
      prd_params := null;
      prd_add_params := null;
      ctn_number := null;
      stf_id := null;
      stf_name := null;
      lps_count := null;
      lps_summ_plus_nds := null;
      lps_summ_zak := null;
      lps_sum_transport := null;
      lps_custom := null;
      lps_summ_out_nds := null;
      lps_summ_out_nds_eur := null;
      manager_id := null;
      manager := null;
      department := null;

      RETURN NEXT;
      END IF;

    END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_shipping_report_user(date, date, integer, integer, integer, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shipping_report_user(p_date_begin date, p_date_end date, p_usr_id integer, p_dep_id integer, p_ctr_id integer, p_not_include_zero smallint, p_include_type smallint) RETURNS TABLE(shp_id integer, shp_number character varying, shp_date date, shp_contractor character varying, shp_prd_count integer, shp_summ_plus_nds numeric, shp_sum_nr numeric, con_number character varying, con_date date, spc_number character varying, spc_date date, spc_summ numeric, shp_closed smallint, currency character varying, prd_id integer, prd_name character varying, prd_type character varying, prd_params character varying, prd_add_params character varying, ctn_number character varying, stf_id integer, stf_name character varying, lps_id integer, lps_count numeric, lps_summ_plus_nds numeric, lps_summ_out_nds numeric, lps_summ_out_nds_eur numeric, lps_summ_zak numeric, manager_id integer, manager character varying, department character varying, lps_sum_transport numeric, lps_custom numeric, country character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  spc_id integer;
  spc_nds_rate decimal(15,2);
  need_suspend smallint;
  lmn_percent decimal(3,0);
  temporary_f float;
  shp_cut_id integer;
  eur_cur_id integer;
  eur_crt_rate decimal(15,2);
  cur_id integer;
  crt_rate decimal(15,2);
  _rec RECORD;
  _rec2 RECORD;
BEGIN
  SELECT cur_id
    INTO eur_cur_id
    from dcl_currency where cur_name = 'EUR';

  FOR _rec IN select shp.shp_id, shp.shp_number, shp.shp_date, shp.shp_summ_plus_nds - (select sum(lps.lps_summ_plus_nds) from dcl_shp_list_produce lps where lps.shp_id = shp.shp_id), ctr.ctr_name, ctr.cut_id, shp.spc_id from dcl_shipping shp, dcl_contractor ctr where shp_date >= p_date_begin and shp_date <= p_date_end and ( p_ctr_id is null or p_ctr_id = -1 or shp.ctr_id = p_ctr_id ) and ctr.ctr_id = shp.ctr_id and exists ( select shp_id from dcl_shp_usr_dep_v v where v.shp_id = shp.shp_id and ( p_usr_id is null or p_usr_id = -1 or v.usr_id = p_usr_id ) and ( p_dep_id is null or p_dep_id = -1 or v.dep_id = p_dep_id ) )
  LOOP
    shp_id := _rec.shp_id;
    shp_number := _rec.shp_number;
    shp_date := _rec.shp_date;
    shp_sum_nr := _rec.ctr_name;
    shp_contractor := _rec.cut_id;
    shp_cut_id := _rec.spc_id;
    spc_id := _rec.spc_id;
  shp_closed := null;
  SELECT shp_id
    INTO shp_closed
    from dcl_ctc_shp where shp_id = shp_id;

  country := null;
  SELECT cut_name
    INTO country
    from dcl_country where cut_id = shp_cut_id;

  need_suspend := null;
  if ( p_include_type = 1 or p_include_type = 2 ) THEN
  if ( (shp_closed is not null and p_include_type = 1) or (shp_closed is null and p_include_type = 2) ) THEN
  need_suspend := 1;
  END IF;
  ELSE
  need_suspend := 1;
  END IF;

  if ( need_suspend = 1 ) THEN
  con_number := null;
  con_date := null;
  spc_number := null;
  spc_date := null;
  spc_summ := null;
  spc_nds_rate := null;
  currency := null;

  SELECT con.con_number,
con.con_date,
cur.cur_id,
cur.cur_name,
spc.spc_number,
spc.spc_date,
spc.spc_summ,
spc.spc_nds_rate
    INTO con_number,
con_date,
cur_id,
currency,
spc_number,
spc_date,
spc_summ,
spc_nds_rate
    from   dcl_contract con,
dcl_con_list_spec spc,
dcl_currency cur
where  spc.spc_id = spc_id and
con.con_id = spc.con_id and
cur.cur_id = con.cur_id;

  SELECT count(lps.lps_id), sum(lps.lps_summ_plus_nds)
    INTO shp_prd_count, shp_summ_plus_nds
    from dcl_shp_list_produce lps where shp_id = shp_id;
  if ( p_not_include_zero is null or ( p_not_include_zero is not null and shp_prd_count != 0 and shp_summ_plus_nds != 0 ) ) THEN
  FOR _rec2 IN select lps.lps_id, lpc.prd_id, lpc.stf_id, ( select stf.stf_name from dcl_stuff_category stf where stf.stf_id = lpc.stf_id ), lps.lps_count, lps.lps_summ_plus_nds, lpc.lpc_cost_one * lps.lps_count, lpc.lpc_sum_transport / lpc.lpc_count * lps.lps_count, lpc.lpc_custom / lpc.lpc_count * lps.lps_count, lmn.usr_id, ( select usr_lng_shp.usr_surname || ' ' || usr_lng_shp.usr_name from dcl_user_language usr_lng_shp where usr_lng_shp.usr_id = lmn.usr_id and usr_lng_shp.lng_id = 1 ), lmn.lmn_percent from dcl_shp_list_produce lps, dcl_lps_list_manager lmn, dcl_prc_list_produce lpc where shp_id = shp_id and lpc.lpc_id = lps.lpc_id and lmn.lps_id = lps.lps_id and ( p_usr_id is null or p_usr_id = -1 or lmn.usr_id = p_usr_id ) and ( p_dep_id is null or p_dep_id = -1 or lmn.usr_id in ( select p_usr_id from dcl_user where p_dep_id = p_dep_id ) )
  LOOP
    lps_id := _rec2.lps_id;
    prd_id := _rec2.prd_id;
    stf_id := _rec2.stf_id;
    stf_name := _rec2.lps_count;
    lps_count := _rec2.lps_summ_plus_nds;
    lps_summ_plus_nds := _rec2.lps_count;
    lps_summ_zak := _rec2.lps_count;
    lps_sum_transport := _rec2.lps_count;
    lps_custom := _rec2.usr_id;
    manager_id := _rec2.lmn_percent;
    manager := _rec2.manager;
    lmn_percent := _rec2.lmn_percent;
  prd_name := null;
  prd_type := null;
  prd_params := null;
  prd_add_params := null;
  ctn_number := null;

  SELECT prd.prd_name,
prd.prd_type,
prd.prd_params,
prd.prd_add_params,
(
select ctn.ctn_number
from dcl_catalog_number ctn
where ctn.stf_id = stf_id and
ctn.prd_id = prd.prd_id
)
    INTO prd_name,
prd_type,
prd_params,
prd_add_params,
ctn_number
    from dcl_produce prd
where prd.prd_id = prd_id;

  department := null;
  SELECT dep.dep_name
    INTO department
    from dcl_user usr,
dcl_department dep
where usr.usr_id = manager_id and
dep.dep_id = usr.dep_id;

  if ( lmn_percent != 100 ) THEN
  lps_count := lps_count * lmn_percent / 100;
  lps_summ_plus_nds := lps_summ_plus_nds * lmn_percent / 100;
  lps_summ_zak := lps_summ_zak * lmn_percent / 100;
  lps_sum_transport := lps_sum_transport * lmn_percent / 100;
  lps_custom := lps_custom * lmn_percent / 100;
  END IF;
  lps_summ_out_nds := 0;
  if ( spc_nds_rate is not null ) THEN
  lps_summ_out_nds := lps_summ_plus_nds / ( (cast (100 as DECIMAL(15,2))) + spc_nds_rate ) * (cast (100 as DECIMAL(15,2)));
  END IF;
  lps_summ_out_nds_eur := 0;
  SELECT crt_rate
    INTO eur_crt_rate
    from dcl_currency_rate_for_date(eur_cur_id, shp_date);
  if ( eur_cur_id = cur_id ) THEN
  lps_summ_out_nds_eur := lps_summ_out_nds;
  ELSIF ( currency = 'BYR' ) THEN
  lps_summ_out_nds_eur := lps_summ_out_nds / eur_crt_rate;
  ELSIF ( currency = 'BYN' ) THEN
  lps_summ_out_nds_eur := lps_summ_out_nds / eur_crt_rate;
  ELSE
  SELECT crt_rate
    INTO crt_rate
    from dcl_currency_rate_for_date(cur_id, shp_date);
  temporary_f := lps_summ_out_nds * crt_rate / eur_crt_rate;
  lps_summ_out_nds_eur := temporary_f;
  END IF;

  RETURN NEXT;
  END LOOP;
  END IF;
  if ( p_not_include_zero is null and shp_prd_count = 0 and ( p_usr_id is null or p_usr_id = -1 ) and ( p_dep_id is null or p_dep_id = -1 ) ) THEN
  lps_id := null;
  prd_id := null;
  prd_name := null;
  prd_type := null;
  prd_params := null;
  prd_add_params := null;
  ctn_number := null;
  stf_id := null;
  stf_name := null;
  lps_count := null;
  manager_id := null;
  manager := null;
  department := null;

  RETURN NEXT;
  END IF;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_shp_doc_type_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_doc_type_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SDT_ID IS NULL) THEN
    NEW.SDT_ID = nextval('gen_dcl_shp_doc_type_id');
  ELSE
        ID = nextval('gen_dcl_shp_doc_type_id');
        IF ( ID < NEW.SDT_ID ) THEN
          ID = nextval('gen_dcl_shp_doc_type_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_shp_list_produce_ai0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_list_produce_ai0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  /* Trigger text */
  update dcl_prc_list_produce set stf_id = new.stf_id where lpc_id = new.lpc_id and ( stf_id != new.stf_id or stf_id is null ) and new.stf_id is not null;
  --update dcl_shp_list_produce set stf_id = new.stf_id where lpc_id = new.lpc_id and lps_id != new.lps_id and ( stf_id != new.stf_id or stf_id is null ) and new.stf_id is not null;
RETURN NEW;
END
$$;


--
-- Name: dcl_shp_list_produce_au0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_list_produce_au0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  /* Trigger text */
  update dcl_prc_list_produce set stf_id = new.stf_id where lpc_id = old.lpc_id and ( stf_id != new.stf_id or stf_id is null ) and new.stf_id is not null;
RETURN NEW;
END
$$;


--
-- Name: dcl_shp_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
  sh_date DATE;
BEGIN
  IF (NEW.LPS_ID IS NULL) THEN
    NEW.LPS_ID = nextval('gen_dcl_shp_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_shp_list_produce_id');
        IF ( ID < NEW.LPS_ID ) THEN
          ID = nextval('gen_dcl_shp_list_produce_id');
  END IF;
  END IF;

  select shp_date from dcl_shipping where shp_id = new.shp_id into sh_date;
  new.shp_date = sh_date;
RETURN NEW;
END
$$;


--
-- Name: dcl_shp_list_produce_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_list_produce_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  sh_date DATE;
BEGIN
  select shp_date from dcl_shipping where shp_id = new.shp_id into sh_date;
  new.shp_date = sh_date;
RETURN NEW;
END
$$;


--
-- Name: dcl_shp_list_produce_insert(integer, integer, integer, numeric, numeric, date, numeric, smallint, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_shp_list_produce_insert(p_shp_id integer, p_stf_id integer, p_lpc_id integer, p_lps_count numeric, p_lps_summ_plus_nds numeric, p_lps_enter_in_use_date date, p_lps_montage_time numeric, p_lps_montage_off smallint, p_lps_serial_num character varying, p_lps_year_out character varying, p_lpr_id integer) RETURNS TABLE(lps_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_shp_list_produce(
    p_shp_id,
    p_stf_id,
    p_lpc_id,
    p_lps_count,
    p_lps_summ_plus_nds,
    p_lps_enter_in_use_date,
    p_lps_montage_time,
    p_lps_montage_off,
    p_lps_serial_num,
    p_lps_year_out,
    p_lpr_id
  )
  values(
    p_shp_id,
    p_stf_id,
    p_lpc_id,
    p_lps_count,
    p_lps_summ_plus_nds,
    p_lps_enter_in_use_date,
    p_lps_montage_time,
    p_lps_montage_off,
    p_lps_serial_num,
    p_lps_year_out,
    p_lpr_id
  )
  returning lps_id into lps_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_sip_depended_lines(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_sip_depended_lines(p_opr_id integer, p_drp_id integer) RETURNS TABLE(id integer, prd_id integer, stf_id integer, stf_name character varying, prd_count numeric, ord_number character varying, ord_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  asm_id integer;
  apr_id integer;
  opr_id_local integer;
  _rec RECORD;
BEGIN
  id = null;
  prd_id = null;
  stf_id = null;
  stf_name = null;
  prd_count = null;
  ord_number = null;
  ord_date = null;

  asm_id = null;
  apr_id = null;
  opr_id_local = null;

  -- before selecting from assemple
  if ( p_drp_id is not null ) then
    select
      asm_id,
      apr_id,
      p_opr_id,
      ord_number,
      ord_date
    from dcl_dlr_list_produce_load(p_drp_id)
    into
      asm_id,
      apr_id,
      opr_id_local,
      ord_number,
      ord_date
    ;
  else
    opr_id_local = p_opr_id;
  END IF;

  if ( opr_id_local is not null ) then
  FOR _rec IN select prc.p_opr_id, prc.prd_id, prc.stf_id, stf.stf_name, prc.opr_count_executed from dcl_ord_list_prd_load_parent(opr_id_local) prc, dcl_stuff_category stf where stf.stf_id = prc.stf_id
  LOOP
    id := _rec.id;
    prd_id := _rec.prd_id;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    prd_count := _rec.prd_count;
      RETURN NEXT;
  END LOOP;
  END IF;

  if ( asm_id is not null ) then
  FOR _rec IN select -1, apr.prd_id, asm.stf_id, stf.stf_name, apr.apr_count from dcl_assemble asm, dcl_asm_list_produce apr, dcl_stuff_category stf where asm.asm_id = asm_id and apr.asm_id = asm.asm_id and stf.stf_id = asm.stf_id
  LOOP
    id := _rec.id;
    prd_id := _rec.prd_id;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    prd_count := _rec.prd_count;
      RETURN NEXT;
  END LOOP;
  END IF;

  if ( apr_id is not null ) then
  FOR _rec IN select -1, apr.prd_id, asm.stf_id, stf.stf_name, apr.apr_count from dcl_asm_list_produce apr, dcl_assemble asm, dcl_stuff_category stf where apr.apr_id = apr_id and asm.asm_id = apr.asm_id and stf.stf_id = asm.stf_id
  LOOP
    id := _rec.id;
    prd_id := _rec.prd_id;
    stf_id := _rec.stf_id;
    stf_name := _rec.stf_name;
    prd_count := _rec.prd_count;
      RETURN NEXT;
  END LOOP;
  END IF;
END
$$;


--
-- Name: dcl_spc_list_payment_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_spc_list_payment_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SPP_ID IS NULL) THEN
    NEW.SPP_ID = nextval('gen_dcl_spc_list_payment_id');
  ELSE
        ID = nextval('gen_dcl_spc_list_payment_id');
        IF ( ID < NEW.SPP_ID ) THEN
          ID = nextval('gen_dcl_spc_list_payment_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_specification_import_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_specification_import_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SPI_ID IS NULL) THEN
    NEW.SPI_ID = nextval('gen_dcl_specification_import_id');
  ELSE
        ID = nextval('gen_dcl_specification_import_id');
        IF ( ID < NEW.SPI_ID ) THEN
          ID = nextval('gen_dcl_specification_import_id');
  END IF;
  END IF;

  new.spi_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.spi_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_specification_import_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_specification_import_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.spi_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
RETURN NEW;
END
$$;


--
-- Name: dcl_specification_import_filter(character varying, date, date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_specification_import_filter(p_number character varying, p_date_begin date, p_date_end date, p_user character varying) RETURNS TABLE(spi_id integer, spi_number character varying, spi_date_formatted character varying, spi_cost numeric, spi_arrive smallint, spi_send_date_formatted character varying, spi_users character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT s.spi_id, s.spi_number,
           to_char(s.spi_date, 'DD.MM.YYYY')::VARCHAR AS spi_date_formatted,
           s.spi_cost,
           s.spi_arrive,
           COALESCE(to_char(s.spi_send_date, 'DD.MM.YYYY'), '')::VARCHAR AS spi_send_date_formatted,
           u.usr_name::VARCHAR AS spi_users
    FROM dcl_specification_import s
    LEFT JOIN dcl_user u ON u.usr_id = s.usr_id_create
    WHERE (p_number IS NULL OR p_number = '' OR upper(s.spi_number) LIKE '%' || upper(p_number) || '%')
      AND (p_date_begin IS NULL OR s.spi_date >= p_date_begin)
      AND (p_date_end IS NULL OR s.spi_date <= p_date_end)
      AND (p_user IS NULL OR p_user = '' OR upper(u.usr_name) LIKE '%' || upper(p_user) || '%')
    ORDER BY s.spi_date DESC, s.spi_id DESC;
END;
$$;


--
-- Name: dcl_specification_import_insert(date, character varying, character varying, numeric, numeric, smallint, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_specification_import_insert(p_spi_date date, p_spi_number character varying, p_spi_comment character varying, p_spi_course numeric, p_spi_koeff numeric, p_spi_arrive smallint, p_spi_cost numeric) RETURNS TABLE(spi_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_specification_import (
    p_spi_number,
    p_spi_date,
    p_spi_comment,
    p_spi_course,
    p_spi_koeff,
    p_spi_arrive,
    p_spi_cost
  )
  values (
    p_spi_number,
    p_spi_date,
    p_spi_comment,
    p_spi_course,
    p_spi_koeff,
    p_spi_arrive,
    p_spi_cost
  )
  returning spi_id into spi_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_spi_count_by_prd_id_spi_id(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_spi_count_by_prd_id_spi_id(p_prd_id integer, p_stf_id integer, p_ord_id integer, p_spi_id integer) RETURNS TABLE(trn_produce_count numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_opr_id INTEGER;
  v_apr_count DECIMAL(15,2);
  v_apr_id INTEGER;
  v_ord_id_local INTEGER;
  _rec RECORD;
BEGIN
  trn_produce_count := 0;
  FOR _rec IN SELECT sip.opr_id, sip.sip_count, sip.apr_id
    FROM dcl_specification_import spi, dcl_sip_list_produce sip
    WHERE spi.spi_id = p_spi_id AND spi.stf_id = p_stf_id
      AND sip.spi_id = spi.spi_id AND sip.prd_id = p_prd_id
  LOOP
    v_opr_id := _rec.opr_id;
    v_apr_count := _rec.sip_count;
    v_apr_id := _rec.apr_id;
    IF (p_ord_id IS NOT NULL AND v_opr_id IS NOT NULL) THEN
      SELECT opr.ord_id INTO v_ord_id_local FROM dcl_ord_list_produce opr WHERE opr.opr_id = v_opr_id;
      IF (p_ord_id = v_ord_id_local) THEN
        trn_produce_count := trn_produce_count + v_apr_count;
      END IF;
    ELSIF (p_ord_id IS NULL) THEN
      trn_produce_count := trn_produce_count + v_apr_count;
    END IF;
  END LOOP;
  RETURN NEXT;
END $$;


--
-- Name: dcl_spi_list_produce_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_spi_list_produce_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.SIP_ID IS NULL) THEN
    NEW.SIP_ID = nextval('gen_dcl_spi_list_produce_id');
  ELSE
        ID = nextval('gen_dcl_spi_list_produce_id');
        IF ( ID < NEW.SIP_ID ) THEN
          ID = nextval('gen_dcl_spi_list_produce_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_spi_list_produce_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_spi_list_produce_load(p_sip_id_in integer) RETURNS TABLE(sip_id integer, spi_id integer, drp_id integer, opr_id integer, prd_id integer, sip_price numeric, sip_count numeric, sip_weight numeric, sip_percent numeric, sip_cost numeric, prs_id integer, prs_name character varying, sip_occupied integer, drp_price numeric, stf_id integer, stf_name character varying, ctr_id integer, ctr_name character varying, ord_number character varying, ord_date date, dlr_ord_not_form smallint, count_day integer, have_depend smallint, ord_id integer, drp_max_extra smallint, spc_id integer, spc_number character varying, spc_date date, spc_delivery_date date, con_number character varying, con_date date, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ord_id_local integer;
  spi_date date;
BEGIN
  sip_id = null;
  spi_id = null;
  drp_id = null;
  opr_id = null;
  prd_id = null;
  sip_price = null;
  sip_count = null;
  sip_weight = null;
  sip_percent = null;
  sip_cost = null;
  prs_id = null;
  prs_name = null;
  sip_occupied = null;
  drp_price = null;
  stf_id = null;
  stf_name = null;
  ctr_id = null;
  ctr_name = null;
  ord_number = null;
  ord_date = null;
  ord_id = null;
  dlr_ord_not_form = null;
  count_day = null;
  have_depend = null;
  drp_max_extra = null;
  spc_id = null;
  spc_number = null;
  spc_date = null;
  spc_delivery_date = null;
  con_number = null;
  con_date = null;
  cur_name = null;

  select
      sip.sip_id, 
      sip.spi_id,
      sip.drp_id,
      sip.opr_id,
      sip.prd_id,
      sip.sip_price,
      sip.sip_count,
      sip.sip_weight,
      sip.sip_percent,
      sip.sip_cost,
      sip.prs_id,
      prs.prs_name,
      (select sip_id from DCL_OCCUPIED_SPI_PRODUCE_V where sip_id = sip.sip_id)
  from
      dcl_spi_list_produce sip,
      dcl_purpose prs
  where sip.sip_id = p_sip_id_in and
        prs.prs_id = sip.prs_id
  into
      sip_id, 
      spi_id,
      drp_id,
      opr_id,
      prd_id,
      sip_price,
      sip_count,
      sip_weight,
      sip_percent,
      sip_cost,
      prs_id,
      prs_name,
      sip_occupied
  ;

  if ( drp_id is not null ) then
    select
      drp_price,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      ord_id,
      ord_number,
      ord_date,
      dlr_ord_not_form,
      drp_have_depend,
      drp_max_extra,
      spc_id,
      opr_id
    from dcl_dlr_list_produce_load(drp_id)
    into
      drp_price,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      ord_id,
      ord_number,
      ord_date,
      dlr_ord_not_form,
      have_depend,
      drp_max_extra,
      spc_id,
      opr_id
    ;

    if ( spc_id is not null ) then
      select
        spc.spc_id,
        spc.spc_number,
        spc.spc_date,
        spc.spc_delivery_date,
        con.con_number,
        con.con_date,
        cur.cur_name
      from
        dcl_con_list_spec spc,
        dcl_contract con,
        dcl_currency cur
      where spc.spc_id = spc_id and
            con.con_id = spc.con_id and
            cur.cur_id = con.cur_id
      into
        spc_id, 
        spc_number,
        spc_date,
        spc_delivery_date,
        con_number,
        con_date,
        cur_name
      ;

      opr_id = null;
  END IF;
  END IF;

  if ( opr_id is not null ) then
    select
      ord_id, 
      drp_price,
      drp_max_extra,
      opr_have_depend
    from dcl_ord_list_produce_load(opr_id)
    into
      ord_id_local,
      drp_price,
      drp_max_extra,
      have_depend
    ;

    select
      ctr_id,
      ctr_name,
      spc_id,
      spc_number,
      spc_date,
      spc_delivery_date,
      con_number,
      con_date,
      cur_name
    from get_contractor_for_for_opr_id(opr_id)
    into
      ctr_id,
      ctr_name,
      spc_id,
      spc_number,
      spc_date,
      spc_delivery_date,
      con_number,
      con_date,
      cur_name
    ;

    select
      stf_id,
      (select stf_name from dcl_stuff_category where stf_id = ord.stf_id),
      ord_id, 
      ord_number,
      ord_date
    from dcl_order ord
    where ord_id = ord_id_local
    into
      stf_id,
      stf_name,
      ord_id,
      ord_number,
      ord_date
    ;
  END IF;

  if ( spc_delivery_date is not null ) then
    select spi_date from dcl_specification_import where spi_id = spi_id into spi_date;
    select count_day from dcl_get_count_day(spi_date, spc_delivery_date) into count_day;
  END IF;

  -- ???????????????????????? ???????????? ???? ???????????? ???? ????????????, ??.??. ?????????? ????????????????.
  select opr_id from dcl_spi_list_produce sip where sip.sip_id = p_sip_id_in into opr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_spi_list_produces_load(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_spi_list_produces_load(p_spi_id_in integer, p_usr_id integer) RETURNS TABLE(spi_id integer, sip_id integer, drp_id integer, opr_id integer, prd_id integer, sip_price numeric, sip_count numeric, sip_weight numeric, sip_percent numeric, sip_cost numeric, prs_id integer, prs_name character varying, sip_occupied integer, drp_price numeric, stf_id integer, stf_name character varying, ctr_id integer, ctr_name character varying, ord_number character varying, ord_date date, dlr_ord_not_form smallint, count_day integer, have_depend smallint, ord_id integer, drp_max_extra smallint, spc_number character varying, spc_date date, spc_delivery_date date, spc_add_pay_cond character varying, con_number character varying, con_date date, cur_name character varying, pay_persent numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
  dep_id integer;
  need_suspend smallint;
  doc_count integer;
  spc_id integer;
  spc_sum decimal(15,2);
  pay_sum decimal(15,2);
  _rec RECORD;
BEGIN
  spi_id := p_spi_id_in;

  FOR _rec IN select sip_id from dcl_spi_list_produce sip where sip.spi_id = p_spi_id_in order by sip_id
  LOOP
    sip_id := _rec.sip_id;
    select
      spi_id,
      drp_id,
      opr_id,
      prd_id,
      sip_price,
      sip_count,
      sip_weight,
      sip_percent,
      sip_cost,
      prs_id,
      prs_name,
      sip_occupied,
      drp_price,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      ord_id, 
      ord_number,
      ord_date,
      dlr_ord_not_form,
      count_day,
      spc_id, 
      spc_number,
      spc_date,
      spc_delivery_date,
      con_number,
      con_date,
      cur_name,
      have_depend,
      drp_max_extra
    from
      dcl_spi_list_produce_load(sip_id)
    into
      spi_id,
      drp_id,
      opr_id,
      prd_id,
      sip_price,
      sip_count,
      sip_weight,
      sip_percent,
      sip_cost,
      prs_id,
      prs_name,
      sip_occupied,
      drp_price,
      stf_id,
      stf_name,
      ctr_id,
      ctr_name,
      ord_id,
      ord_number,
      ord_date,
      dlr_ord_not_form,
      count_day,
      spc_id, 
      spc_number,
      spc_date,
      spc_delivery_date,
      con_number,
      con_date,
      cur_name,
      have_depend,
      drp_max_extra
    ;

    need_suspend := 1;
    if ( p_usr_id is not null ) then
      dep_id := null;
      select dep_id from dcl_user where p_usr_id = p_usr_id into dep_id;

      doc_count := 0;
      if ( opr_id is not null ) then
        SELECT count(ord.ord_id)
          INTO doc_count
          from dcl_order ord,
             dcl_ord_list_produce opr
        where opr.opr_id = opr_id and
              ord.ord_id = opr.ord_id and
              coalesce(dep_id, -1) = ( select dep_id from dcl_user where p_usr_id = ord.usr_id_create );
  END IF;

      if ( doc_count = 0 and drp_id is not null ) then
        SELECT count(dlr.dlr_id)
          INTO doc_count
          from dcl_delivery_request dlr,
             dcl_dlr_list_produce drp
        where drp.drp_id = drp_id and
              dlr.dlr_id = drp.dlr_id and
              (
                dlr.usr_id_create = coalesce(p_usr_id, -1) or
                coalesce(dep_id, -1) = ( select dep_id from dcl_user where p_usr_id = dlr.usr_id_create )
              );
  END IF;

      if ( doc_count = 0 ) then
        need_suspend := null;
  END IF;
  END IF;

    if ( need_suspend is not null ) then
      spc_add_pay_cond := null;
      spc_sum := null;

      select spc_add_pay_cond, spc_summ from dcl_con_list_spec where spc_id = spc_id into spc_add_pay_cond, spc_sum;
      pay_persent := 0;
      if (spc_sum != 0) then
        select sum(lps_summ) from dcl_pay_list_summ where spc_id = spc_id into pay_sum;

        pay_persent := pay_sum / spc_sum * 100;
  END IF;

      RETURN NEXT;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_stuff_category_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_stuff_category_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.STF_ID IS NULL) THEN
    NEW.STF_ID = nextval('gen_dcl_stuff_category_id');
  ELSE
        ID = nextval('gen_dcl_stuff_category_id');
        IF ( ID < NEW.STF_ID ) THEN
          ID = nextval('gen_dcl_stuff_category_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_stuff_category_filter(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_stuff_category_filter(p_stf_name_in character varying, p_montage character varying) RETURNS TABLE(stf_id integer, stf_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_stf_name_in VARCHAR(150);
  v_montage SMALLINT;
BEGIN
  v_stf_name_in := upper(p_stf_name_in);
  v_montage := CASE WHEN p_montage IS NOT NULL AND p_montage != '' THEN p_montage::SMALLINT ELSE 0 END;
  RETURN QUERY
    SELECT s.stf_id, s.stf_name
    FROM dcl_stuff_category s
    WHERE (v_stf_name_in IS NULL OR v_stf_name_in = '' OR upper(s.stf_name) LIKE '%' || v_stf_name_in || '%')
      AND (v_montage = 0 OR (v_montage = 1 AND s.stf_show_in_montage IS NOT NULL))
    ORDER BY upper(s.stf_name);
END;
$$;


--
-- Name: dcl_term_inco_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_term_inco_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.TRM_ID IS NULL) THEN
    NEW.TRM_ID = nextval('gen_dcl_term_inco_id');
  ELSE
        ID = nextval('gen_dcl_term_inco_id');
        IF ( ID < NEW.TRM_ID ) THEN
          ID = nextval('gen_dcl_term_inco_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_test_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_test_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.TST_ID IS NULL) THEN
    NEW.TST_ID = nextval('gen_dcl_test_id');
  ELSE
        ID = nextval('gen_dcl_test_id');
        IF ( ID < NEW.TST_ID ) THEN
          ID = nextval('gen_dcl_test_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_timeboard_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.TMB_ID IS NULL) THEN
    NEW.TMB_ID = nextval('gen_dcl_timeboard_id');
  ELSE
        ID = nextval('gen_dcl_timeboard_id');
        IF ( ID < NEW.TMB_ID ) THEN
          ID = nextval('gen_dcl_timeboard_id');
  END IF;
  END IF;

  new.tmb_create_date = CURRENT_TIMESTAMP;
  new.usr_id_create = get_context('usr_id');
  new.tmb_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
  if ( new.tmb_checked is not null ) then
    new.tmb_checked_date = CURRENT_TIMESTAMP;
    new.usr_id_checked = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_timeboard_bu0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_bu0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.tmb_edit_date = CURRENT_TIMESTAMP;
  new.usr_id_edit = get_context('usr_id');
  if ( new.tmb_checked is not null and old.tmb_checked is null ) then
    new.tmb_checked_date = CURRENT_TIMESTAMP;
    new.usr_id_checked = get_context('usr_id');
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_timeboard_filter(date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_filter(p_tmb_date_in date, p_tmb_user_in character varying) RETURNS TABLE(tmb_id integer, tmb_date date, tmb_user character varying, tmb_checked smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  _rec RECORD;
BEGIN
  p_tmb_user_in = upper(p_tmb_user_in);

  FOR _rec IN select tmb_id, tmb_date, (select usr_surname || ' ' || usr_name from dcl_user_language  where usr_id = tmb.usr_id and lng_id = 1), tmb_checked from dcl_timeboard tmb where ( p_tmb_date_in is null or tmb_date = p_tmb_date_in ) and  ( p_tmb_user_in is null or p_tmb_user_in like '' or (select upper(usr.usr_surname || ' ' || usr.usr_name) from dcl_user_language usr where usr_id = tmb.usr_id and lng_id = 1) like('%' || p_tmb_user_in || '%') ) order by tmb_date DESC
  LOOP
    tmb_id := _rec.tmb_id;
    tmb_date := _rec.tmb_date;
    tmb_user := _rec.tmb_user;
    tmb_checked := _rec.tmb_checked;
    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_timeboard_insert(integer, date, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_insert(p_usr_id integer, p_tmb_date date, p_tmb_checked smallint) RETURNS TABLE(tmb_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_timeboard (
     p_usr_id,
     p_tmb_date,
     p_tmb_checked
    )
    values (
     p_usr_id,
     p_tmb_date,
     p_tmb_checked
   )
   returning tmb_id into tmb_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_timeboard_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_load(p_tmb_id integer) RETURNS TABLE(usr_id integer, tmb_date date, tmb_checked smallint, usr_id_create integer, usr_id_edit integer, tmb_create_date timestamp without time zone, tmb_edit_date timestamp without time zone, tmb_checked_date timestamp without time zone, usr_id_checked integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  select tmb.usr_id_create,
         tmb.usr_id_edit,
         tmb.tmb_create_date,
         tmb.tmb_edit_date,
         tmb.usr_id,
         tmb.tmb_date,
         tmb.tmb_checked,
         tmb.tmb_checked_date,
         tmb.usr_id_checked
  from dcl_timeboard tmb
  where  tmb.p_tmb_id = p_tmb_id
  into   usr_id_create,
         usr_id_edit,
         tmb_create_date,
         tmb_edit_date,
         usr_id,
         tmb_date,
         tmb_checked,
         tmb_checked_date,
         usr_id_checked
  ;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_timeboard_load_check_idx(integer, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_timeboard_load_check_idx(p_usr_id integer, p_tmb_date date) RETURNS TABLE(tmb_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  select tmb.tmb_id
  from dcl_timeboard tmb
  where  tmb.p_usr_id = p_usr_id and
         tmb.p_tmb_date = p_tmb_date
  into   tmb_id
  ;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_tmb_list_work_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_tmb_list_work_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.TBW_ID IS NULL) THEN
    NEW.TBW_ID = nextval('gen_dcl_tmb_list_work_id');
  ELSE
        ID = nextval('gen_dcl_tmb_list_work_id');
        IF ( ID < NEW.TBW_ID ) THEN
          ID = nextval('gen_dcl_tmb_list_work_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_tmb_list_work_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_tmb_list_work_load(p_tbw_id_in integer) RETURNS TABLE(tbw_id integer, tmb_id integer, tbw_date date, tbw_from time without time zone, tbw_to time without time zone, tbw_hours_update numeric, crq_id integer, tbw_comment character varying, crq_number character varying, crq_request_type_id integer, ctr_id integer, ctr_name character varying, crq_equipment character varying, crq_deliver smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  tbw_id = null;
  tmb_id = null;
  tbw_date = null;
  tbw_from = null;
  tbw_to = null;
  tbw_hours_update = null;
  crq_id = null;
  tbw_comment = null;
  crq_number = null;
  crq_request_type_id = null;
  ctr_id = null;
  ctr_name = null;
  crq_equipment = null;
  crq_deliver = null;

  select
    tbw.tbw_id,
    tbw.tmb_id,
    tbw.tbw_date,
    tbw.tbw_from,
    tbw.tbw_to,
    tbw.tbw_hours_update,
    tbw.crq_id,
    tbw.tbw_comment
  from dcl_tmb_list_work tbw
  where tbw.tbw_id = p_tbw_id_in
  into
    tbw_id,
    tmb_id,
    tbw_date,
    tbw_from,
    tbw_to,
    tbw_hours_update,
    crq_id,
    tbw_comment
  ;

  select
    crq_number, 
    crq_request_type_id,
    ctr_id,
    crq_equipment,
    crq_deliver
  from dcl_contractor_request_load(crq_id)
  into
    crq_number,
    crq_request_type_id,
    ctr_id,
    crq_equipment,
    crq_deliver
  ;

  select ctr_name from dcl_contractor where ctr_id = ctr_id into ctr_name;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_tmb_list_works_load(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_tmb_list_works_load(p_tmb_id_in integer) RETURNS TABLE(tbw_id integer, tmb_id integer, tbw_date date, tbw_from time without time zone, tbw_to time without time zone, tbw_hours_update numeric, crq_id integer, tbw_comment character varying, crq_number character varying, crq_request_type_id integer, ctr_id integer, ctr_name character varying, crq_equipment character varying, crq_deliver smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  tmb_id = p_tmb_id_in;

  FOR tbw_id IN select tbw_id from dcl_tmb_list_work tbw where tbw.tmb_id = p_tmb_id_in order by tbw_date
  LOOP
    select
      tbw_id,
      tmb_id,
      tbw_date,
      tbw_from,
      tbw_to,
      tbw_hours_update,
      crq_id,
      tbw_comment,
      crq_number,
      crq_request_type_id,
      ctr_id,
      ctr_name,
      crq_equipment,
      crq_deliver
    from dcl_tmb_list_work_load(tbw_id)
    into
      tbw_id,
      tmb_id,
      tbw_date,
      tbw_from,
      tbw_to,
      tbw_hours_update,
      crq_id,
      tbw_comment,
      crq_number,
      crq_request_type_id,
      ctr_id,
      ctr_name,
      crq_equipment,
      crq_deliver
    ;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_unclosed_spec(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_unclosed_spec() RETURNS TABLE(ctr_id integer, ctr_name character varying, con_id integer, con_number character varying, con_date date, con_original smallint, spc_id integer, spc_number character varying, spc_date date, spc_summ numeric, spc_group_delivery smallint, spc_original smallint, pay_sum numeric, shp_sum numeric, have_unblocked_prc smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
  unblocked_prc_count integer;
  shp_id integer;
  get_spec smallint;
  _rec RECORD;
BEGIN
  FOR _rec IN select ctr.ctr_id, ctr.ctr_name, con.con_id, con.con_number, con.con_date, con.con_original, spc.spc_id, spc.spc_number, spc.spc_date, spc.spc_summ, spc.spc_group_delivery, spc.spc_original from dcl_contractor ctr, dcl_contract con, dcl_con_list_spec spc where ctr.ctr_id = con.ctr_id and con.con_id = spc.con_id order by spc_id
  LOOP
    ctr_id := _rec.ctr_id;
    ctr_name := _rec.ctr_name;
    con_id := _rec.con_id;
    con_number := _rec.con_number;
    con_date := _rec.con_date;
    con_original := _rec.con_original;
    spc_id := _rec.spc_id;
    spc_number := _rec.spc_number;
    spc_date := _rec.spc_date;
    spc_summ := _rec.spc_summ;
    spc_group_delivery := _rec.spc_group_delivery;
    spc_original := _rec.spc_original;
    have_unblocked_prc := null;

    if ( spc_group_delivery is not null ) then
      get_spec := null;
  FOR _rec IN select shp.shp_id from dcl_shipping shp where shp.spc_id = spc_id and not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id )
  LOOP
    shp_id := _rec.shp_id;
        get_spec := 1;

        SELECT coalesce(count(lps.lps_id), 0)
          INTO unblocked_prc_count
          from
          dcl_shipping shp,
          dcl_shp_list_produce lps,
          dcl_prc_list_produce lpc,
          dcl_produce_cost prc
        where
          shp.spc_id = spc_id and
          lps.shp_id = shp_id and
          lpc.lpc_id = lps.lpc_id and
          prc.prc_id = lpc.prc_id and
          prc.prc_block is null;

        if ( unblocked_prc_count != 0 ) then
          have_unblocked_prc := 1;
          EXIT;
  END IF;
  END LOOP;
  ELSE
      get_spec := 1;
  FOR _rec IN select shp.shp_id from dcl_shipping shp where shp.spc_id = spc_id and not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id )
  LOOP
    shp_id := _rec.shp_id;
        SELECT coalesce(count(lps.lps_id), 0)
          INTO unblocked_prc_count
          from
          dcl_shipping shp,
          dcl_shp_list_produce lps,
          dcl_prc_list_produce lpc,
          dcl_produce_cost prc
        where
          shp.spc_id = spc_id and
          lps.shp_id = shp_id and
          lpc.lpc_id = lps.lpc_id and
          prc.prc_id = lpc.prc_id and
          prc.prc_block is null;

        if ( unblocked_prc_count != 0 ) then
          have_unblocked_prc := 1;
          EXIT;
  END IF;
  END LOOP;
  END IF;

    if ( get_spec = 1 ) then
      SELECT dNVL(cast(sum(lps.lps_summ) as double precision), 0)
        INTO pay_sum
        from dcl_pay_list_summ lps,
           dcl_payment pay
      where lps.spc_id = spc_id and
            pay.pay_id = lps.pay_id and
            lps.lps_summ != 0 and
            pay.pay_block = 1 and
            not exists ( select distinct lps_id from dcl_ctc_pay where lps_id = lps.lps_id );

      SELECT dNVL(cast(sum(lps.lps_summ_plus_nds) as double precision), 0)
        INTO shp_sum
        from dcl_shp_list_produce lps,
           dcl_shipping shp
      where shp.spc_id = spc_id and
            lps.shp_id = shp.shp_id and
            lps.lps_summ_plus_nds != 0 and
            shp.shp_block = 1 and
            not exists ( select distinct shp_id from dcl_ctc_shp where shp_id = shp.shp_id );

      if ( spc_summ = pay_sum and spc_summ = shp_sum and spc_summ > 0 ) then
        RETURN NEXT;
  ELSE
        if ( spc_group_delivery is not null and ( spc_summ >= pay_sum or spc_summ >= shp_sum ) and pay_sum != 0 and shp_sum != 0 ) then
          RETURN NEXT;
  END IF;
  END IF;
  END IF;
  END LOOP;
END
$$;


--
-- Name: dcl_unit_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_unit_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.UNT_ID IS NULL) THEN
    NEW.UNT_ID = nextval('gen_dcl_unit_id');
  ELSE
        ID = nextval('gen_dcl_unit_id');
        IF ( ID < NEW.UNT_ID ) THEN
          ID = nextval('gen_dcl_unit_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_unit_insert(character); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_unit_insert(p_is_acceptable_for_cpr character) RETURNS TABLE(unt_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

  insert into dcl_unit (
    unt_id, p_is_acceptable_for_cpr
  )
  values (
    null, p_is_acceptable_for_cpr
  )
  returning unt_id into unt_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_unit_pack(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_unit_pack(p_unt_name_from character varying, p_unt_name_to character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  unt_id_from INTEGER;
  unt_id_to INTEGER;
BEGIN
  unt_id_from = null;
  select unt_id from dcl_unit_language unt where unt_name = p_unt_name_from and unt.lng_id = 1 into unt_id_from;
  unt_id_to = null;
  select unt_id from dcl_unit_language unt where unt_name = p_unt_name_to and unt.lng_id = 1 into unt_id_to;

  if ( unt_id_from is not null and unt_id_to is not null ) then
    update dcl_produce prd set prd.unt_id = unt_id_to where prd.unt_id = unt_id_from;
    delete from dcl_unit where unt_id = unt_id_from;
  END IF;
END
$$;


--
-- Name: dcl_update_delivery_date(integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_update_delivery_date(IN p_spc_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_spc_summ decimal(15,2);
  v_spc_percent_or_sum smallint;
  v_spc_delivery_percent decimal(15,2);
  v_spc_delivery_sum decimal(15,2);
  v_spc_delivery_date date;
  v_spc_additional_days_count integer;
  v_payed_date date;
BEGIN
  SELECT spc.spc_summ, spc.spc_percent_or_sum, spc.spc_delivery_percent,
         spc.spc_delivery_sum, spc.spc_delivery_date, spc.spc_additional_days_count
  INTO v_spc_summ, v_spc_percent_or_sum, v_spc_delivery_percent,
       v_spc_delivery_sum, v_spc_delivery_date, v_spc_additional_days_count
  FROM dcl_con_list_spec spc
  WHERE spc.spc_id = p_spc_id;

  IF (v_spc_additional_days_count IS NOT NULL) THEN
    SELECT d.payed_date INTO v_payed_date
    FROM dcl_get_payed_date(p_spc_id, v_spc_summ, v_spc_percent_or_sum, v_spc_delivery_percent, v_spc_delivery_sum) d;

    IF (v_payed_date IS NOT NULL AND v_spc_delivery_date IS NULL) THEN
      v_spc_delivery_date := v_payed_date + v_spc_additional_days_count;
      UPDATE dcl_con_list_spec SET spc_delivery_date = v_spc_delivery_date WHERE spc_id = p_spc_id;
    END IF;

    IF (v_payed_date IS NULL AND v_spc_delivery_date IS NOT NULL) THEN
      UPDATE dcl_con_list_spec SET spc_delivery_date = NULL WHERE spc_id = p_spc_id;
    END IF;
  END IF;
END
$$;


--
-- Name: dcl_update_dep_docs_for_ctr(integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_update_dep_docs_for_ctr(IN p_old_ctr_id integer, IN p_new_ctr_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_acc_index smallint;
  v_acc_id integer;
  v_usr_id integer;
  v_usr_count integer;
  _rec RECORD;
BEGIN
  SELECT COALESCE(MAX(acc_index), 0) INTO v_acc_index FROM dcl_account WHERE ctr_id = p_new_ctr_id;
  v_acc_index := v_acc_index + 1;
  FOR _rec IN SELECT acc_id FROM dcl_account WHERE ctr_id = p_old_ctr_id
  LOOP
    v_acc_id := _rec.acc_id;
    INSERT INTO dcl_account(ctr_id, acc_name, acc_account, cur_id, acc_index)
    SELECT p_new_ctr_id, '', acc_account, cur_id, v_acc_index
    FROM dcl_account WHERE acc_id = v_acc_id;
    v_acc_index := v_acc_index + 1;
  END LOOP;
  DELETE FROM dcl_account WHERE ctr_id = p_old_ctr_id;

  FOR _rec IN SELECT usr_id FROM dcl_contractor_user WHERE ctr_id = p_old_ctr_id
  LOOP
    v_usr_id := _rec.usr_id;
    SELECT COUNT(ctr_id) INTO v_usr_count FROM dcl_contractor_user WHERE ctr_id = p_new_ctr_id AND usr_id = v_usr_id;
    IF (v_usr_count = 0) THEN
      INSERT INTO dcl_contractor_user (ctr_id, usr_id) VALUES (p_new_ctr_id, v_usr_id);
    END IF;
  END LOOP;
  DELETE FROM dcl_contractor_user WHERE ctr_id = p_old_ctr_id;

  UPDATE dcl_contact_person SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_commercial_proposal SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_cond_for_contract SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_contract SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_contractor_request SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_contractor_request SET ctr_id_other = p_new_ctr_id WHERE ctr_id_other = p_old_ctr_id;
  UPDATE dcl_dlr_list_produce SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_order SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_order SET ctr_id_for = p_new_ctr_id WHERE ctr_id_for = p_old_ctr_id;
  UPDATE dcl_ord_list_produce SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_outgoing_letter SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_payment SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_prc_ctr_for_calcstate SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_shipping SET ctr_id = p_new_ctr_id WHERE ctr_id = p_old_ctr_id;
  UPDATE dcl_shipping SET ctr_id_where = p_new_ctr_id WHERE ctr_id_where = p_old_ctr_id;
  DELETE FROM dcl_contractor WHERE ctr_id = p_old_ctr_id;
END
$$;


--
-- Name: dcl_update_dep_docs_for_cut(integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_update_dep_docs_for_cut(IN p_old_cut_id integer, IN p_new_cut_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  update dcl_contractor set cut_id = p_new_cut_id where cut_id = p_old_cut_id;

  delete from dcl_country where cut_id = p_old_cut_id;
END
$$;


--
-- Name: dcl_update_dep_docs_for_prd(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_update_dep_docs_for_prd(p_old_prd_id integer, p_new_prd_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  ctn_id integer;
  stf_id integer;
  test_count integer;
  _rec RECORD;
BEGIN
  update dcl_asm_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_assemble set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_cfc_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_contractor_request set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_cpr_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_dlr_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_ord_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_prc_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  update dcl_spi_list_produce set prd_id = p_new_prd_id where prd_id = p_old_prd_id;
  FOR _rec IN select ctn_id, stf_id from dcl_catalog_number where prd_id = p_old_prd_id
  LOOP
    ctn_id := _rec.ctn_id;
    stf_id := _rec.stf_id;
    select count(ctn_id) from dcl_catalog_number where prd_id = p_new_prd_id and stf_id = stf_id into test_count;
    if ( test_count = 0 ) then
      update dcl_catalog_number set prd_id = p_new_prd_id where ctn_id = ctn_id;
  END IF;
  END LOOP;
  update dcl_attachment att set att.att_parent_id = p_new_prd_id where att.att_parent_id = p_old_prd_id and att.att_parent_table = 'DCL_PRODUCE';
  insert into DCL_CUS_CODE_HISTORY(cus_code, prd_id,date_created) select CUS_CODE, p_new_prd_id, date_created from DCL_CUS_CODE_HISTORY where prd_id=p_old_prd_id;
  delete from dcl_cus_code_history where prd_id = p_old_prd_id;
  delete from dcl_produce where prd_id = p_old_prd_id;
END
$$;


--
-- Name: dcl_update_dep_docs_for_stf(integer, integer); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_update_dep_docs_for_stf(IN p_old_stf_id integer, IN p_new_stf_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  update dcl_assemble set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_catalog_number set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_cfc_list_produce set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_contractor_request set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_cpr_list_produce set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_cpr_transport set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_dlr_list_produce set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_montage_adjustment set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_order set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_prc_list_produce set stf_id = p_new_stf_id where stf_id = p_old_stf_id;
  update dcl_shp_list_produce set stf_id = p_new_stf_id where stf_id = p_old_stf_id;

  delete from dcl_stuff_category where stf_id = p_old_stf_id;
END
$$;


--
-- Name: dcl_update_user_block(integer, smallint); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.dcl_update_user_block(IN p_usr_id integer, IN p_usr_block smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE dcl_user SET usr_block = p_usr_block WHERE usr_id = p_usr_id;
  IF (p_usr_block IS NOT NULL) THEN
    DELETE FROM dcl_user_role WHERE usr_id = p_usr_id;
  END IF;
END
$$;


--
-- Name: dcl_user_actions(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_actions(p_usr_id integer) RETURNS TABLE(act_id integer, act_system_name character varying)
    LANGUAGE sql
    AS $$
  SELECT DISTINCT act.act_id, act.act_system_name
  FROM dcl_user_role ur
  JOIN dcl_action_role ar ON ar.rol_id = ur.rol_id
  JOIN dcl_action act ON act.act_id = ar.act_id
  WHERE ur.usr_id = p_usr_id
    AND act.act_check_access IS NOT NULL;
$$;


--
-- Name: dcl_user_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.USR_ID IS NULL) THEN
    NEW.USR_ID = nextval('gen_dcl_user_id');
  ELSE
        ID = nextval('gen_dcl_user_id');
        IF ( ID < NEW.USR_ID ) THEN
          ID = nextval('gen_dcl_user_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_user_filter(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_filter(p_usr_name_in character varying, p_dep_id character varying, p_respons_person character varying) RETURNS TABLE(usr_id integer, usr_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_usr_name_in VARCHAR(50);
  v_dep_id INTEGER;
  v_respons_person SMALLINT;
BEGIN
  v_usr_name_in := upper(p_usr_name_in);
  v_dep_id := CASE WHEN p_dep_id IS NOT NULL AND p_dep_id != '' THEN p_dep_id::INTEGER ELSE NULL END;
  v_respons_person := CASE WHEN p_respons_person IS NOT NULL AND p_respons_person != '' THEN p_respons_person::SMALLINT ELSE NULL END;
  RETURN QUERY
    SELECT usr.usr_id,
           (usr_lng.usr_surname || ' ' || usr_lng.usr_name)::VARCHAR(50) AS usr_name
    FROM dcl_user_language usr_lng
    JOIN dcl_user usr ON usr.usr_id = usr_lng.usr_id
    WHERE usr_lng.lng_id = 1
      AND (v_dep_id IS NULL OR usr.dep_id = v_dep_id)
      AND (v_respons_person IS NULL OR v_respons_person = 0 OR usr.usr_respons_person = v_respons_person)
      AND (v_usr_name_in IS NULL OR v_usr_name_in = '' OR upper(usr_lng.usr_surname || ' ' || usr_lng.usr_name) LIKE '%' || v_usr_name_in || '%')
    ORDER BY upper(usr_lng.usr_surname || ' ' || usr_lng.usr_name);
END;
$$;


--
-- Name: dcl_user_filter_full(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_filter_full(p_dep_name_in character varying) RETURNS TABLE(usr_id integer, usr_name character varying, usr_surname character varying, usr_position character varying, usr_code character varying, usr_login character varying, usr_department character varying, usr_phone character varying, usr_block smallint, usr_respons_person smallint, usr_no_login smallint, usr_chief_dep smallint, usr_fax character varying, usr_email character varying, roles character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_usr_block_sort smallint;
  v_rol_name varchar(32);
  _rec RECORD;
  _rec2 RECORD;
  v_usr_id integer;
BEGIN
  p_dep_name_in = upper(p_dep_name_in);

  FOR _rec IN select coalesce(u.usr_block, CAST(0 AS smallint)) as sort_col, u.usr_id, 
    (select ul.usr_name from dcl_user_language ul where ul.usr_id = u.usr_id and ul.lng_id = 1) as usr_name_val, 
    (select ul.usr_surname from dcl_user_language ul where ul.usr_id = u.usr_id and ul.lng_id = 1) as usr_surname_val, 
    (select ul.usr_position from dcl_user_language ul where ul.usr_id = u.usr_id and ul.lng_id = 1) as usr_position_val, 
    u.usr_code, u.usr_login, 
    (select d.dep_name from dcl_department d where d.dep_id = u.dep_id) as usr_department_val, 
    u.usr_phone, u.usr_block, u.usr_respons_person, u.usr_no_login, u.usr_chief_dep, u.usr_fax, u.usr_email 
    from dcl_user u 
    where ( p_dep_name_in is null or p_dep_name_in like '' 
      or (select upper(dep.dep_name) from dcl_department dep where dep.dep_id = u.dep_id) like('%' || p_dep_name_in || '%') ) 
    order by 1, 4
  LOOP
    v_usr_block_sort := _rec.sort_col;
    v_usr_id := _rec.usr_id;
    usr_id := _rec.usr_id;
    usr_name := _rec.usr_name_val;
    usr_surname := _rec.usr_surname_val;
    usr_position := _rec.usr_position_val;
    usr_code := _rec.usr_code;
    usr_login := _rec.usr_login;
    usr_department := _rec.usr_department_val;
    usr_phone := _rec.usr_phone;
    usr_block := _rec.usr_block;
    usr_respons_person := _rec.usr_respons_person;
    usr_no_login := _rec.usr_no_login;
    usr_chief_dep := _rec.usr_chief_dep;
    usr_fax := _rec.usr_fax;
    usr_email := _rec.usr_email;
    roles := '';

    FOR _rec2 IN select rol.rol_name from dcl_role rol, dcl_user_role ur where ur.usr_id = v_usr_id and rol.rol_id = ur.rol_id
    LOOP
      v_rol_name := _rec2.rol_name;
      roles := roles || v_rol_name || '<br>';
    END LOOP;

    RETURN NEXT;
  END LOOP;
END
$$;


--
-- Name: dcl_user_insert(character varying, character varying, character varying, integer, character varying, smallint, smallint, smallint, smallint, character varying, character varying, smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_insert(p_usr_code character varying, p_usr_login character varying, p_usr_passwd character varying, p_dep_id integer, p_usr_phone character varying, p_usr_block smallint, p_usr_respons_person smallint, p_usr_no_login smallint, p_usr_chief_dep smallint, p_usr_fax character varying, p_usr_email character varying, p_usr_local_entry smallint, p_usr_internet_entry smallint) RETURNS TABLE(usr_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dcl_user (
    usr_code, usr_login, usr_passwd, usr_phone, dep_id,
    usr_block, usr_respons_person, usr_no_login, usr_chief_dep,
    usr_fax, usr_email, usr_local_entry, usr_internet_entry
  )
  values (
    p_usr_code, p_usr_login, p_usr_passwd, p_usr_phone, p_dep_id,
    p_usr_block, p_usr_respons_person, p_usr_no_login, p_usr_chief_dep,
    p_usr_fax, p_usr_email, p_usr_local_entry, p_usr_internet_entry
  )
  returning dcl_user.usr_id into usr_id;

  RETURN NEXT;
END
$$;


--
-- Name: dcl_user_link_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_link_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.ULN_ID IS NULL) THEN
    NEW.ULN_ID = nextval('gen_dcl_user_link_id');
  ELSE
        ID = nextval('gen_dcl_user_link_id');
        IF ( ID < NEW.ULN_ID ) THEN
          ID = nextval('gen_dcl_user_link_id');
  END IF;
  END IF;

  new.uln_create_date = CURRENT_TIMESTAMP;
RETURN NEW;
END
$$;


--
-- Name: dcl_user_setting_bi0_fn(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_user_setting_bi0_fn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  ID INTEGER;
BEGIN
  IF (NEW.UST_ID IS NULL) THEN
    NEW.UST_ID = nextval('gen_dcl_user_setting_id');
  ELSE
        ID = nextval('gen_dcl_user_setting_id');
        IF ( ID < NEW.UST_ID ) THEN
          ID = nextval('gen_dcl_user_setting_id');
  END IF;
  END IF;
RETURN NEW;
END
$$;


--
-- Name: dcl_yearweek(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dcl_yearweek(p_d date) RETURNS TABLE(week_no character varying, week_no_only integer, year_no_only integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  y INTEGER;
  w INTEGER;
  li_day_num INTEGER;
  li_day_of_week INTEGER;
  li_last_day_of_year INTEGER;
BEGIN
  y := EXTRACT(YEAR FROM p_d);
  li_day_num := EXTRACT(DOY FROM p_d);
  li_day_of_week := EXTRACT(DOW FROM p_d);
  IF (li_day_of_week = 0) THEN li_day_of_week := 7; END IF;
  w := (li_day_num + 6 + (7 - li_day_of_week)) / 7;

  li_last_day_of_year := EXTRACT(DOW FROM (DATE_TRUNC('year', p_d) + INTERVAL '1 year' - INTERVAL '1 day'));
  IF (w = 53 AND 4 > li_last_day_of_year) THEN
    y := y + 1;
    w := 1;
  END IF;

  IF (w < 10) THEN
    week_no := '0';
  ELSE
    week_no := '';
  END IF;
  week_no := y || '/' || week_no || w;
  week_no_only := w;
  year_no_only := y;
  RETURN NEXT;
END $$;


--
-- Name: dnvl(double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dnvl(a double precision, b double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN COALESCE(A, B);
END
$$;


--
-- Name: get_context(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_context() RETURNS TABLE(usr_id integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  select rdb$get_context('USER_SESSION', 'user_id')  into usr_id;
  RETURN NEXT;
END
$_$;


--
-- Name: get_contractor_for_for_apr_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_contractor_for_for_apr_id(p_apr_id integer) RETURNS TABLE(ctr_id integer, ctr_name character varying, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
BEGIN
  ctr_id := null;
  ctr_name := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  con_id := null;
  con_number := null;
  con_date := null;

  if ( p_apr_id is not null ) THEN
  SELECT asm.opr_id
    INTO opr_id
    from dcl_assemble asm,
dcl_asm_list_produce apr
where asm.asm_id = apr.asm_id and
apr.apr_id = p_apr_id;

  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_opr_id(opr_id);
  END IF;
  RETURN NEXT;
END
$$;


--
-- Name: get_contractor_for_for_drp_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_contractor_for_for_drp_id(p_drp_id integer) RETURNS TABLE(ctr_id integer, ctr_name character varying, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  apr_id integer;
BEGIN
  ctr_id := null;
  ctr_name := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  con_id := null;
  con_number := null;
  con_date := null;

  /*
  SELECT opr_id, apr_id
    INTO opr_id, apr_id
    from dcl_dlr_list_produce where p_drp_id = p_drp_id;

  if ( opr_id is not null ) THEN
  SELECT spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_opr_id(opr_id);
  END IF;
  if ( apr_id is not null ) THEN
  SELECT spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_apr_id(apr_id);
  END IF;
  */

  --last call take ctr_name field from dcl_dlr_list_produce table
  if ( p_drp_id is not null ) THEN
  SELECT ctr.ctr_id,
ctr.ctr_name,
drp.spc_id
    INTO ctr_id,
ctr_name,
spc_id
    from dcl_contractor ctr,
dcl_dlr_list_produce drp
where ctr.ctr_id = drp.ctr_id and
drp.drp_id = p_drp_id;

  if (spc_id is not null) THEN
  SELECT spc.spc_id,
spc.spc_number,
spc.spc_date,
con.con_id,
con.con_number,
con.con_date
    INTO spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from dcl_con_list_spec spc,
dcl_contract con
where spc.spc_id = spc_id and
con.con_id = spc.con_id;
  END IF;
  END IF;
  RETURN NEXT;
END
$$;


--
-- Name: get_contractor_for_for_lpc_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_contractor_for_for_lpc_id(p_lpc_id_in integer) RETURNS TABLE(lpc_id integer, ctr_id integer, ctr_name character varying, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  drp_id integer;
  sip_id integer;
  apr_id integer;
BEGIN
  ctr_id := null;
  ctr_name := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  con_id := null;
  con_number := null;
  con_date := null;
  lpc_id := p_lpc_id_in;

  SELECT opr_id, drp_id, sip_id, apr_id
    INTO opr_id, drp_id, sip_id, apr_id
    from dcl_prc_list_produce where lpc_id = p_lpc_id_in;

  if ( opr_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_opr_id(opr_id);
  END IF;
  if ( drp_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_drp_id(drp_id);
  END IF;
  if ( sip_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_sip_id(sip_id);
  END IF;
  if ( apr_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_apr_id(apr_id);
  END IF;
  RETURN NEXT;
END
$$;


--
-- Name: get_contractor_for_for_opr_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_contractor_for_for_opr_id(p_opr_id integer) RETURNS TABLE(ctr_id integer, ctr_name character varying, spc_id integer, spc_number character varying, spc_date date, spc_delivery_date date, con_id integer, con_number character varying, con_date date, cur_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  ord_id integer;
  ord_in_one_spec smallint;
BEGIN
  ctr_id := null;
  ctr_name := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  spc_delivery_date := null;
  con_id := null;
  con_number := null;
  con_date := null;
  cur_name := null;

  if ( p_opr_id is not null ) THEN
  SELECT ord.ord_id,
ord.ord_in_one_spec
    INTO ord_id,
ord_in_one_spec
    from dcl_order ord,
dcl_ord_list_produce opr
where opr.opr_id = p_opr_id and
ord.ord_id = opr.ord_id;

  if ( ord_in_one_spec is not null ) THEN
  SELECT ord.ctr_id_for,
ctr.ctr_name
    INTO ctr_id,
ctr_name
    from
dcl_contractor ctr,
dcl_order ord
where ctr.ctr_id = ord.ctr_id_for and
ord.ord_id = ord_id;

  SELECT spc.spc_id,
spc.spc_number,
spc.spc_date,
spc.spc_delivery_date,
con.con_id,
con.con_number,
con.con_date,
cur.cur_name
    INTO spc_id,
spc_number,
spc_date,
spc_delivery_date,
con_id,
con_number,
con_date,
cur_name

    from dcl_contract con,
dcl_con_list_spec spc,
dcl_order ord,
dcl_ord_list_produce opr,
dcl_currency cur
where con.con_id = spc.con_id and
spc.spc_id = ord.spc_id and
ord.ord_id = opr.ord_id and
opr.opr_id = p_opr_id and
cur.cur_id = con.cur_id;
  ELSE
  SELECT opr.ctr_id,
ctr.ctr_name
    INTO ctr_id,
ctr_name
    from
dcl_contractor ctr,
dcl_ord_list_produce opr
where ctr.ctr_id = opr.ctr_id and
opr.opr_id = p_opr_id;

  SELECT spc.spc_id,
spc.spc_number,
spc.spc_date,
spc.spc_delivery_date,
con.con_id,
con.con_number,
con.con_date,
cur.cur_name
    INTO spc_id,
spc_number,
spc_date,
spc_delivery_date,
con_id,
con_number,
con_date,
cur_name

    from dcl_contract con,
dcl_con_list_spec spc,
dcl_ord_list_produce opr,
dcl_currency cur
where con.con_id = spc.con_id and
spc.spc_id = opr.spc_id and
opr.opr_id = p_opr_id and
cur.cur_id = con.cur_id;
  END IF;
  END IF;
  RETURN NEXT;
END
$$;


--
-- Name: get_contractor_for_for_sip_id(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_contractor_for_for_sip_id(p_sip_id integer) RETURNS TABLE(ctr_id integer, ctr_name character varying, spc_id integer, spc_number character varying, spc_date date, con_id integer, con_number character varying, con_date date)
    LANGUAGE plpgsql
    AS $$
DECLARE
  opr_id integer;
  drp_id integer;
BEGIN
  ctr_id := null;
  ctr_name := null;
  spc_id := null;
  spc_number := null;
  spc_date := null;
  con_id := null;
  con_number := null;
  con_date := null;

  SELECT opr_id, drp_id
    INTO opr_id, drp_id
    from dcl_spi_list_produce where p_sip_id = p_sip_id;

  if ( opr_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_opr_id(opr_id);
  END IF;
  if ( drp_id is not null ) THEN
  SELECT ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    INTO ctr_id,
ctr_name,
spc_id,
spc_number,
spc_date,
con_id,
con_number,
con_date
    from get_contractor_for_for_drp_id(drp_id);
  END IF;
  RETURN NEXT;
END
$$;


--
-- Name: get_prc_dates_on_storage(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_prc_dates_on_storage(p_ctr_id integer, p_con_id integer, p_spc_id integer) RETURNS TABLE(dates_for_produce_on_storage character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  prc_date date;
  str_date varchar(20);
  _rec RECORD;
BEGIN
  dates_for_produce_on_storage := '';
  FOR _rec IN select distinct prc.prc_date from dcl_prc_list_produce lpc, dcl_prc_ctr_for_calcstate prc_ctr, dcl_produce_cost prc where prc_ctr.lpc_id = lpc.lpc_id and prc.prc_id = prc_ctr.prc_id and prc_ctr.ctr_id = p_ctr_id and ( prc_ctr.con_id = p_con_id or ( p_con_id is null and prc_ctr.con_id is null ) ) and ( prc_ctr.spc_id = p_spc_id or ( p_spc_id is null and prc_ctr.spc_id is null ) ) and lpc.lpc_count > ( select  coalesce (sum(lps.lps_count), 0) from dcl_shp_list_produce lps where lps.lpc_id = lpc.lpc_id ) order by prc.prc_date
  LOOP
    prc_date := _rec.prc_date;
  str_date := '';
  SELECT strdate
    INTO str_date
    from date2str(prc_date);
  dates_for_produce_on_storage := dates_for_produce_on_storage || str_date || '<br>';
  END LOOP;

  RETURN NEXT;
END
$$;


--
-- Name: maintenance_selectivity(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.maintenance_selectivity() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- No-op in PostgreSQL - statistics are maintained automatically via ANALYZE
  RETURN;
END $$;


--
-- Name: migrate_to_custom_code_history(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.migrate_to_custom_code_history() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_curr_date DATE;
  _rec RECORD;
BEGIN
  v_curr_date := CURRENT_DATE;
  FOR _rec IN SELECT cco_id, cco_custom_code, prd_id FROM dcl_custom_code
  LOOP
    INSERT INTO dcl_custom_code_history (cco_id, cch_custom_code, cch_date, prd_id)
      VALUES (_rec.cco_id, _rec.cco_custom_code, v_curr_date, _rec.prd_id);
  END LOOP;
END $$;


--
-- Name: set_context(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_context(p_user_id character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF p_user_id IS NOT NULL THEN
    PERFORM set_config('app.current_user_id', p_user_id, true);
  ELSE
    PERFORM set_config('app.current_user_id', '', true);
  END IF;
END;
$$;


--
-- Name: strlen(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.strlen(s text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN RETURN char_length(s); END;
$$;


--
-- Name: yearweek(date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.yearweek(p_d date) RETURNS TABLE(week_no character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  w integer;
BEGIN
  p_d = p_d - EXTRACT(WEEKDAY FROM p_d-1) + 3;  /* move to thursday */

  w := (EXTRACT(YEARDAY FROM p_d) - EXTRACT(WEEKDAY FROM p_d-1) + 7) / 7e0;
  week_no := W;

  RETURN NEXT;
END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dcl_1c_number_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_1c_number_history (
    id integer NOT NULL,
    prd_id integer NOT NULL,
    number_1c character varying(12) NOT NULL,
    date_created timestamp without time zone NOT NULL
);


--
-- Name: dcl_1c_number_history_generator; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dcl_1c_number_history_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dcl_account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_account (
    acc_id integer NOT NULL,
    ctr_id integer NOT NULL,
    acc_name character varying(100),
    acc_account character varying(35),
    cur_id integer,
    acc_index smallint
);


--
-- Name: dcl_action; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_action (
    act_id integer NOT NULL,
    act_name character varying(100),
    act_system_name character varying(100) NOT NULL,
    act_logging smallint,
    act_check_access smallint
);


--
-- Name: dcl_action_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_action_role (
    act_id integer NOT NULL,
    rol_id integer NOT NULL
);


--
-- Name: dcl_asm_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_asm_list_produce (
    apr_id integer NOT NULL,
    asm_id integer NOT NULL,
    prd_id integer NOT NULL,
    opr_id integer,
    apr_count numeric(15,2) NOT NULL
);


--
-- Name: dcl_assemble; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_assemble (
    asm_id integer NOT NULL,
    asm_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    asm_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    asm_number character varying(20) NOT NULL,
    asm_date date NOT NULL,
    asm_block smallint,
    asm_count integer,
    prd_id integer NOT NULL,
    opr_id integer,
    asm_type smallint NOT NULL,
    stf_id integer NOT NULL
);


--
-- Name: dcl_attachment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_attachment (
    att_id integer NOT NULL,
    att_parent_id integer NOT NULL,
    att_parent_table character varying(32) NOT NULL,
    att_name character varying(250),
    att_file_name character varying(250),
    att_link_id integer,
    usr_id integer NOT NULL,
    att_create_date timestamp without time zone NOT NULL
);


--
-- Name: dcl_blank; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_blank (
    bln_id integer NOT NULL,
    bln_type smallint NOT NULL,
    bln_name character varying(150) NOT NULL,
    lng_id integer NOT NULL,
    bln_charset character varying(20) NOT NULL,
    bln_preamble character varying(1000),
    bln_note character varying(1000),
    bln_usage character varying(1000)
);


--
-- Name: dcl_blank_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_blank_image (
    bim_id integer NOT NULL,
    bln_id integer NOT NULL,
    bim_name character varying(50) NOT NULL,
    bim_image character varying(32) NOT NULL
);


--
-- Name: dcl_catalog_number; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_catalog_number (
    ctn_id integer NOT NULL,
    stf_id integer NOT NULL,
    prd_id integer NOT NULL,
    ctn_number character varying(50) NOT NULL,
    mad_id integer
);


--
-- Name: dcl_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_category (
    cat_id integer NOT NULL,
    parent_id integer,
    cat_name character varying(100)
);


--
-- Name: dcl_cfc_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cfc_list_produce (
    ccp_id integer NOT NULL,
    cfc_id integer NOT NULL,
    stf_id integer NOT NULL,
    prd_id integer NOT NULL,
    ccp_price numeric(15,2),
    ccp_count numeric(15,2),
    ccp_nds_rate numeric(15,2),
    cpr_id integer
);


--
-- Name: dcl_cfc_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cfc_message (
    ccm_id integer NOT NULL,
    cfc_id integer,
    usr_id integer NOT NULL,
    ccm_create_date timestamp without time zone NOT NULL,
    ccm_message character varying(256),
    ctr_id integer
);


--
-- Name: dcl_commercial_proposal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_commercial_proposal (
    cpr_id integer NOT NULL,
    cpr_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    cpr_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    cpr_number character varying(20) NOT NULL,
    cpr_date date NOT NULL,
    ctr_id integer NOT NULL,
    cpr_concerning character varying(1000),
    cpr_preamble character varying(1000),
    cur_id integer NOT NULL,
    cpr_course numeric(18,8),
    cpr_nds numeric(15,2),
    trm_id_price_condition integer NOT NULL,
    cpr_country character varying(32),
    cpr_pay_condition character varying(1000),
    trm_id_delivery_condition integer NOT NULL,
    cpr_delivery_address character varying(256),
    cpr_sum_transport numeric(15,2),
    cpr_delivery_term character varying(2000),
    cpr_add_info character varying(3000),
    cpr_final_date date,
    usr_id integer,
    cpr_proposal_received_flag smallint DEFAULT 0 NOT NULL,
    cpr_date_accept date,
    cpr_block smallint,
    cpr_img_name character varying(20),
    cpr_summ numeric(15,2),
    cps_id integer,
    cpr_nds_by_string smallint,
    cpr_sum_assembling numeric(15,2),
    cpr_old_version smallint,
    cpr_check_price smallint,
    cpr_check_price_date timestamp without time zone,
    usr_id_check_price integer,
    cur_id_table integer NOT NULL,
    cpr_assemble_minsk_store smallint,
    bln_id integer NOT NULL,
    cpr_all_transport smallint,
    cpr_concerning_invoice character varying(1000),
    cpr_can_edit_invoice smallint,
    cpr_pay_condition_invoice character varying(1000),
    cpr_delivery_term_invoice character varying(2000),
    cpr_final_date_invoice character varying(30),
    cpr_comment character varying(3000),
    executor_id integer,
    cpr_executor_flag smallint,
    pps_id integer,
    cpr_reverse_calc smallint,
    cps_id_seller integer,
    cps_id_customer integer,
    cpr_prepay_percent numeric(15,2),
    cpr_prepay_sum numeric(15,2),
    cpr_delay_days integer,
    cpr_no_reservation smallint,
    cpr_provider_delivery smallint,
    cpr_provider_delivery_address character varying(500),
    cpr_delivery_count_day integer,
    cpr_free_prices smallint,
    cpr_donot_calculate_netto smallint,
    cpr_print_scale integer,
    cpr_contract_scale integer,
    cpr_invoice_scale integer,
    cpr_guaranty_in_month integer,
    ctr_id_consignee integer,
    cpr_final_date_above smallint,
    cpr_tender_number character varying(100),
    cpr_tender_number_editable character(1) DEFAULT '0'::bpchar NOT NULL,
    cpr_proposal_declined character(1) DEFAULT '0'::bpchar NOT NULL
);


--
-- Name: dcl_con_list_spec; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_con_list_spec (
    spc_id integer NOT NULL,
    con_id integer NOT NULL,
    spc_number character varying(50),
    spc_date date,
    spc_summ numeric(15,2),
    spc_summ_nds numeric(15,2),
    spc_executed smallint,
    spc_nds_rate numeric(15,2),
    spc_delivery_date date,
    spc_add_pay_cond character varying(5000),
    spc_original smallint,
    spc_montage smallint,
    spc_group_delivery smallint,
    spc_delivery_cond character varying(5000),
    spc_delivery_term_type smallint,
    spc_percent_or_sum smallint,
    spc_delivery_percent numeric(15,2),
    spc_delivery_sum numeric(15,2),
    spc_pay_after_montage smallint,
    spc_annul smallint,
    spc_annul_date date,
    spc_comment character varying(5000),
    usr_id integer,
    spc_letter1_date date,
    spc_letter2_date date,
    spc_letter3_date date,
    spc_complaint_in_court_date date,
    spc_additional_days_count integer
);


--
-- Name: dcl_con_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_con_message (
    cms_id integer NOT NULL,
    con_id integer,
    spc_id integer,
    usr_id integer NOT NULL,
    cms_create_date timestamp without time zone NOT NULL,
    cms_message character varying(256),
    ctr_id integer
);


--
-- Name: dcl_cond_for_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cond_for_contract (
    cfc_id integer NOT NULL,
    cfc_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    cfc_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    cfc_place smallint,
    cfc_place_date timestamp without time zone,
    usr_id_place integer,
    cfc_execute smallint,
    cfc_execute_date timestamp without time zone,
    usr_id_execute integer,
    ctr_id integer NOT NULL,
    cfc_doc_type smallint NOT NULL,
    cfc_con_number_txt character varying(200),
    cfc_con_date date,
    cur_id integer,
    con_id integer,
    cfc_spc_number_txt character varying(200),
    cfc_spc_date date,
    cfc_pay_cond character varying(2500),
    cfc_delivery_cond character varying(2500),
    cfc_guarantee_cond character varying(2500),
    cfc_montage_cond character varying(2500),
    cfc_date_con_to date,
    cfc_count_delivery character varying(1000),
    cps_id_sign integer,
    cps_id integer,
    cfc_delivery_count smallint,
    cfc_custom_point character varying(500),
    pps_id integer,
    cfc_comment character varying(1000),
    cfc_need_invoice smallint,
    cfc_check_price smallint,
    cfc_check_price_date timestamp without time zone,
    usr_id_check_price integer,
    sln_id integer,
    cfc_annul smallint,
    cfc_annul_date date,
    usr_id_edit_annul integer,
    cfc_edit_annul_date timestamp without time zone
);


--
-- Name: dcl_contact_person; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contact_person (
    cps_id integer NOT NULL,
    ctr_id integer NOT NULL,
    cps_name character varying(200) NOT NULL,
    cps_phone character varying(150),
    cps_fax character varying(150),
    cps_block smallint,
    cps_position character varying(150),
    cps_on_reason character varying(150),
    cps_email character varying(50),
    cps_mob_phone character varying(150),
    cps_contract_comment character varying(300),
    cps_fire smallint
);


--
-- Name: dcl_contact_person_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contact_person_user (
    cps_id integer NOT NULL,
    usr_id integer NOT NULL
);


--
-- Name: dcl_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contract (
    con_id integer NOT NULL,
    con_create_date timestamp without time zone,
    usr_id_create integer,
    con_edit_date timestamp without time zone,
    usr_id_edit integer,
    con_number character varying(50) NOT NULL,
    con_date date NOT NULL,
    ctr_id integer,
    cur_id integer,
    con_executed smallint,
    con_summ numeric(15,2),
    con_original smallint,
    con_annul smallint,
    con_annul_date date,
    con_comment character varying(5000),
    sln_id integer,
    con_reusable smallint,
    con_final_date date
);


--
-- Name: dcl_contract_closed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contract_closed (
    ctc_id integer NOT NULL,
    ctc_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    ctc_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    ctc_number integer NOT NULL,
    ctc_date date NOT NULL,
    ctc_block smallint
);


--
-- Name: dcl_contractor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contractor (
    ctr_id integer NOT NULL,
    ctr_name character varying(200) NOT NULL,
    ctr_email character varying(40),
    ctr_bank_props character varying(800),
    ctr_unp character varying(15),
    ctr_full_name character varying(300),
    ctr_block smallint,
    ctr_create_date timestamp without time zone,
    usr_id_create integer,
    ctr_edit_date timestamp without time zone,
    usr_id_edit integer,
    rpt_id integer NOT NULL,
    ctr_okpo character varying(15),
    ctr_phone character varying(100),
    ctr_fax character varying(100),
    ctr_double_account smallint,
    cut_id integer NOT NULL,
    ctr_index character varying(20),
    ctr_region character varying(50),
    ctr_place character varying(50),
    ctr_street character varying(50),
    ctr_building character varying(10),
    ctr_add_info character varying(1000),
    ctr_comment character varying(5000)
);


--
-- Name: dcl_contractor_request; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contractor_request (
    crq_id integer NOT NULL,
    crq_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    crq_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    crq_receive_date date NOT NULL,
    ctr_id integer NOT NULL,
    cps_id integer,
    crq_request_type_id integer NOT NULL,
    con_id integer,
    lps_id integer,
    prd_id integer,
    crq_number character varying(15) NOT NULL,
    crq_deliver smallint,
    usr_id_manager integer,
    usr_id_chief integer,
    usr_id_specialist integer,
    crq_city character varying(50),
    ctr_id_other integer,
    crq_no_contract smallint,
    stf_id integer,
    crq_serial_num character varying(100),
    crq_year_out character varying(100),
    crq_enter_in_use_date date,
    crq_annul smallint,
    crq_ticket_number character varying(30),
    sln_id integer,
    crq_comment character varying(2000),
    crq_operating_time numeric(8,2),
    con_id_for_work integer
);


--
-- Name: dcl_contractor_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_contractor_user (
    ctr_id integer NOT NULL,
    usr_id integer NOT NULL
);


--
-- Name: dcl_country; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_country (
    cut_id integer NOT NULL,
    cut_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    cut_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    cut_name character varying(50) NOT NULL
);


--
-- Name: dcl_cpr_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cpr_list_produce (
    lpr_id integer NOT NULL,
    cpr_id integer NOT NULL,
    lpr_produce_name character varying(1000),
    lpr_price_netto numeric(15,2),
    lpr_count numeric(15,2),
    cus_id integer,
    lpr_coeficient numeric(18,8),
    lpr_catalog_num character varying(50),
    stf_id integer,
    prd_id integer,
    lpr_comment character varying(5000),
    lpc_id integer,
    lpr_sale_price numeric(15,2),
    lpr_sale_cost_parking_trans numeric(15,2),
    lpr_price_brutto numeric(15,2),
    lpr_discount numeric(15,2)
);


--
-- Name: dcl_cpr_transport; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cpr_transport (
    trn_id integer NOT NULL,
    cpr_id integer NOT NULL,
    stf_id integer,
    trn_sum numeric(15,2) NOT NULL
);


--
-- Name: dcl_crq_ord_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_crq_ord_link (
    crq_id integer NOT NULL,
    ord_id integer NOT NULL
);


--
-- Name: dcl_crq_print; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_crq_print (
    crp_id integer NOT NULL,
    crq_id integer NOT NULL,
    crp_reclamation_date date,
    crp_lintera_request_date date,
    crp_no_defect_act smallint,
    crp_lintera_agreement_date date,
    crp_deliver smallint,
    crp_no_reclamation_act smallint
);


--
-- Name: dcl_crq_stage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_crq_stage (
    crs_id integer NOT NULL,
    crq_id integer NOT NULL,
    crs_name character varying(500) NOT NULL,
    crs_comment character varying(2000),
    crs_print smallint
);


--
-- Name: dcl_ctc_list; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ctc_list (
    lcc_id integer NOT NULL,
    ctc_id integer NOT NULL,
    spc_id integer NOT NULL,
    lcc_charges numeric(15,2) NOT NULL,
    lcc_montage numeric(15,2) NOT NULL,
    lcc_transport numeric(15,2) NOT NULL,
    lcc_update_sum numeric(15,2) NOT NULL
);


--
-- Name: dcl_ctc_pay; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ctc_pay (
    lcc_id integer NOT NULL,
    lps_id integer NOT NULL
);


--
-- Name: dcl_ctc_shp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ctc_shp (
    lcc_id integer NOT NULL,
    shp_id integer NOT NULL
);


--
-- Name: dcl_currency; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_currency (
    cur_id integer NOT NULL,
    cur_name character varying(10) NOT NULL,
    cur_no_round smallint,
    cur_sort_order smallint
);


--
-- Name: dcl_currency_rate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_currency_rate (
    crt_id integer NOT NULL,
    cur_id integer NOT NULL,
    crt_date date NOT NULL,
    crt_rate numeric(15,6) NOT NULL
);


--
-- Name: dcl_cus_code_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_cus_code_history (
    id integer NOT NULL,
    prd_id integer NOT NULL,
    cus_code character varying(10) NOT NULL,
    date_created timestamp without time zone NOT NULL
);


--
-- Name: dcl_cus_code_history_generator; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dcl_cus_code_history_generator
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dcl_custom_code; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_custom_code (
    cus_id integer NOT NULL,
    cus_code character varying(10) NOT NULL,
    cus_description character varying(500),
    cus_percent numeric(15,2) NOT NULL,
    cus_instant timestamp without time zone NOT NULL,
    cus_create_date timestamp without time zone,
    cus_id_create integer,
    cus_edit_date timestamp without time zone,
    cus_id_edit integer,
    usr_create_date timestamp without time zone,
    usr_id_create integer,
    usr_edit_date timestamp without time zone,
    usr_id_edit integer,
    cus_law_240_flag smallint,
    cus_block smallint
);


--
-- Name: dcl_custom_code_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_custom_code_v AS
 SELECT cus_code,
    max(cus_instant) AS cus_instant
   FROM public.dcl_custom_code
  WHERE (cus_instant < public.addday(CURRENT_DATE, 1))
  GROUP BY cus_code;


--
-- Name: dcl_delivery_request; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_delivery_request (
    dlr_id integer NOT NULL,
    dlr_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    dlr_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    dlr_place_date timestamp without time zone,
    usr_id_place integer,
    dlr_number character varying(20) NOT NULL,
    dlr_date date NOT NULL,
    dlr_fair_trade smallint,
    dlr_wherefrom character varying(100),
    dlr_comment character varying(5000),
    dlr_place_request smallint,
    dlr_include_in_spec smallint,
    dlr_annul smallint,
    dlr_need_deliver smallint,
    dlr_ord_not_form smallint,
    dlr_executed smallint,
    dlr_guarantee_repair smallint,
    dlr_minsk smallint
);


--
-- Name: dcl_department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_department (
    dep_id integer NOT NULL,
    dep_name character varying(100) NOT NULL
);


--
-- Name: dcl_dlr_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_dlr_list_produce (
    drp_id integer NOT NULL,
    dlr_id integer NOT NULL,
    prd_id integer NOT NULL,
    opr_id integer,
    drp_price numeric(15,2) NOT NULL,
    drp_count numeric(15,2) NOT NULL,
    stf_id integer NOT NULL,
    ctr_id integer,
    prs_id integer,
    drp_purpose character varying(500),
    sip_id integer,
    receive_manager_id integer,
    receive_date date,
    apr_id integer,
    asm_id integer,
    drp_max_extra smallint,
    spc_id integer
);


--
-- Name: dcl_field_comment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_field_comment (
    fcm_id integer NOT NULL,
    fcm_key character varying(124) NOT NULL,
    fcm_value character varying(4000)
);


--
-- Name: dcl_files_path; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_files_path (
    flp_id integer NOT NULL,
    flp_table_name character varying(32) NOT NULL,
    flp_path character varying(1024) NOT NULL,
    flp_description character varying(200)
);


--
-- Name: dcl_inf_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_inf_message (
    inm_id integer NOT NULL,
    usr_id integer NOT NULL,
    inm_create_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    inm_message character varying(5000)
);


--
-- Name: dcl_instruction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_instruction (
    ins_id integer NOT NULL,
    ins_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    ins_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    ist_id integer NOT NULL,
    ins_number character varying(100),
    ins_date_sign date NOT NULL,
    ins_date_from date NOT NULL,
    ins_date_to date,
    ins_concerning character varying(5000)
);


--
-- Name: dcl_instruction_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_instruction_type (
    ist_id integer NOT NULL,
    ist_name character varying(200) NOT NULL
);


--
-- Name: dcl_language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_language (
    lng_id integer NOT NULL,
    lng_name character varying(32) NOT NULL,
    lng_letter_id character varying(2) NOT NULL
);


--
-- Name: dcl_lnt_account; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_lnt_account AS
 SELECT acc_id,
    ctr_id,
    acc_name,
    acc_account,
    cur_id,
    acc_index
   FROM public.dcl_account;


--
-- Name: dcl_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_produce (
    prd_id integer NOT NULL,
    cat_id integer NOT NULL,
    prd_name character varying(1000),
    prd_type character varying(200),
    prd_params character varying(200),
    prd_add_params character varying(200),
    unt_id integer,
    cus_code character varying(10),
    prd_block smallint,
    prd_create_date timestamp without time zone,
    usr_id_create integer,
    prd_edit_date timestamp without time zone,
    usr_id_edit integer,
    prd_block_date timestamp without time zone,
    usr_id_block integer,
    prd_material character varying(5000),
    prd_purpose character varying(5000),
    prd_specification character varying(5000),
    prd_principle character varying(5000),
    prd_not_check_double smallint
);


--
-- Name: dcl_lnt_produce; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_lnt_produce AS
 SELECT prd_id,
    prd_name,
    prd_type,
    prd_params,
    prd_add_params
   FROM public.dcl_produce;


--
-- Name: dcl_shp_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_shp_list_produce (
    lps_id integer NOT NULL,
    shp_id integer NOT NULL,
    lpc_id integer NOT NULL,
    stf_id integer NOT NULL,
    lps_count numeric(15,2),
    lps_summ_plus_nds numeric(15,2),
    lps_enter_in_use_date date,
    lps_montage_time numeric(15,1),
    lps_montage_off smallint,
    shp_date date NOT NULL,
    lps_serial_num character varying(100),
    lps_year_out character varying(30),
    lpr_id integer
);


--
-- Name: dcl_lnt_service; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_lnt_service AS
 SELECT lps_id,
    lps_serial_num
   FROM public.dcl_shp_list_produce;


--
-- Name: dcl_lnt_service_contract; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_lnt_service_contract AS
 SELECT con_id,
    con_number,
    con_date,
    con_final_date,
    ctr_id,
    con_original
   FROM public.dcl_contract;


--
-- Name: dcl_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_log (
    log_id integer NOT NULL,
    act_id integer NOT NULL,
    usr_id integer NOT NULL,
    log_time timestamp without time zone NOT NULL,
    log_ip character varying(20) NOT NULL
);


--
-- Name: dcl_lps_list_manager; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_lps_list_manager (
    lmn_id integer NOT NULL,
    lps_id integer NOT NULL,
    usr_id integer NOT NULL,
    lmn_percent numeric(3,0) NOT NULL
);


--
-- Name: dcl_montage_adjustment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_montage_adjustment (
    mad_id integer NOT NULL,
    stf_id integer NOT NULL,
    mad_machine_type character varying(1000) NOT NULL,
    mad_complexity character varying(10) NOT NULL,
    mad_annul smallint
);


--
-- Name: dcl_montage_adjustment_h; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_montage_adjustment_h (
    madh_id integer NOT NULL,
    mad_id integer NOT NULL,
    mad_date_from date NOT NULL,
    mad_mech_work_tariff numeric(15,1) NOT NULL,
    mad_mech_work_rule_montage numeric(15,1) NOT NULL,
    mad_mech_work_rule_adjustment numeric(15,1) NOT NULL,
    mad_mech_road_tariff numeric(15,1) NOT NULL,
    mad_mech_road_rule numeric(15,1) NOT NULL,
    mad_el_work_tariff numeric(15,1) NOT NULL,
    mad_el_work_rule_montage numeric(15,1) NOT NULL,
    mad_el_work_rule_adjustment numeric(15,1) NOT NULL,
    mad_el_road_tariff numeric(15,1) NOT NULL,
    mad_el_road_rule numeric(15,1) NOT NULL,
    mad_mech_total numeric(15,1) NOT NULL,
    mad_el_total numeric(15,1) NOT NULL
);


--
-- Name: dcl_prc_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_prc_list_produce (
    lpc_id integer NOT NULL,
    prc_id integer NOT NULL,
    lpc_produce_name character varying(1000),
    stf_id integer NOT NULL,
    usr_id integer,
    lpc_count numeric(15,2),
    lpc_cost_one numeric(15,2),
    lpc_weight numeric(15,3),
    lpc_summ numeric(15,2),
    lpc_sum_transport numeric(15,2),
    lpc_custom numeric(15,2),
    prs_id integer NOT NULL,
    prd_id integer NOT NULL,
    lpc_cost_one_ltl numeric(15,2),
    opr_id integer,
    drp_id integer,
    sip_id integer,
    lpc_1c_number character varying(12),
    lpc_percent character varying(12),
    apr_id integer,
    asm_id integer,
    lpc_comment character varying(1000),
    dep_id integer,
    lpc_cost_one_by numeric(15,2) NOT NULL,
    lpc_price_list_by numeric(15,2)
);


--
-- Name: dcl_occupied_apr_produce_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_apr_produce_v AS
 SELECT DISTINCT apr_id
   FROM public.dcl_asm_list_produce apr
  WHERE ((apr_id IN ( SELECT DISTINCT drp.apr_id
           FROM public.dcl_dlr_list_produce drp,
            public.dcl_delivery_request dlr
          WHERE ((drp.apr_id = apr.apr_id) AND (dlr.dlr_id = drp.dlr_id) AND (dlr.dlr_annul IS NULL)))) OR (apr_id IN ( SELECT DISTINCT dcl_prc_list_produce.apr_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.apr_id = apr.apr_id))));


--
-- Name: dcl_occupied_asm_produce_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_asm_produce_v AS
 SELECT DISTINCT asm_id
   FROM public.dcl_assemble asm
  WHERE ((asm_id IN ( SELECT DISTINCT drp.asm_id
           FROM public.dcl_dlr_list_produce drp,
            public.dcl_delivery_request dlr
          WHERE ((drp.asm_id = asm.asm_id) AND (dlr.dlr_id = drp.dlr_id) AND (dlr.dlr_annul IS NULL)))) OR (asm_id IN ( SELECT DISTINCT dcl_prc_list_produce.asm_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.asm_id = asm.asm_id))));


--
-- Name: dcl_ord_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ord_list_produce (
    opr_id integer NOT NULL,
    ord_id integer NOT NULL,
    opr_produce_name character varying(1000),
    opr_catalog_num character varying(50),
    opr_count numeric(15,2),
    opr_price_brutto numeric(15,2),
    opr_discount numeric(15,2),
    opr_price_netto numeric(15,2),
    opr_summ numeric(15,2),
    opr_use_prev_number character(1),
    prd_id integer NOT NULL,
    opr_comment character varying(5000),
    drp_price numeric(15,2),
    ctr_id integer,
    spc_id integer,
    opr_parent_id integer,
    opr_have_depend smallint,
    drp_max_extra smallint
);


--
-- Name: dcl_order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_order (
    ord_id integer NOT NULL,
    ord_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    ord_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    ord_number character varying(15) NOT NULL,
    ord_date date NOT NULL,
    ctr_id integer NOT NULL,
    cps_id integer,
    ord_concerning character varying(1000),
    ord_preamble character varying(1000),
    trm_id integer,
    ord_addr character varying(256),
    ord_pay_condition character varying(300),
    ord_delivery_term character varying(300),
    ord_add_info character varying(5000),
    usr_id_director integer,
    usr_id_logist integer,
    usr_id_director_rb integer,
    usr_id_chief_dep integer,
    usr_id_manager integer,
    ctr_id_for integer,
    spc_id integer,
    stf_id integer NOT NULL,
    ord_sent_to_prod_date date,
    ord_received_conf_date date,
    ord_num_conf character varying(200),
    ord_date_conf date,
    ord_conf_sent_date date,
    ord_executed_date date,
    ord_summ numeric(15,2),
    ord_block smallint,
    ord_delivery_cost_by character varying(50),
    ord_delivery_cost numeric(15,2),
    ord_donot_calculate_netto smallint,
    cur_id integer NOT NULL,
    ord_include_nds smallint,
    ord_nds_rate numeric(15,2),
    ord_discount_all smallint,
    ord_discount numeric(15,2),
    ord_count_itog_flag smallint,
    ord_add_reduction_flag smallint,
    ord_add_reduction numeric(15,2),
    ord_add_red_pre_pay_flag smallint,
    ord_add_red_pre_pay numeric(15,2),
    ord_all_include_in_spec smallint,
    ord_annul smallint,
    ord_ready_for_deliv_date date,
    ord_in_one_spec smallint,
    ord_comment character varying(3000),
    ord_date_conf_all smallint,
    ord_ready_for_deliv_date_all smallint,
    sdt_id integer,
    ord_shp_doc_number character varying(60),
    ord_by_guaranty smallint,
    bln_id integer NOT NULL,
    ord_arrive_in_lithuania date,
    ord_ship_from_stock date,
    ord_print_scale integer,
    ord_letter_scale integer,
    ord_comment_covering_letter character varying(1000),
    sln_id integer,
    sln_id_for_who integer NOT NULL,
    ord_logist_signature smallint,
    ord_director_rb_signature smallint,
    ord_chief_dep_signature smallint,
    ord_manager_signature smallint
);


--
-- Name: dcl_pay_list_summ; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_pay_list_summ (
    lps_id integer NOT NULL,
    pay_id integer NOT NULL,
    spc_id integer NOT NULL,
    lps_summ numeric(15,2),
    lps_summ_eur numeric(15,2),
    lps_summ_out_nds numeric(15,2)
);


--
-- Name: dcl_shipping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_shipping (
    shp_id integer NOT NULL,
    shp_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    shp_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    shp_number character varying(50) NOT NULL,
    shp_date date NOT NULL,
    spc_id integer,
    shp_summ_plus_nds numeric(15,2) NOT NULL,
    cur_id integer NOT NULL,
    shp_block smallint,
    ctr_id integer NOT NULL,
    shp_date_expiration date,
    shp_letter1_date date,
    shp_letter2_date date,
    shp_letter3_date date,
    shp_complaint_in_court_date date,
    shp_comment character varying(3000),
    shp_montage smallint,
    ctr_id_where integer,
    con_id_where integer,
    shp_notice_date date,
    shp_serial_num_year_out smallint,
    shp_summ_transport numeric(15,2),
    shp_original smallint,
    shp_sum_update numeric(15,2)
);


--
-- Name: dcl_occupied_spec_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_spec_v AS
 SELECT DISTINCT spc_id
   FROM public.dcl_con_list_spec spc
  WHERE ((spc_id IN ( SELECT DISTINCT dcl_ctc_list.spc_id
           FROM public.dcl_ctc_list
          WHERE (dcl_ctc_list.spc_id = spc.spc_id))) OR (spc_id IN ( SELECT DISTINCT dcl_order.spc_id
           FROM public.dcl_order
          WHERE (dcl_order.spc_id = spc.spc_id))) OR (spc_id IN ( SELECT DISTINCT dcl_ord_list_produce.spc_id
           FROM public.dcl_ord_list_produce
          WHERE (dcl_ord_list_produce.spc_id = spc.spc_id))) OR (spc_id IN ( SELECT DISTINCT dcl_pay_list_summ.spc_id
           FROM public.dcl_pay_list_summ
          WHERE (dcl_pay_list_summ.spc_id = spc.spc_id))) OR (spc_id IN ( SELECT DISTINCT dcl_shipping.spc_id
           FROM public.dcl_shipping
          WHERE (dcl_shipping.spc_id = spc.spc_id))));


--
-- Name: dcl_occupied_contract_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_contract_v AS
 SELECT DISTINCT con.con_id
   FROM public.dcl_contract con,
    public.dcl_con_list_spec spc
  WHERE ((spc.con_id = con.con_id) AND ((spc.spc_id IN ( SELECT dcl_occupied_spec_v.spc_id
           FROM public.dcl_occupied_spec_v
          WHERE (dcl_occupied_spec_v.spc_id = spc.spc_id))) OR (con.con_id IN ( SELECT DISTINCT dcl_cond_for_contract.con_id
           FROM public.dcl_cond_for_contract
          WHERE (dcl_cond_for_contract.con_id = con.con_id))) OR (con.con_id IN ( SELECT DISTINCT dcl_shipping.con_id_where
           FROM public.dcl_shipping
          WHERE (dcl_shipping.con_id_where = con.con_id)))));


--
-- Name: dcl_payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_payment (
    pay_id integer NOT NULL,
    pay_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    pay_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    pay_date date NOT NULL,
    pay_account character varying(35),
    pay_summ numeric(15,2) NOT NULL,
    cur_id integer NOT NULL,
    pay_course numeric(15,6),
    ctr_id integer,
    pay_block smallint,
    pay_comment character varying(500),
    pay_course_nbrb numeric(15,6),
    pay_course_nbrb_date date
);


--
-- Name: dcl_occupied_contractor_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_contractor_v AS
 SELECT DISTINCT ctr_id
   FROM public.dcl_contractor ctr
  WHERE ((ctr_id IN ( SELECT DISTINCT dcl_commercial_proposal.ctr_id
           FROM public.dcl_commercial_proposal
          WHERE (dcl_commercial_proposal.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_cond_for_contract.ctr_id
           FROM public.dcl_cond_for_contract
          WHERE (dcl_cond_for_contract.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_contract.ctr_id
           FROM public.dcl_contract
          WHERE (dcl_contract.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_contractor_request.ctr_id
           FROM public.dcl_contractor_request
          WHERE (dcl_contractor_request.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_contractor_request.ctr_id
           FROM public.dcl_contractor_request
          WHERE (dcl_contractor_request.ctr_id_other = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_dlr_list_produce.ctr_id
           FROM public.dcl_dlr_list_produce
          WHERE (dcl_dlr_list_produce.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_order.ctr_id
           FROM public.dcl_order
          WHERE (dcl_order.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_order.ctr_id_for
           FROM public.dcl_order
          WHERE (dcl_order.ctr_id_for = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_ord_list_produce.ctr_id
           FROM public.dcl_ord_list_produce
          WHERE (dcl_ord_list_produce.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_payment.ctr_id
           FROM public.dcl_payment
          WHERE (dcl_payment.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_shipping.ctr_id
           FROM public.dcl_shipping
          WHERE (dcl_shipping.ctr_id = ctr.ctr_id))) OR (ctr_id IN ( SELECT DISTINCT dcl_shipping.ctr_id_where
           FROM public.dcl_shipping
          WHERE (dcl_shipping.ctr_id_where = ctr.ctr_id))));


--
-- Name: dcl_occupied_country_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_country_v AS
 SELECT DISTINCT cut_id
   FROM public.dcl_country cut
  WHERE (cut_id IN ( SELECT DISTINCT dcl_contractor.cut_id
           FROM public.dcl_contractor
          WHERE (dcl_contractor.cut_id = cut.cut_id)));


--
-- Name: dcl_spi_list_produce; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_spi_list_produce (
    sip_id integer NOT NULL,
    spi_id integer NOT NULL,
    drp_id integer,
    sip_price numeric(15,2) NOT NULL,
    sip_count numeric(15,2) NOT NULL,
    sip_cost numeric(15,2) NOT NULL,
    sip_weight numeric(15,3),
    prd_id integer NOT NULL,
    opr_id integer,
    prs_id integer NOT NULL,
    sip_percent numeric(15,2)
);


--
-- Name: dcl_occupied_dlr_produce_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_dlr_produce_v AS
 SELECT DISTINCT drp_id
   FROM public.dcl_dlr_list_produce drp
  WHERE ((drp_id IN ( SELECT DISTINCT dcl_spi_list_produce.drp_id
           FROM public.dcl_spi_list_produce
          WHERE (dcl_spi_list_produce.drp_id = drp.drp_id))) OR (drp_id IN ( SELECT DISTINCT dcl_prc_list_produce.drp_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.drp_id = drp.drp_id))));


--
-- Name: dcl_occupied_ord_produce_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_ord_produce_v AS
 SELECT DISTINCT opr_id
   FROM public.dcl_ord_list_produce opr
  WHERE ((opr_id IN ( SELECT DISTINCT drp.opr_id
           FROM public.dcl_dlr_list_produce drp,
            public.dcl_delivery_request dlr
          WHERE ((drp.opr_id = opr.opr_id) AND (dlr.dlr_id = drp.dlr_id) AND (dlr.dlr_annul IS NULL)))) OR (opr_id IN ( SELECT DISTINCT dcl_prc_list_produce.opr_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.opr_id = opr.opr_id))) OR (opr_id IN ( SELECT DISTINCT dcl_spi_list_produce.opr_id
           FROM public.dcl_spi_list_produce
          WHERE (dcl_spi_list_produce.opr_id = opr.opr_id))) OR (opr_id IN ( SELECT DISTINCT dcl_assemble.opr_id
           FROM public.dcl_assemble
          WHERE (dcl_assemble.opr_id = opr.opr_id))) OR (opr_id IN ( SELECT DISTINCT dcl_asm_list_produce.opr_id
           FROM public.dcl_asm_list_produce
          WHERE (dcl_asm_list_produce.opr_id = opr.opr_id))));


--
-- Name: dcl_produce_cost; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_produce_cost (
    prc_id integer NOT NULL,
    prc_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    prc_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    prc_number character varying(50) NOT NULL,
    prc_date date NOT NULL,
    rut_id integer NOT NULL,
    prc_sum_transport numeric(15,2),
    prc_block smallint,
    prc_course_ltl_eur numeric(15,4),
    prc_weight numeric(15,2)
);


--
-- Name: dcl_route; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_route (
    rut_id integer NOT NULL,
    rut_name character varying(150) NOT NULL
);


--
-- Name: dcl_occupied_route_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_route_v AS
 SELECT DISTINCT rut_id
   FROM public.dcl_route rut
  WHERE (rut_id IN ( SELECT DISTINCT dcl_produce_cost.rut_id
           FROM public.dcl_produce_cost
          WHERE (dcl_produce_cost.rut_id = rut.rut_id)));


--
-- Name: dcl_seller; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_seller (
    sln_id integer NOT NULL,
    sln_name character varying(100) NOT NULL,
    sln_used_in_order smallint,
    sln_prefix_for_order character varying(10),
    sln_is_resident smallint
);


--
-- Name: dcl_occupied_seller_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_seller_v AS
 SELECT DISTINCT sln_id
   FROM public.dcl_seller sln
  WHERE (sln_id IN ( SELECT DISTINCT dcl_contract.sln_id
           FROM public.dcl_contract
          WHERE (dcl_contract.sln_id = sln.sln_id)));


--
-- Name: dcl_ready_for_shipping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ready_for_shipping (
    rfs_id integer NOT NULL,
    opr_id integer NOT NULL,
    sdt_id integer NOT NULL,
    rfs_number character varying(60) NOT NULL,
    rfs_count numeric(15,3) NOT NULL,
    rfs_date date NOT NULL,
    rfs_weight numeric(15,3),
    rfs_gabarit character varying(300),
    rfs_comment character varying(900),
    rfs_arrive_in_lithuania date,
    rfs_ship_from_stock date
);


--
-- Name: dcl_shp_doc_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_shp_doc_type (
    sdt_id integer NOT NULL,
    sdt_name character varying(100) NOT NULL
);


--
-- Name: dcl_occupied_shp_doc_type_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_shp_doc_type_v AS
 SELECT DISTINCT sdt_id
   FROM public.dcl_shp_doc_type sdt
  WHERE ((sdt_id IN ( SELECT DISTINCT dcl_order.sdt_id
           FROM public.dcl_order
          WHERE (dcl_order.sdt_id = sdt.sdt_id))) OR (sdt_id IN ( SELECT DISTINCT dcl_ready_for_shipping.sdt_id
           FROM public.dcl_ready_for_shipping
          WHERE (dcl_ready_for_shipping.sdt_id = sdt.sdt_id))));


--
-- Name: dcl_occupied_spec_in_pay_shp_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_spec_in_pay_shp_v AS
 SELECT DISTINCT spc_id
   FROM public.dcl_con_list_spec spc
  WHERE ((spc_id IN ( SELECT DISTINCT dcl_pay_list_summ.spc_id
           FROM public.dcl_pay_list_summ
          WHERE (dcl_pay_list_summ.spc_id = spc.spc_id))) OR (spc_id IN ( SELECT DISTINCT dcl_shipping.spc_id
           FROM public.dcl_shipping
          WHERE (dcl_shipping.spc_id = spc.spc_id))));


--
-- Name: dcl_occupied_spi_produce_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_spi_produce_v AS
 SELECT DISTINCT sip_id
   FROM public.dcl_spi_list_produce sip
  WHERE ((sip_id IN ( SELECT DISTINCT dcl_prc_list_produce.sip_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.sip_id = sip.sip_id))) OR (sip_id IN ( SELECT DISTINCT drp.sip_id
           FROM public.dcl_dlr_list_produce drp,
            public.dcl_delivery_request dlr
          WHERE ((drp.sip_id = sip.sip_id) AND (dlr.dlr_id = drp.dlr_id) AND (dlr.dlr_annul IS NULL)))));


--
-- Name: dcl_stuff_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_stuff_category (
    stf_id integer NOT NULL,
    stf_name character varying(150) NOT NULL,
    stf_show_in_montage smallint
);


--
-- Name: dcl_occupied_stuff_category_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_occupied_stuff_category_v AS
 SELECT DISTINCT stf_id
   FROM public.dcl_stuff_category stf
  WHERE ((stf_id IN ( SELECT DISTINCT dcl_assemble.stf_id
           FROM public.dcl_assemble
          WHERE (dcl_assemble.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_catalog_number.stf_id
           FROM public.dcl_catalog_number
          WHERE (dcl_catalog_number.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_cfc_list_produce.stf_id
           FROM public.dcl_cfc_list_produce
          WHERE (dcl_cfc_list_produce.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_contractor_request.stf_id
           FROM public.dcl_contractor_request
          WHERE (dcl_contractor_request.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_cpr_list_produce.stf_id
           FROM public.dcl_cpr_list_produce
          WHERE (dcl_cpr_list_produce.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_cpr_transport.stf_id
           FROM public.dcl_cpr_transport
          WHERE (dcl_cpr_transport.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_dlr_list_produce.stf_id
           FROM public.dcl_dlr_list_produce
          WHERE (dcl_dlr_list_produce.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_montage_adjustment.stf_id
           FROM public.dcl_montage_adjustment
          WHERE (dcl_montage_adjustment.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_order.stf_id
           FROM public.dcl_order
          WHERE (dcl_order.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_prc_list_produce.stf_id
           FROM public.dcl_prc_list_produce
          WHERE (dcl_prc_list_produce.stf_id = stf.stf_id))) OR (stf_id IN ( SELECT DISTINCT dcl_shp_list_produce.stf_id
           FROM public.dcl_shp_list_produce
          WHERE (dcl_shp_list_produce.stf_id = stf.stf_id))));


--
-- Name: dcl_opr_list_executed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_opr_list_executed (
    opr_id integer NOT NULL,
    opr_count_executed numeric(15,2),
    opr_date_executed date,
    opr_fictive_executed smallint
);


--
-- Name: dcl_ord_list_pay_sum; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ord_list_pay_sum (
    ops_id integer NOT NULL,
    ord_id integer NOT NULL,
    ops_sum numeric(15,2) NOT NULL,
    ops_date date
);


--
-- Name: dcl_ord_list_payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ord_list_payment (
    orp_id integer NOT NULL,
    ord_id integer NOT NULL,
    orp_percent numeric(11,5) NOT NULL,
    orp_sum numeric(15,2) NOT NULL,
    orp_date date
);


--
-- Name: dcl_ord_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_ord_message (
    orm_id integer NOT NULL,
    ord_id integer NOT NULL,
    usr_id integer NOT NULL,
    orm_create_date timestamp without time zone NOT NULL,
    orm_message character varying(256),
    prc_id integer
);


--
-- Name: dcl_outgoing_letter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_outgoing_letter (
    otl_id integer NOT NULL,
    otl_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    otl_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    otl_number character varying(15) NOT NULL,
    otl_date date NOT NULL,
    ctr_id integer NOT NULL,
    cps_id integer,
    otl_comment character varying(5000),
    sln_id integer NOT NULL
);


--
-- Name: dcl_pay_message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_pay_message (
    pms_id integer NOT NULL,
    pay_id integer NOT NULL,
    usr_id integer NOT NULL,
    pms_create_date timestamp without time zone NOT NULL,
    pms_message character varying(512),
    pms_sum numeric(15,2) NOT NULL,
    ctr_id integer,
    pms_percent numeric(15,2),
    pms_check_for_delete smallint,
    pms_updated smallint,
    cur_id integer,
    pms_no_curator smallint
);


--
-- Name: dcl_prc_ctr_for_calcstate; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_prc_ctr_for_calcstate (
    lpc_id integer NOT NULL,
    prc_id integer NOT NULL,
    ctr_id integer NOT NULL,
    con_id integer,
    spc_id integer
);


--
-- Name: dcl_produce_cost_custom; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_produce_cost_custom (
    prc_id integer NOT NULL,
    lpc_percent numeric(15,2),
    lpc_summ numeric(15,2),
    lpc_summ_allocation numeric(15,2)
);


--
-- Name: dcl_produce_language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_produce_language (
    prd_id integer NOT NULL,
    lng_id integer NOT NULL,
    prd_lng_name character varying(1000)
);


--
-- Name: dcl_production_term; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_production_term (
    ptr_id integer NOT NULL,
    opr_id integer NOT NULL,
    ptr_count numeric(15,3) NOT NULL,
    ptr_date date NOT NULL,
    ptr_comment character varying(900)
);


--
-- Name: dcl_purchase_purpose; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_purchase_purpose (
    pps_id integer NOT NULL,
    pps_name character varying(200) NOT NULL
);


--
-- Name: dcl_purpose; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_purpose (
    prs_id integer NOT NULL,
    prs_name character varying(200) NOT NULL
);


--
-- Name: dcl_rate_nds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_rate_nds (
    rtn_id integer NOT NULL,
    rtn_date_from date NOT NULL,
    rtn_percent numeric(15,2)
);


--
-- Name: dcl_reputation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_reputation (
    rpt_id integer NOT NULL,
    rpt_level smallint NOT NULL,
    rpt_description character varying(500) NOT NULL,
    rpt_default_in_ctc smallint
);


--
-- Name: dcl_rests_in_minsk_temporary; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_rests_in_minsk_temporary (
    id integer,
    date_created timestamp without time zone,
    quantity numeric(15,2),
    contractor_name character varying(200),
    specification_number character varying(50),
    contract_number character varying(50)
);


--
-- Name: dcl_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_role (
    rol_id integer NOT NULL,
    rol_name character varying(32) NOT NULL
);


--
-- Name: dcl_setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_setting (
    stn_id integer NOT NULL,
    stn_name character varying(100) NOT NULL,
    stn_description character varying(256),
    stn_value character varying(1000),
    stn_type smallint NOT NULL,
    stn_action character varying(100),
    stn_value_extended character varying(1000)
);


--
-- Name: dcl_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_user (
    usr_id integer NOT NULL,
    usr_code character varying(3),
    usr_login character varying(8),
    usr_passwd character varying(64),
    dep_id integer,
    usr_phone character varying(50),
    usr_block smallint,
    usr_respons_person smallint,
    usr_no_login smallint,
    usr_chief_dep smallint,
    usr_fax character varying(50),
    usr_email character varying(100),
    usr_local_entry smallint,
    usr_internet_entry smallint
);


--
-- Name: dcl_shp_usr_dep_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_shp_usr_dep_v AS
 SELECT DISTINCT shp.shp_id,
    usr.usr_id,
    dep.dep_id
   FROM public.dcl_department dep,
    public.dcl_shipping shp,
    public.dcl_shp_list_produce lps,
    public.dcl_user usr,
    public.dcl_lps_list_manager lmn
  WHERE ((dep.dep_id = usr.dep_id) AND (usr.usr_id = lmn.usr_id) AND (shp.shp_id = lps.shp_id) AND (lps.lps_id = lmn.lps_id));


--
-- Name: dcl_spc_list_payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_spc_list_payment (
    spp_id integer NOT NULL,
    spc_id integer NOT NULL,
    spp_percent numeric(11,5) NOT NULL,
    spp_sum numeric(15,2) NOT NULL,
    spp_date date
);


--
-- Name: dcl_spec_in_ctc_v; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dcl_spec_in_ctc_v AS
 SELECT DISTINCT spc_id
   FROM public.dcl_con_list_spec spc
  WHERE (spc_id IN ( SELECT DISTINCT dcl_ctc_list.spc_id
           FROM public.dcl_ctc_list
          WHERE (dcl_ctc_list.spc_id = spc.spc_id)));


--
-- Name: dcl_specification_import; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_specification_import (
    spi_id integer NOT NULL,
    spi_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    spi_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    spi_number character varying(100) NOT NULL,
    spi_date date NOT NULL,
    spi_comment character varying(2000),
    spi_course numeric(15,4),
    spi_koeff numeric(15,3),
    spi_arrive smallint,
    spi_cost numeric(15,2) NOT NULL,
    spi_send_date date
);


--
-- Name: dcl_term_inco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_term_inco (
    trm_id integer NOT NULL,
    trm_name character varying(10) NOT NULL,
    trm_name_extended character varying(100) NOT NULL,
    trm_order_id integer NOT NULL
);


--
-- Name: dcl_test; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_test (
    tst_id integer NOT NULL,
    tst_name character varying(128) NOT NULL,
    tst_decimal numeric(15,2)
);


--
-- Name: dcl_timeboard; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_timeboard (
    tmb_id integer NOT NULL,
    usr_id integer NOT NULL,
    tmb_date date NOT NULL,
    tmb_checked smallint,
    tmb_create_date timestamp without time zone NOT NULL,
    usr_id_create integer NOT NULL,
    tmb_edit_date timestamp without time zone NOT NULL,
    usr_id_edit integer NOT NULL,
    tmb_checked_date timestamp without time zone,
    usr_id_checked integer
);


--
-- Name: dcl_tmb_list_work; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_tmb_list_work (
    tbw_id integer NOT NULL,
    tmb_id integer NOT NULL,
    tbw_date date NOT NULL,
    tbw_from time without time zone NOT NULL,
    tbw_to time without time zone NOT NULL,
    tbw_hours_update numeric(15,2) NOT NULL,
    crq_id integer,
    tbw_comment character varying(2000)
);


--
-- Name: dcl_unit; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_unit (
    unt_id integer NOT NULL,
    is_acceptable_for_cpr character(1) DEFAULT '1'::bpchar NOT NULL
);


--
-- Name: dcl_unit_language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_unit_language (
    unt_id integer NOT NULL,
    lng_id integer NOT NULL,
    unt_name character varying(150)
);


--
-- Name: dcl_user_language; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_user_language (
    usr_id integer NOT NULL,
    lng_id integer NOT NULL,
    usr_surname character varying(20),
    usr_name character varying(20),
    usr_position character varying(60)
);


--
-- Name: dcl_user_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_user_link (
    uln_id integer NOT NULL,
    usr_id integer NOT NULL,
    uln_create_date timestamp without time zone NOT NULL,
    uln_url character varying(64) NOT NULL,
    uln_parameters character varying(128) NOT NULL,
    uln_text character varying(500),
    uln_menu_id character varying(50) NOT NULL
);


--
-- Name: dcl_user_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_user_role (
    usr_id integer NOT NULL,
    rol_id integer NOT NULL
);


--
-- Name: dcl_user_setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_user_setting (
    ust_id integer NOT NULL,
    ust_name character varying(100) NOT NULL,
    ust_description character varying(256),
    ust_value character varying(1000),
    ust_type smallint NOT NULL,
    ust_action character varying(100),
    ust_value_extended character varying(1000),
    usr_id integer NOT NULL
);


--
-- Name: dcl_year_num; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dcl_year_num (
    dcl_year integer NOT NULL,
    dcl_num integer NOT NULL,
    dcl_table character varying(64) NOT NULL
);


--
-- Name: gen_dcl_account_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_account_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_action_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_action_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_asm_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_asm_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_assemble_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_assemble_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_attachment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_attachment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_blank_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_blank_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_blank_image_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_blank_image_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_catalog_number_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_catalog_number_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_category_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_category_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_cfc_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_cfc_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_cfc_message_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_cfc_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_commercial_proposal_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_commercial_proposal_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_common_blank_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_common_blank_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_common_blank_light_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_common_blank_light_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_con_list_spec_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_con_list_spec_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_con_message_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_con_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_cond_for_contract_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_cond_for_contract_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_contact_person_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_contact_person_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_contract_closed_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_contract_closed_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_contract_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_contract_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_contractor_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_contractor_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_contractor_request_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_contractor_request_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_country_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_country_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_cpr_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_cpr_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_cpr_transport_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_cpr_transport_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_crq_print_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_crq_print_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_crq_stage_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_crq_stage_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ctc_list_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ctc_list_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_currency_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_currency_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_currency_rate_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_currency_rate_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_custome_code_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_custome_code_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_delivery_request_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_delivery_request_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_department_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_department_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_dlr_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_dlr_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_field_comment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_field_comment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_files_path_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_files_path_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_inf_message_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_inf_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_instruction_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_instruction_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_instruction_type_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_instruction_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_language_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_language_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_letterhead_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_letterhead_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_log_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_log_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_lps_list_manager_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_lps_list_manager_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_montage_adjustment_h_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_montage_adjustment_h_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_montage_adjustment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_montage_adjustment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ord_list_pay_sum_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ord_list_pay_sum_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ord_list_payment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ord_list_payment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ord_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ord_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ord_message_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ord_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_order_blank_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_order_blank_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_order_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_order_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_outgoing_letter_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_outgoing_letter_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_pay_list_summ_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_pay_list_summ_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_pay_message_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_pay_message_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_payment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_payment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_prc_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_prc_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_produce_cost_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_produce_cost_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_production_term_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_production_term_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_purchase_purpose_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_purchase_purpose_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_purpose_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_purpose_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_rate_nds_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_rate_nds_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_ready_for_shipping_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_ready_for_shipping_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_reputation_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_reputation_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_role_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_role_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_route_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_route_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_seller_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_seller_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_setting_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_setting_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_shipping_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_shipping_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_shp_doc_type_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_shp_doc_type_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_shp_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_shp_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_spc_list_payment_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_spc_list_payment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_specification_import_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_specification_import_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_spi_list_produce_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_spi_list_produce_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_stuff_category_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_stuff_category_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_term_inco_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_term_inco_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_test_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_test_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_timeboard_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_timeboard_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_tmb_list_work_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_tmb_list_work_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_unit_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_unit_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_user_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_user_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_user_link_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_user_link_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gen_dcl_user_setting_id; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gen_dcl_user_setting_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Data for Name: dcl_1c_number_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_1c_number_history (id, prd_id, number_1c, date_created) FROM stdin;
\.


--
-- Data for Name: dcl_account; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_account (acc_id, ctr_id, acc_name, acc_account, cur_id, acc_index) FROM stdin;
\.


--
-- Data for Name: dcl_action; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_action (act_id, act_name, act_system_name, act_logging, act_check_access) FROM stdin;
1	Логин	LoginAction	1	\N
2	Логаут	LogoutAction	1	\N
3	\N	/Menu.do?current_menu_id=id.journals	\N	\N
4	\N	/JournalsAction.do?dispatch=input	\N	\N
5	\N	/Menu.do?current_menu_id=id.commercial_proposal	\N	\N
6	\N	/CommercialProposalsAction.do?dispatch=input	\N	\N
7	\N	/Menu.do?current_menu_id=id.order	\N	\N
8	\N	/OrdersAction.do?dispatch=input	\N	\N
9	\N	/StuffCategoriesListAction.do	\N	\N
10	\N	/OrdersAction.do?dispatch=filter	\N	\N
11	\N	/OrderAction.do?dispatch=edit	\N	\N
12	\N	/Menu.do?current_menu_id=id.contractDoc	\N	\N
13	\N	/ContractsAction.do?dispatch=input	\N	\N
14	\N	/ContractsAction.do?dispatch=filter	\N	\N
15	\N	/ContractAction.do?dispatch=edit	\N	\N
16	\N	/ContractAction.do?dispatch=back	\N	\N
17	\N	/ContractsAction.do?dispatch=restore	\N	\N
18	\N	/Menu.do?current_menu_id=id.reports	\N	\N
19	\N	/ReportsAction.do?dispatch=input	\N	\N
20	\N	/Menu.do?current_menu_id=id.calculation_state	\N	\N
21	\N	/CalculationStateAction.do?dispatch=input	\N	\N
22	\N	/CalculationStateAction.do?dispatch=ajaxGetReputation	\N	\N
23	\N	/Menu.do?current_menu_id=id.payment	\N	\N
24	\N	/PaymentsAction.do?dispatch=input	\N	\N
25	\N	/PaymentAction.do?dispatch=clone	\N	\N
26	\N	/PaymentAction.do?dispatch=reloadAccount	\N	\N
27	\N	/PaymentAction.do?dispatch=reload	\N	\N
28	\N	/ContractorsListAction.do	\N	\N
29	\N	/SellersListAction.do	\N	\N
30	\N	/CalculationStateAction.do?dispatch=formir	\N	\N
31	\N	/PaymentAction.do?dispatch=newPaySum	\N	\N
32	\N	/PaySummAction.do?dispatch=insert	\N	\N
33	\N	/ContractsDepFromContractorListAction.do	\N	\N
34	\N	/PaySummAction.do?dispatch=reload	\N	\N
35	\N	/SpecificationsDepFromContractListAction.do	\N	\N
36	\N	/PaySummAction.do?dispatch=reload_spec	\N	\N
37	\N	/PaySummAction.do?dispatch=process	\N	\N
38	\N	/PaymentAction.do?dispatch=retFromPaySumOperation	\N	\N
39	\N	/PaymentAction.do?dispatch=process	\N	\N
40	\N	/PaymentsAction.do?dispatch=restore	\N	\N
41	\N	/CommercialProposalAction.do?dispatch=input	\N	\N
42	\N	/CommercialProposalAction.do?dispatch=back	\N	\N
43	\N	/CommercialProposalsAction.do?dispatch=restore	\N	\N
44	\N	/CommercialProposalsAction.do?dispatch=filter	\N	\N
45	\N	/CommercialProposalsAction.do?dispatch=clone	\N	\N
46	\N	/CommercialProposalsAction.do?dispatch=cloneLikeNewVersion	\N	\N
47	\N	/CommercialProposalAction.do?dispatch=cloneLikeNewVersion	\N	\N
48	\N	/CommercialProposalAction.do?dispatch=deleteProduce	\N	\N
49	\N	/CommercialProposalAction.do?dispatch=show	\N	\N
50	\N	/CommercialProposalAction.do?dispatch=edit	\N	\N
51	\N	/CommercialProposalsAction.do?dispatch=cloneLikeOldVersion	\N	\N
52	\N	/CommercialProposalAction.do?dispatch=cloneLikeOldVersion	\N	\N
53	\N	/CommercialProposalAction.do?dispatch=editProduce	\N	\N
54	\N	/CommercialProposalProduceAction.do?dispatch=edit	\N	\N
55	\N	/CommercialProposalProduceAction.do?dispatch=process	\N	\N
56	\N	/CommercialProposalAction.do?dispatch=retFromProduceOperation	\N	\N
57	\N	/CommercialProposalAction.do?dispatch=print	\N	\N
58	\N	/CommercialProposalPrintAction.do	\N	\N
59	\N	/CommercialProposalAction.do?dispatch=reload	\N	\N
60	\N	/ContactPersonsForContractorListAction.do	\N	\N
61	\N	/CommercialProposalAction.do?dispatch=reloadContactPerson	\N	\N
62	\N	/CommercialProposalAction.do?dispatch=newProduce	\N	\N
63	\N	/CommercialProposalProduceAction.do?dispatch=insert	\N	\N
64	\N	/CustomCodesListAction.do	\N	\N
65	\N	/CommercialProposalAction.do?dispatch=process	\N	\N
66	\N	/CommercialProposalProduceAction.do?dispatch=selectProduce	\N	\N
67	\N	/CommercialProposalProduceSelectNomenclatureAction.do?dispatch=input	\N	\N
68	\N	/NomenclatureAction.do?dispatch=input	\N	\N
69	\N	/NomenclatureAction.do?dispatch=ajaxTree	\N	\N
70	\N	/NomenclatureAction.do?dispatch=ajaxGrid	\N	\N
71	\N	/CommercialProposalProduceSelectNomenclatureAction.do?dispatch=select	\N	\N
72	\N	/CommercialProposalProduceAction.do?dispatch=returnFromSelectNomenclature	\N	\N
73	\N	/Menu.do?current_menu_id=id.condition_for_contract	\N	\N
74	\N	/ConditionsForContractAction.do?dispatch=input	\N	\N
75	\N	/ConditionForContractAction.do?dispatch=input	\N	\N
76	\N	/ConditionForContractAction.do?dispatch=reload	\N	\N
77	\N	/CurrenciesListAction.do	\N	\N
78	\N	/PurchasePurposesListAction.do	\N	\N
79	\N	/ConditionForContractAction.do?dispatch=selectCP	\N	\N
80	\N	/SelectKPConditionForContractAction.do?dispatch=input	\N	\N
81	\N	/SelectKPConditionForContractAction.do?dispatch=select	\N	\N
82	\N	/ConditionForContractAction.do?dispatch=returnFromSelectCP	\N	\N
83	\N	/ConditionForContractAction.do?dispatch=print	\N	\N
84	\N	/ConditionForContractPrintAction.do	\N	\N
85	\N	/ConditionForContractAction.do?dispatch=editProduce	\N	\N
86	\N	/ConditionForContractProduceAction.do?dispatch=edit	\N	\N
87	\N	/OrderAction.do?dispatch=process	\N	\N
88	\N	/OrdersAction.do?dispatch=restore	\N	\N
89	\N	/ConditionForContractProduceAction.do?dispatch=selectProduce	\N	\N
90	\N	/ConditionForContractProduceSelectNomenclatureAction.do?dispatch=input	\N	\N
91	\N	/ConditionForContractProduceSelectNomenclatureAction.do?dispatch=select	\N	\N
92	\N	/ConditionForContractProduceAction.do?dispatch=returnFromSelectNomenclature	\N	\N
93	\N	/ConditionForContractProduceAction.do?dispatch=process	\N	\N
94	\N	/ConditionForContractAction.do?dispatch=retFromProduceOperation	\N	\N
95	\N	/ConditionForContractAction.do?dispatch=attach	\N	\N
96	\N	/DefferedUploadFileAction.do?dispatch=input	\N	\N
97	\N	/CommercialProposalProduceAction.do?dispatch=clone	\N	\N
98	\N	/DefferedUploadFileAction.do?dispatch=process	\N	\N
99	\N	/ConditionForContractAction.do?dispatch=process	\N	\N
100	\N	/ConditionForContractAction.do?dispatch=process_force	\N	\N
101	\N	/ConditionsForContractAction.do?dispatch=restore	\N	\N
102	\N	/OrderAction.do?dispatch=ajaxIsContractCopy	\N	\N
103	\N	/OrderAction.do?dispatch=ajaxIsSpecificationCopy	\N	\N
104	\N	/UsersListAction.do	\N	\N
105	\N	/Menu.do?current_menu_id=id.goods_rest_minsk	\N	\N
106	\N	/GoodsRestAction.do?dispatch=input	\N	\N
107	\N	/LogoImgsListAction.do	\N	\N
108	\N	/PurposesListAction.do	\N	\N
109	\N	/GoodsRestAction.do?dispatch=formir	\N	\N
110	\N	/Menu.do?current_menu_id=id.shipping	\N	\N
111	\N	/ShippingsAction.do?dispatch=input	\N	\N
112	\N	/ShippingsAction.do?dispatch=filter	\N	\N
113	\N	/ShippingAction.do?dispatch=edit	\N	\N
114	\N	/ShippingAction.do?dispatch=ajaxManagsersGrid	\N	\N
115	\N	/ShippingAction.do?dispatch=back	\N	\N
116	\N	/ShippingsAction.do?dispatch=restore	\N	\N
117	\N	/Menu.do?current_menu_id=id.references	\N	\N
118	\N	/ReferencesAction.do?dispatch=input	\N	\N
119	\N	/DepartmentsListAction.do	\N	\N
120	\N	/Menu.do?current_menu_id=id.requestContractor	\N	\N
121	\N	/ContractorRequestsAction.do?dispatch=input	\N	\N
122	\N	/ContractorRequestTypeListAction.do	\N	\N
123	\N	/ContractorRequestsAction.do?dispatch=filter	\N	\N
124	\N	/ContractorRequestAction.do?dispatch=edit	\N	\N
125	\N	/ContractorRequestAction.do?dispatch=downloadAttachment	\N	\N
126	\N	/ConditionForContractAction.do?dispatch=edit	\N	\N
127	\N	/Menu.do?current_menu_id=id.contractors	\N	\N
128	\N	/ContractorsAction.do?dispatch=input	\N	\N
129	\N	/ContractorAction.do?dispatch=editContactPersons	\N	\N
130	\N	/PaymentAction.do?dispatch=edit	\N	\N
131	\N	/PaymentAction.do?dispatch=back	\N	\N
132	\N	/ConditionForContractAction.do?dispatch=back	\N	\N
133	\N	/Menu.do?current_menu_id=id.outgoingLetter	\N	\N
134	\N	/OutgoingLettersAction.do?dispatch=input	\N	\N
135	\N	/ConditionForContractAction.do?dispatch=downloadAttachment	\N	\N
136	\N	/OutgoingLetterAction.do?dispatch=input	\N	\N
137	\N	/ContractorsAction.do?dispatch=restore	\N	\N
138	\N	/OutgoingLetterAction.do?dispatch=newContractor	\N	\N
139	\N	/ContractorAddActionOutgoingLetter.do?dispatch=create	\N	\N
140	\N	/CountriesListAction.do	\N	\N
141	\N	/ContractorAddActionOutgoingLetter.do?dispatch=process	\N	\N
142	\N	/OutgoingLetterAction.do?dispatch=retFromContractor	\N	\N
143	\N	/OutgoingLetterAction.do?dispatch=process	\N	\N
144	\N	/OutgoingLettersAction.do?dispatch=restore	\N	\N
145	\N	/NomenclatureAction.do?dispatch=filter	\N	\N
146	\N	/CommercialProposalProduceAction.do?dispatch=back	\N	\N
147	\N	/ContractorRequestAction.do?dispatch=back	\N	\N
148	\N	/ContractorRequestsAction.do?dispatch=restore	\N	\N
149	\N	/ContractAction.do?dispatch=downloadAttachment	\N	\N
150	\N	/ConditionsForContractAction.do?dispatch=markExecute	\N	\N
151	\N	/OrderAction.do?dispatch=back	\N	\N
152	\N	/ShowPrevResponse.do?dispatch=edit	\N	\N
153	\N	/ProduceMovementForGoodsRestAction.do?dispatch=input	\N	\N
154	\N	/ProduceMovementForGoodsRestAction.do?dispatch=back	\N	\N
155	\N	/GoodsRestAction.do?dispatch=fromProduceMovement	\N	\N
156	\N	/GoodsRestAction.do?dispatch=downloadImage	\N	\N
157	\N	/Menu.do?current_menu_id=id.produce_cost	\N	\N
158	\N	/ProducesCostAction.do?dispatch=input	\N	\N
159	\N	/OrderAction.do?dispatch=downloadAttachment	\N	\N
160	\N	/Menu.do?current_menu_id=id.adm_zone	\N	\N
161	\N	/Menu.do?current_menu_id=id.locked_records	\N	\N
162	\N	/LockedRecords.do?dispatch=list	\N	\N
163	\N	/LockedRecords.do?dispatch=unlock	\N	\N
164	\N	/CalculationStateAction.do?dispatch=contract	\N	\N
165	\N	/ContractActionCalculationState.do?dispatch=edit	\N	\N
166	\N	/ContractActionCalculationState.do?dispatch=editSpecification	\N	\N
167	\N	/SpecificationActionCalculationState.do?dispatch=edit	\N	\N
168	\N	/SpecificationActionCalculationState.do?dispatch=back	\N	\N
169	\N	/ContractActionCalculationState.do?dispatch=retFromSpecificationOperation	\N	\N
170	\N	/ContractActionCalculationState.do?dispatch=back	\N	\N
171	\N	/CalculationStateAction.do?dispatch=back_to_calc_state_from_contract	\N	\N
172	\N	/Menu.do?current_menu_id=id.margin	\N	\N
173	\N	/MarginAction.do?dispatch=input	\N	\N
174	\N	/Menu.do?current_menu_id=id.specification_import	\N	\N
175	\N	/SpecificationImportsAction.do?dispatch=input	\N	\N
176	\N	/SpecificationImportAction.do?dispatch=edit	\N	\N
177	Формирование отчёта по марже	/MarginAction.do?dispatch=formir	1	\N
178	\N	/SpecificationImportAction.do?dispatch=formirExcel	\N	\N
179	\N	/Menu.do?current_menu_id=id.nomenclature	\N	\N
180	\N	/ContractAction.do?dispatch=editSpecification	\N	\N
181	\N	/SpecificationAction.do?dispatch=edit	\N	\N
182	\N	/NomenclatureProduceAction.do?dispatch=edit	\N	\N
183	\N	/NomenclatureProduceAction.do?dispatch=ajaxLTGrid	\N	\N
184	\N	/NomenclatureProduceAction.do?dispatch=ajaxCNGrid	\N	\N
185	\N	/SpecificationAction.do?dispatch=back	\N	\N
186	\N	/ContractAction.do?dispatch=retFromSpecificationOperation	\N	\N
187	\N	/SpecificationImportAction.do?dispatch=process	\N	\N
188	\N	/SpecificationImportsAction.do?dispatch=restore	\N	\N
189	\N	/NomenclatureProduceAction.do?dispatch=print	\N	\N
190	\N	/NomenclatureProducePrintAction.do	\N	\N
191	\N	/NomenclatureProduceAction.do?dispatch=back	\N	\N
192	\N	/NomenclatureAction.do?dispatch=retFromEdit	\N	\N
193	\N	/Menu.do?current_menu_id=id.exit	\N	\N
194	\N	/Logout.do?dispatch=input	\N	\N
195	\N	/ContractorsAction.do?dispatch=filter	\N	\N
196	\N	/ContractorAction.do?dispatch=edit	\N	\N
197	\N	/ContractorAction.do?dispatch=process	\N	\N
198	\N	/Menu.do?current_menu_id=id.instruction	\N	\N
199	\N	/InstructionsAction.do?dispatch=input	\N	\N
200	\N	/InstructionAction.do?dispatch=edit	\N	\N
201	\N	/InstructionAction.do?dispatch=downloadAttachment	\N	\N
202	\N	/ProduceMovementForNomenclatureAction.do?dispatch=input	\N	\N
203	\N	/ProduceMovementForNomenclatureAction.do?dispatch=reload	\N	\N
204	\N	/InstructionAction.do?dispatch=back	\N	\N
205	\N	/InstructionsAction.do?dispatch=restore	\N	\N
206	\N	/GoodsRestAction.do?dispatch=formirExcel	\N	\N
207	\N	/Menu.do?current_menu_id=id.custom_code	\N	\N
208	\N	/CustomCodesAction.do	\N	\N
209	\N	/BlanksListAction.do	\N	\N
210	\N	/CommercialProposalAction.do?dispatch=newContractor	\N	\N
211	\N	/ContractorAddActionCommercialProposal.do?dispatch=create	\N	\N
212	\N	/ContractorAddActionCommercialProposal.do?dispatch=process	\N	\N
213	\N	/ContractorAddActionCommercialProposal.do?dispatch=addCountry	\N	\N
214	\N	/AddCountryActionAddCommercialProposal.do?dispatch=create	\N	\N
215	\N	/ContractorAddActionCommercialProposal.do?dispatch=fromAddCountry	\N	\N
216	\N	/CommercialProposalAction.do?dispatch=retFromContractor	\N	\N
217	\N	/IncoTermsListAction.do	\N	\N
218	\N	/CommercialProposalAction.do?dispatch=reloadPrice	\N	\N
219	\N	/NomenclatureProduceAction.do?dispatch=process	\N	\N
220	\N	/NomenclatureProduceAction.do?dispatch=show	\N	\N
221	\N	/OrderAction.do?dispatch=clone	\N	\N
222	\N	/OrderAction.do?dispatch=reload	\N	\N
223	\N	/AttachmentsAction.do?dispatch=download	\N	\N
224	\N	/OrderAction.do?dispatch=editProduce	\N	\N
225	\N	/OrderProduceAction.do?dispatch=edit	\N	\N
226	\N	/OrderProduceAction.do?dispatch=process	\N	\N
227	\N	/OrderAction.do?dispatch=retFromProduceOperation	\N	\N
228	\N	/CommercialProposalAction.do?dispatch=importExcel	\N	\N
229	\N	/CommercialProposalImportAction.do?dispatch=input	\N	\N
230	\N	/CommercialProposalImportAction.do?dispatch=back	\N	\N
231	\N	/OrderAction.do?dispatch=print	\N	\N
232	\N	/OrderPrintAction.do	\N	\N
233	\N	/Menu.do?current_menu_id=id.currencies	\N	\N
234	\N	/CurrenciesAction.do?dispatch=execute	\N	\N
235	\N	/CurrenciesAction.do?dispatch=receiveFromBankCourses	\N	\N
236	\N	/CurrencyRatesAction.do?dispatch=execute	\N	\N
237	\N	/OrderAction.do?dispatch=print_letter	\N	\N
238	\N	/CoveringLetterForOrderPrintAction.do	\N	\N
239	\N	/ProduceMovementForNomenclatureAction.do?dispatch=back	\N	\N
240	\N	/ConditionsForContractAction.do?dispatch=filter	\N	\N
241	\N	/SpecificationImportAction.do?dispatch=back	\N	\N
242	\N	/Menu.do?current_menu_id=id.in_delivery_request	\N	\N
243	\N	/DeliveryRequestsAction.do?dispatch=input	\N	\N
244	\N	/DeliveryRequestAction.do?dispatch=input	\N	\N
245	\N	/Menu.do?current_menu_id=id.timeboard	\N	\N
246	\N	/TimeboardsAction.do?dispatch=input	\N	\N
247	\N	/TimeboardAction.do?dispatch=edit	\N	\N
248	\N	/DeliveryRequestAction.do?dispatch=selectDocsForDeliveryRequest	\N	\N
249	\N	/DeliveryRequestPositionsAction.do?dispatch=input	\N	\N
250	\N	/DeliveryRequestPositionsAction.do?dispatch=add	\N	\N
251	\N	/DeliveryRequestPositionsAction.do?dispatch=save	\N	\N
252	\N	/DeliveryRequestAction.do?dispatch=backFromSelect	\N	\N
253	\N	/TimeboardAction.do?dispatch=back	\N	\N
254	\N	/TimeboardsAction.do?dispatch=restore	\N	\N
255	\N	/DeliveryRequestAction.do?dispatch=editProduce	\N	\N
256	\N	/DeliveryRequestProduceAction.do?dispatch=edit	\N	\N
257	\N	/ContractorRequestAction.do?dispatch=printEnumerationWork	\N	\N
258	\N	/ContractorRequestPrintActAction.do	\N	\N
259	\N	/DeliveryRequestProduceAction.do?dispatch=process	\N	\N
260	\N	/DeliveryRequestAction.do?dispatch=retFromProduceOperation	\N	\N
261	\N	/DeliveryRequestProduceAction.do?dispatch=back	\N	\N
262	\N	/Menu.do?current_menu_id=id.statistics_orders	\N	\N
263	\N	/OrdersStatisticsAction.do?dispatch=input	\N	\N
264	\N	/OrdersStatisticsAction.do?dispatch=formir	\N	\N
265	\N	/CommercialProposalAction.do?dispatch=printInvoice	\N	\N
266	\N	/CommercialProposalsAction.do?dispatch=check_price	\N	\N
267	\N	/DeliveryRequestAction.do?dispatch=process	\N	\N
268	\N	/DeliveryRequestsAction.do?dispatch=restore	\N	\N
269	\N	/OrderAction.do?dispatch=loadIsWarn	\N	\N
270	\N	/OrderAction.do?dispatch=defferedAttach	\N	\N
271	\N	/OrderAction.do?dispatch=retFromAttach	\N	\N
272	\N	/DeliveryRequestAction.do?dispatch=edit	\N	\N
273	\N	/OutgoingLetterAction.do?dispatch=edit	\N	\N
274	\N	/OutgoingLetterAction.do?dispatch=defferedAttach	\N	\N
275	\N	/OutgoingLetterAction.do?dispatch=retFromAttach	\N	\N
276	\N	/OutgoingLetterAction.do?dispatch=back	\N	\N
277	\N	/DefferedUploadFileAction.do?dispatch=back	\N	\N
278	\N	/OrderAction.do?dispatch=reloadOrdDateConfAll	\N	\N
279	\N	/OrderAction.do?dispatch=reloadOrdReadyForDelivDateAll	\N	\N
280	\N	/ShippingDocTypesListAction.do	\N	\N
281	\N	/MarginAction.do?dispatch=formirExcel	\N	\N
282	\N	/ProduceCostAction.do?dispatch=input	\N	\N
283	\N	/ProduceCostAction.do?dispatch=back	\N	\N
284	\N	/ProducesCostAction.do?dispatch=restore	\N	\N
285	\N	/RoutesListAction.do	\N	\N
286	\N	/ProduceCostAction.do?dispatch=selectFromDocs	\N	\N
287	\N	/ProduceCostPositionsAction.do?dispatch=input	\N	\N
288	\N	/ProduceCostPositionsAction.do?dispatch=add	\N	\N
289	\N	/ProduceCostPositionsAction.do?dispatch=save	\N	\N
290	\N	/ProduceCostAction.do?dispatch=backFromSelect	\N	\N
291	\N	/ProduceCostAction.do?dispatch=reload	\N	\N
292	\N	/ProduceCostAction.do?dispatch=process	\N	\N
293	\N	/PaySummAction.do?dispatch=back	\N	\N
294	\N	/ContractAction.do?dispatch=input	\N	\N
295	\N	/ContractAction.do?dispatch=newSpecification	\N	\N
296	\N	/SpecificationAction.do?dispatch=insert	\N	\N
297	\N	/DeliveryTermTypesListAction.do	\N	\N
298	\N	/SpecificationAction.do?dispatch=reload	\N	\N
299	\N	/SpecificationAction.do?dispatch=beforeSave	\N	\N
300	\N	/ContractAction.do?dispatch=defferedAttach	\N	\N
301	\N	/ContractAction.do?dispatch=process	\N	\N
302	\N	/ContractAttacmentsListAction.do	\N	\N
303	\N	/SpecificationAction.do?dispatch=defferedAttachCopy	\N	\N
304	\N	/SpecificationImportAction.do?dispatch=selectDocsForSpecImport	\N	\N
305	\N	/SpecificationImportPositionsAction.do?dispatch=input	\N	\N
306	\N	/SpecificationImportPositionsAction.do?dispatch=save	\N	\N
307	\N	/SpecificationImportAction.do?dispatch=backFromSelect	\N	\N
308	\N	/SpecificationImportPositionsAction.do?dispatch=add	\N	\N
309	\N	/SpecificationAction.do?dispatch=downloadAttachment	\N	\N
310	\N	/ShippingAction.do?dispatch=input	\N	\N
311	\N	/ShippingAction.do?dispatch=editShippingPositions	\N	\N
312	\N	/ShippingPositionsAction.do?dispatch=input	\N	\N
313	\N	/ShippingPositionsAction.do?dispatch=save	\N	\N
314	\N	/ShippingAction.do?dispatch=back_from_edit_position	\N	\N
315	\N	/ShippingAction.do?dispatch=beforeSave	\N	\N
316	\N	/PaymentsAction.do?dispatch=filter	\N	\N
317	\N	/OrderProduceAction.do?dispatch=selectProduce	\N	\N
318	\N	/OrderProduceSelectNomenclatureAction.do?dispatch=input	\N	\N
319	\N	/OrderProduceSelectNomenclatureAction.do?dispatch=select	\N	\N
320	\N	/OrderProduceAction.do?dispatch=returnFromSelectNomenclature	\N	\N
321	\N	/SpecificationImportsAction.do?dispatch=setSentDate	\N	\N
322	\N	/OrderAction.do?dispatch=cloneProduce	\N	\N
323	\N	/OrderProduceAction.do?dispatch=clone	\N	\N
324	\N	/NomenclatureProduceAction.do?dispatch=copy	\N	\N
325	\N	/NomenclatureProduceAction.do?dispatch=deleteAttachment	\N	\N
326	\N	/Menu.do?current_menu_id=id.goods_rest_lithuania	\N	\N
327	\N	/GoodsRestLithuaniaAction.do?dispatch=show	\N	\N
328	\N	/GoodsRestLithuaniaAction.do?dispatch=download	\N	\N
329	\N	/NomenclatureProduceAction.do?dispatch=attach	\N	\N
330	\N	/PaymentAction.do?dispatch=deletePaySum	\N	\N
331	\N	/PaymentAction.do?dispatch=reloadContractor	\N	\N
332	\N	/ContractorAction.do?dispatch=addPersonInContractor	\N	\N
333	\N	/ContactPersonAction.do?dispatch=createFromContractor	\N	\N
334	\N	/ContactPersonAction.do?dispatch=process	\N	\N
335	\N	/ContractorAction.do?dispatch=fromContactPerson	\N	\N
336	\N	/OrderAction.do?dispatch=deleteProduce	\N	\N
337	\N	/PrepareAppToShutdown.do	\N	\N
338	\N	/Menu.do?current_menu_id=id.sessions	\N	\N
339	\N	/Sessions.do	\N	\N
340	\N	/NomenclatureProduceAction.do?dispatch=ajaxAddRowInCNGrid	\N	\N
341	\N	/SpecificationImportAction.do?dispatch=input	\N	\N
342	\N	/DeliveryRequestAction.do?dispatch=reloadWithClean	\N	\N
343	\N	/DeliveryRequestAction.do?dispatch=newProduce	\N	\N
344	\N	/DeliveryRequestProduceAction.do?dispatch=insert	\N	\N
345	\N	/DeliveryRequestProduceAction.do?dispatch=selectProduce	\N	\N
346	\N	/DeliveryRequestProduceSelectNomenclatureAction.do?dispatch=input	\N	\N
347	\N	/OrderAction.do?dispatch=newProduce	\N	\N
348	\N	/OrderProduceAction.do?dispatch=insert	\N	\N
349	\N	/DeliveryRequestProduceSelectNomenclatureAction.do?dispatch=select	\N	\N
350	\N	/DeliveryRequestProduceAction.do?dispatch=returnFromSelectNomenclature	\N	\N
351	\N	/trusted/NoPermission.do	\N	\N
352	\N	/OrderAction.do?dispatch=produce_movement	\N	\N
353	\N	/ProduceMovementForOrderAction.do?dispatch=input	\N	\N
354	\N	/ProduceMovementForOrderAction.do?dispatch=back	\N	\N
355	\N	/OrderAction.do?dispatch=fromProduceMovement	\N	\N
356	\N	/ProduceMovementForOrderAction.do?dispatch=reload	\N	\N
357	\N	/OrderAction.do?dispatch=selectCP	\N	\N
358	\N	/SelectKPOrderAction.do?dispatch=input	\N	\N
359	\N	/SelectKPOrderAction.do?dispatch=select	\N	\N
360	\N	/OrderAction.do?dispatch=returnFromSelectCP	\N	\N
361	\N	/ConditionForContractAction.do?dispatch=newContactPersonSign	\N	\N
362	\N	/ContactPersonAddActionConditionForContract.do?dispatch=input	\N	\N
363	\N	/ContactPersonAddActionConditionForContract.do?dispatch=process	\N	\N
364	\N	/ConditionForContractAction.do?dispatch=retFromContractor	\N	\N
365	\N	/CalcStateReportTypesListAction.do	\N	\N
366	\N	/SpecificationImportAction.do?dispatch=reload	\N	\N
367	\N	/SpecificationImportAction.do?dispatch=recalcCostByPrice	\N	\N
368	\N	/Menu.do?current_menu_id=id.out_delivery_request	\N	\N
369	\N	/DeliveryRequestAction.do?dispatch=back	\N	\N
370	\N	/DeliveryRequestsAction.do?dispatch=filter	\N	\N
371	\N	/DeliveryRequestPositionsAction.do?dispatch=filter	\N	\N
372	\N	/Menu.do?current_menu_id=id.roles	\N	\N
373	\N	/RolesAction.do	\N	\N
374	\N	/Menu.do?current_menu_id=id.users	\N	\N
375	\N	/UsersAction.do?dispatch=execute	\N	\N
376	\N	/UserRolesAction.do?dispatch=show	\N	\N
377	\N	/Menu.do?current_menu_id=id.departments	\N	\N
378	\N	/DepartmentsAction.do	\N	\N
379	\N	/Menu.do?current_menu_id=id.routes	\N	\N
380	\N	/RoutesAction.do?dispatch=execute	\N	\N
381	\N	/Menu.do?current_menu_id=id.sellers	\N	\N
382	\N	/SellersAction.do?dispatch=execute	\N	\N
383	\N	/Menu.do?current_menu_id=id.blanks	\N	\N
384	\N	/BlanksAction.do?dispatch=execute	\N	\N
385	\N	/CalculationStateAction.do?dispatch=formirExcel	\N	\N
386	\N	/Menu.do?current_menu_id=id.settings	\N	\N
387	\N	/SettingsAction.do	\N	\N
388	\N	/Menu.do?current_menu_id=id.rep_shipping	\N	\N
389	\N	/ShippingReportAction.do?dispatch=input	\N	\N
390	\N	/Menu.do?current_menu_id=id.actions	\N	\N
391	\N	/ActionsAction.do	\N	\N
392	\N	/ShippingReportAction.do?dispatch=formir	\N	\N
393	\N	/ActionAction.do?dispatch=edit	\N	\N
394	\N	/Menu.do?current_menu_id=id.log	\N	\N
395	\N	/LogsAction.do?dispatch=input	\N	\N
396	\N	/ShippingReportAction.do?dispatch=cleanAll	\N	\N
397	\N	/OrderAction.do?dispatch=reloadBlank	\N	\N
398	\N	/Menu.do?current_menu_id=id.assemble	\N	\N
399	\N	/AssemblesAction.do?dispatch=input	\N	\N
400	\N	/AssembleAction.do?dispatch=edit	\N	\N
401	\N	/AssembleAction.do?dispatch=back	\N	\N
402	\N	/AssemblesAction.do?dispatch=restore	\N	\N
403	\N	/ProduceCostAction.do?dispatch=edit	\N	\N
404	\N	/ShippingPositionsAction.do?dispatch=changeRoute	\N	\N
405	\N	/ShippingPositionsAction.do?dispatch=add	\N	\N
406	\N	/PaymentAction.do?dispatch=input	\N	\N
407	\N	/Menu.do?current_menu_id=id.cclosed	\N	\N
408	\N	/ContractsClosedAction.do?dispatch=input	\N	\N
409	\N	/ContractsClosedAction.do?dispatch=create	\N	\N
410	\N	/ContractClosedAction.do?dispatch=input	\N	\N
411	\N	/ContractClosedAction.do?dispatch=edit_closed_record	\N	\N
412	\N	/ClosedRecordAction.do?dispatch=edit	\N	\N
413	\N	/ClosedRecordAction.do?dispatch=delete_selected	\N	\N
414	\N	/ClosedRecordAction.do?dispatch=process	\N	\N
415	\N	/ContractClosedAction.do?dispatch=ret_closed_record	\N	\N
416	\N	/ContractClosedAction.do?dispatch=back	\N	\N
417	\N	/ContractsClosedAction.do?dispatch=restore	\N	\N
418	\N	/ContractorRequestAction.do?dispatch=input	\N	\N
419	\N	/ContractorRequestAction.do?dispatch=reload	\N	\N
420	\N	/OutgoingLetterAction.do?dispatch=downloadAttachment	\N	\N
421	\N	/NomenclatureProduceAction.do?dispatch=downloadAttachment	\N	\N
422	\N	/CustomCodeAction.do?dispatch=edit	\N	\N
423	\N	/Menu.do?current_menu_id=id.stuff_categories	\N	\N
424	\N	/StuffCategoriesAction.do?dispatch=show	\N	\N
425	\N	/Menu.do?current_menu_id=id.montage_adjustment	\N	\N
426	\N	/MontageAdjustmentsAction.do?dispatch=input	\N	\N
427	\N	/MontageAdjustmentsAction.do?dispatch=show	\N	\N
428	\N	/Menu.do?current_menu_id=id.units	\N	\N
429	\N	/UnitsAction.do	\N	\N
430	\N	/Menu.do?current_menu_id=id.purposes	\N	\N
431	\N	/PurposesAction.do	\N	\N
432	\N	/Menu.do?current_menu_id=id.doc_types_shipping	\N	\N
433	\N	/ShippingDocTypesAction.do	\N	\N
434	\N	/ShippingDocTypeAction.do?dispatch=edit	\N	\N
435	\N	/Menu.do?current_menu_id=id.ratesNDS	\N	\N
436	\N	/RatesNDSAction.do	\N	\N
437	\N	/Menu.do?current_menu_id=id.countries	\N	\N
438	\N	/CountriesAction.do	\N	\N
439	\N	/CountryAction.do?dispatch=edit	\N	\N
440	\N	/CalculationStateAction.do?dispatch=formirGrid	\N	\N
441	\N	/CalculationStateAction.do?dispatch=showGrid	\N	\N
442	\N	/Menu.do?current_menu_id=id.goods_circulation	\N	\N
443	\N	/GoodsCirculationAction.do?dispatch=input	\N	\N
444	\N	/SpecificationActionCalculationState.do?dispatch=beforeSave	\N	\N
445	\N	/ContractActionCalculationState.do?dispatch=process	\N	\N
446	\N	/Menu.do?current_menu_id=id.unexecuted_orders	\N	\N
447	\N	/OrdersUnexecutedAction.do?dispatch=input	\N	\N
448	\N	/OrdersUnexecutedAction.do?dispatch=formir	\N	\N
449	\N	/Menu.do?current_menu_id=id.logistics_order	\N	\N
450	\N	/OrdersLogisticsAction.do?dispatch=input	\N	\N
451	\N	/OrdersLogisticsAction.do?dispatch=formir	\N	\N
452	\N	/GoodsCirculationAction.do?dispatch=formir	\N	\N
453	\N	/ContractorAction.do?dispatch=addRowInUserGrid	\N	\N
454	\N	/NomenclatureAction.do?dispatch=importProduces	\N	\N
455	\N	/NomenclatureProducesImportAction.do?dispatch=input	\N	\N
456	\N	/NomenclatureProducesImportAction.do?dispatch=process	\N	\N
457	\N	/NomenclatureAction.do?dispatch=moveProduces	\N	\N
458	\N	/OrderAction.do?dispatch=deleteAttachment	\N	\N
459	\N	/GoodsRestAction.do?dispatch=cleanAll	\N	\N
460	\N	/NomenclatureAction.do?dispatch=setNotCheckDouble	\N	\N
461	\N	/SpecificationAction.do?dispatch=defferedAttach	\N	\N
462	\N	/SpecificationAction.do?dispatch=backFromAttach	\N	\N
463	\N	/SpecificationAction.do?dispatch=process	\N	\N
464	\N	/NomenclatureAction.do?dispatch=createNomenclatureProduce	\N	\N
465	\N	/NomenclatureProduceAction.do?dispatch=input	\N	\N
466	\N	/SpecificationImportAction.do?dispatch=recalc_prices	\N	\N
467	\N	/CalculationStateAction.do?dispatch=cleanAll	\N	\N
468	\N	/SpecificationAction.do?dispatch=reloadPrices	\N	\N
469	\N	/CommercialProposalAction.do?dispatch=newContactPerson	\N	\N
470	\N	/ContactPersonAddAction.do?dispatch=input	\N	\N
471	\N	/CustomCodeFastCreateAction.do?dispatch=create	\N	\N
472	\N	/CustomCodeFastCreateAction.do?dispatch=process	\N	\N
473	\N	/CustomCodesAction.do?dispatch=process	\N	\N
474	\N	/CommercialProposalImportAction.do?dispatch=process	\N	\N
475	\N	/ContactPersonAddAction.do?dispatch=process	\N	\N
476	\N	/NomenclatureProduceAction.do?dispatch=save	\N	\N
477	\N	/CalculationStateAction.do?dispatch=shipping	\N	\N
478	\N	/ShippingActionCalculationState.do?dispatch=edit	\N	\N
479	\N	/ShippingActionCalculationState.do?dispatch=beforeSave	\N	\N
480	\N	/CalculationStateAction.do?dispatch=back_to_calc_state_from_shipping	\N	\N
481	\N	/ContractorAction.do?dispatch=editPersonInContractor	\N	\N
482	\N	/ContactPersonAction.do?dispatch=editInContractor	\N	\N
483	\N	/SpecificationImportAction.do?dispatch=deleteProduce	\N	\N
484	\N	/DeliveryRequestAction.do?dispatch=print	\N	\N
485	\N	/DeliveryRequestPrintAction.do	\N	\N
486	\N	/CustomCodeAction.do?dispatch=process	\N	\N
487	\N	/DeliveryRequestPositionsAction.do?dispatch=delete	\N	\N
488	\N	/ControlCommentAction.do?dispatch=insertControlComment	\N	\N
489	\N	/ShippingsAction.do?dispatch=block	\N	\N
490	\N	/ShippingAction.do?dispatch=ajaxAddToGrid	\N	\N
491	\N	/ShippingAction.do?dispatch=ajaxRemoveFromGrid	\N	\N
492	\N	/ContractorRequestAction.do?dispatch=printReclamationAct	\N	\N
493	\N	/SpecificationActionCalculationState.do?dispatch=process	\N	\N
494	\N	/OrderAction.do?dispatch=input	\N	\N
495	\N	/OrderAction.do?dispatch=reloadInOneSpec	\N	\N
496	\N	/ConditionForContractAction.do?dispatch=newProduce	\N	\N
497	\N	/ConditionForContractProduceAction.do?dispatch=insert	\N	\N
498	\N	/ConditionForContractProduceAction.do?dispatch=back	\N	\N
499	\N	/SpecificationImportsAction.do?dispatch=filter	\N	\N
500	\N	/SpecificationImportsAction.do?dispatch=block	\N	\N
501	\N	/TimeboardAction.do?dispatch=input	\N	\N
502	\N	/TimeboardAction.do?dispatch=newWork	\N	\N
503	\N	/TimeboardWorkAction.do?dispatch=insert	\N	\N
504	\N	/TimeboardWorkAction.do?dispatch=process	\N	\N
505	\N	/TimeboardAction.do?dispatch=retFromWorkOperation	\N	\N
506	\N	/TimeboardAction.do?dispatch=process	\N	\N
507	\N	/ShippingActionCalculationState.do?dispatch=back	\N	\N
508	\N	/ShippingAction.do?dispatch=reload	\N	\N
509	\N	/OrderAction.do?dispatch=newContactPerson	\N	\N
510	\N	/ContactPersonAddActionOrder.do?dispatch=input	\N	\N
511	\N	/ContactPersonAddActionOrder.do?dispatch=process	\N	\N
512	\N	/OrderAction.do?dispatch=retFromContractor	\N	\N
513	\N	/OrderAction.do?dispatch=reloadContactPerson	\N	\N
514	\N	/SpecificationAction.do?dispatch=deleteAttachment	\N	\N
515	\N	/ProducesCostAction.do?dispatch=filter	\N	\N
516	\N	/ShippingPositionsAction.do?dispatch=filter	\N	\N
517	\N	/ShippingAction.do?dispatch=process	\N	\N
518	\N	/DeliveryRequestAction.do?dispatch=reload	\N	\N
519	\N	/ShippingAction.do?dispatch=makeMine	\N	\N
520	\N	/ConditionForContractAction.do?dispatch=editContractor	\N	\N
521	\N	/ContractorEditActionConditionForContract.do?dispatch=edit	\N	\N
522	\N	/ContractorEditActionConditionForContract.do?dispatch=process	\N	\N
523	\N	/ConditionForContractAction.do?dispatch=editContactPersonSign	\N	\N
524	\N	/ContactPersonEditActionConditionForContract.do?dispatch=edit	\N	\N
525	\N	/ContactPersonEditActionConditionForContract.do?dispatch=process	\N	\N
526	\N	/ProducesCostAction.do?dispatch=block	\N	\N
527	\N	/OrdersAction.do?dispatch=block	\N	\N
528	\N	/ContractorRequestAction.do?dispatch=printGSAct	\N	\N
529	\N	/StuffCategoryAction.do?dispatch=input	\N	\N
530	\N	/StuffCategoryAction.do?dispatch=process	\N	\N
531	\N	/ContractorAction.do?dispatch=create	\N	\N
532	\N	/NomenclatureAction.do?dispatch=addCategory	\N	\N
533	\N	/NomenclatureAction.do?dispatch=deleteCategory	\N	\N
534	\N	/OutgoingLetterAction.do?dispatch=show	\N	\N
535	\N	/ContractorRequestAction.do?dispatch=printLinteraRequest	\N	\N
536	\N	/SpecificationActionCalculationState.do?dispatch=deleteAttachment	\N	\N
537	\N	/SpecificationActionCalculationState.do?dispatch=defferedAttach	\N	\N
538	\N	/SpecificationActionCalculationState.do?dispatch=backFromAttach	\N	\N
539	\N	/CommercialProposalAction.do?dispatch=reloadWithClean	\N	\N
540	\N	/EquipmentListAction.do	\N	\N
541	\N	/ContractorRequestAction.do?dispatch=printLinteraAgreement	\N	\N
542	\N	/ContractorRequestAction.do?dispatch=process	\N	\N
543	\N	/ShippingPositionsAction.do?dispatch=clear	\N	\N
544	\N	/ProduceCostAction.do?dispatch=editProduce	\N	\N
545	\N	/ProduceCostProduceAction.do?dispatch=edit	\N	\N
546	\N	/ProduceCostProduceAction.do?dispatch=back	\N	\N
547	\N	/ProduceCostAction.do?dispatch=retFromProduceOperation	\N	\N
548	\N	/ContractAction.do?dispatch=deleteAttachment	\N	\N
549	\N	/MarginAction.do?dispatch=cleanAll	\N	\N
550	\N	/OrderProduceAction.do?dispatch=back	\N	\N
551	\N	/CustomCodeAction.do?dispatch=create	\N	\N
552	\N	/SpecificationActionCalculationState.do?dispatch=defferedAttachCopy	\N	\N
553	\N	/Menu.do?current_menu_id=id.prdCostReport	\N	\N
554	\N	/ProduceCostReportAction.do?dispatch=input	\N	\N
555	\N	/TimeboardAction.do?dispatch=editWork	\N	\N
556	\N	/TimeboardWorkAction.do?dispatch=edit	\N	\N
557	\N	/TimeboardAction.do?dispatch=selectContractorRequest	\N	\N
558	\N	/SelectContractorRequestTimeboardAction.do?dispatch=input	\N	\N
559	\N	/ContractorRequestsAction.do?dispatch=inputFromTimeboard	\N	\N
560	\N	/SelectContractorRequestTimeboardAction.do?dispatch=select	\N	\N
561	\N	/TimeboardAction.do?dispatch=retSelectContractorRequest	\N	\N
562	\N	/ClosedRecordAction.do?dispatch=back	\N	\N
563	\N	/ContractClosedAction.do?dispatch=delete_closed_record	\N	\N
564	\N	/ContractClosedAction.do?dispatch=process	\N	\N
565	\N	/GoodsRestLithuaniaUploadFileAction.do?dispatch=input	\N	\N
566	\N	/GoodsRestLithuaniaUploadFileAction.do?dispatch=process	\N	\N
567	\N	/ContractActionCalculationState.do?dispatch=defferedAttach	\N	\N
568	\N	/SpecificationActionCalculationState.do?dispatch=reloadPrices	\N	\N
569	\N	/ProduceCostPositionsAction.do?dispatch=filter	\N	\N
570	\N	/ProduceCostPositionsAction.do?dispatch=clear	\N	\N
571	\N	/ProduceCostAction.do?dispatch=newProduce	\N	\N
572	\N	/ProduceCostProduceAction.do?dispatch=insert	\N	\N
573	\N	/ProduceCostProduceAction.do?dispatch=selectProduce	\N	\N
574	\N	/ProduceCostProduceSelectNomenclatureAction.do?dispatch=input	\N	\N
575	\N	/ProduceCostProduceSelectNomenclatureAction.do?dispatch=select	\N	\N
576	\N	/ProduceCostProduceAction.do?dispatch=returnFromSelectNomenclature	\N	\N
577	\N	/ProduceCostProduceAction.do?dispatch=process	\N	\N
578	\N	/ContractorRequestAction.do?dispatch=printLetterRequest	\N	\N
579	\N	/ContractorRequestPrintLetterRequestAction.do	\N	\N
580	\N	/MontageAdjustmentListAction.do	\N	\N
581	\N	/OutgoingLettersAction.do?dispatch=filter	\N	\N
582	\N	/ShowPrevResponse.do?dispatch=clone	\N	\N
583	\N	/ContractorRequestAction.do?dispatch=newContactPerson	\N	\N
584	\N	/ContactPersonAddActionContractorRequest.do?dispatch=input	\N	\N
585	\N	/ContactPersonAddActionContractorRequest.do?dispatch=process	\N	\N
586	\N	/ContractorRequestAction.do?dispatch=retFromContractor	\N	\N
587	\N	/ContractorRequestAction.do?dispatch=clone	\N	\N
588	\N	/DeliveryRequestAction.do?dispatch=deleteProduce	\N	\N
589	\N	/UnitsListAction.do	\N	\N
590	\N	/OrderAction.do?dispatch=reloadCalculate	\N	\N
591	\N	/OrderAction.do?dispatch=reloadIncludeNDS	\N	\N
592	\N	/NomenclatureProduceAction.do?dispatch=ajaxDeleteRowFromCNGrid	\N	\N
593	\N	/ContractorsForContractsClosedListAction.do	\N	\N
594	\N	/ContractsClosedAction.do?dispatch=reload	\N	\N
595	\N	/ContractClosedAction.do?dispatch=edit	\N	\N
596	\N	/OrderAction.do?dispatch=changeViewNumber	\N	\N
597	\N	/NomenctlatureAttachmentsAction.do	\N	\N
598	\N	/AttachmentsAction.do?dispatch=show	\N	\N
599	\N	/StuffCategoryAction.do?dispatch=edit	\N	\N
600	\N	/ReputationsListAction.do	\N	\N
601	\N	/CommercialProposalAction.do?dispatch=formirExcel	\N	\N
602	\N	/ContractorAction.do?dispatch=addCountry	\N	\N
603	\N	/AddCountryAction.do?dispatch=create	\N	\N
604	\N	/AddCountryAction.do?dispatch=process	\N	\N
605	\N	/ContractorAction.do?dispatch=fromAddCountry	\N	\N
606	\N	/ContractActionCalculationState.do?dispatch=deleteAttachment	\N	\N
607	\N	/DeliveryRequestPositionsAction.do?dispatch=clear	\N	\N
608	\N	/AssembleAction.do?dispatch=input	\N	\N
609	\N	/AssembleAction.do?dispatch=reloadWithClean	\N	\N
610	\N	/AssembleAction.do?dispatch=reloadWithCleanProduce	\N	\N
611	\N	/AssembleAction.do?dispatch=selectProduce	\N	\N
612	\N	/AssembleSelectNomenclatureAction.do?dispatch=input	\N	\N
613	\N	/AssembleSelectNomenclatureAction.do?dispatch=select	\N	\N
614	\N	/AssembleAction.do?dispatch=returnFromSelectNomenclature	\N	\N
615	\N	/AssembleAction.do?dispatch=selectFromOrder	\N	\N
616	\N	/AssemblePositionsAction.do?dispatch=input	\N	\N
617	\N	/AssemblePositionsAction.do?dispatch=save	\N	\N
618	\N	/AssembleAction.do?dispatch=backFromSelect	\N	\N
619	\N	/ContractorRequestAction.do?dispatch=saveComment	\N	\N
620	\N	/ContractorRequestAction.do?dispatch=printPNPAct	\N	\N
621	\N	/ContractorRequestAction.do?dispatch=show	\N	\N
622	\N	/ShippingReportAction.do?dispatch=formirExcel	\N	\N
623	\N	/ProduceCostPositionsAction.do?dispatch=delete	\N	\N
624	\N	/AttachmentsAction.do?dispatch=back	\N	\N
625	\N	/SpecificationImportPositionsAction.do?dispatch=delete	\N	\N
626	\N	/ContractAction.do?dispatch=show	\N	\N
627	\N	/OutgoingLetterAction.do?dispatch=newContactPerson	\N	\N
628	\N	/ContactPersonAddActionOutgoingLetter.do?dispatch=input	\N	\N
629	\N	/ContactPersonAddActionOutgoingLetter.do?dispatch=process	\N	\N
630	\N	/TimeboardAction.do?dispatch=cloneWork	\N	\N
631	\N	/TimeboardWorkAction.do?dispatch=clone	\N	\N
632	\N	/TimeboardAction.do?dispatch=deleteWork	\N	\N
633	\N	/CommercialProposalsAction.do?dispatch=block	\N	\N
634	\N	/NomenclatureAction.do?dispatch=mergeProduces	\N	\N
635	\N	/NomenclatureProducesMergeAction.do?dispatch=merge	\N	\N
636	\N	/NomenclatureProducesMergeAction.do?dispatch=process	\N	\N
637	\N	/ContractActionCalculationState.do?dispatch=newSpecification	\N	\N
638	\N	/SpecificationActionCalculationState.do?dispatch=insert	\N	\N
639	\N	/SpecificationActionCalculationState.do?dispatch=reload	\N	\N
640	\N	/ShippingAction.do?dispatch=show	\N	\N
641	\N	/ContractorsAction.do?dispatch=mergeContractors	\N	\N
642	\N	/MergeContractorsAction.do?dispatch=merge	\N	\N
643	\N	/MergeContractorsAction.do?dispatch=process	\N	\N
644	\N	/ContractorRequestAction.do?dispatch=reloadProvider	\N	\N
645	\N	/DeliveryRequestsAction.do?dispatch=block	\N	\N
646	\N	/UserAction.do?dispatch=edit	\N	\N
647	\N	/UserAction.do?dispatch=process	\N	\N
648	\N	/ContractorRequestAction.do?dispatch=defferedAttach	\N	\N
649	\N	/ContractorRequestAction.do?dispatch=retFromAttach	\N	\N
650	\N	/ConditionForContractAction.do?dispatch=deleteProduce	\N	\N
651	\N	/InstructionAction.do?dispatch=input	\N	\N
652	\N	/InstructionTypesListAction.do	\N	\N
653	\N	/InstructionAction.do?dispatch=defferedAttach	\N	\N
654	\N	/InstructionAction.do?dispatch=retFromAttach	\N	\N
655	\N	/InstructionAction.do?dispatch=process	\N	\N
656	\N	/ConditionForContractAction.do?dispatch=editContactPerson	\N	\N
657	\N	/InstructionsAction.do?dispatch=filter	\N	\N
658	\N	/CurrencyAction.do?dispatch=edit	\N	\N
659	\N	/DeliveryConditionListAction.do	\N	\N
660	\N	/ControlCommentAction.do?dispatch=saveControlComment	\N	\N
661	\N	/ConditionForContractAction.do?dispatch=cloneProduce	\N	\N
662	\N	/ConditionForContractProduceAction.do?dispatch=clone	\N	\N
663	\N	/ConditionForContractAction.do?dispatch=show	\N	\N
664	\N	/UserAction.do?dispatch=create	\N	\N
665	\N	/UserRolesAction.do?dispatch=add	\N	\N
666	\N	/CommercialProposalAction.do?dispatch=reloadAccept	\N	\N
667	\N	/OrdersStatisticsAction.do?dispatch=formirExcel	\N	\N
668	\N	/OrderAction.do?dispatch=show	\N	\N
669	\N	/ContractorAction.do?dispatch=addRowInAccountGrid	\N	\N
670	\N	/InstructionAction.do?dispatch=deleteAttachment	\N	\N
671	\N	/OrderProduceAction.do?dispatch=force_process	\N	\N
672	\N	/PaymentAction.do?dispatch=editPaySum	\N	\N
673	\N	/PaySummAction.do?dispatch=edit	\N	\N
674	\N	/ShowPrevResponse.do?dispatch=editContactPersons	\N	\N
675	\N	/ProduceCostAction.do?dispatch=editCustom	\N	\N
676	\N	/ProduceCostCustomAction.do?dispatch=edit	\N	\N
677	\N	/ProduceCostCustomAction.do?dispatch=process	\N	\N
678	\N	/MontageAdjustmentAction.do?dispatch=edit	\N	\N
679	\N	/ComplexityCategoryListAction.do	\N	\N
680	\N	/MontageAdjustmentAction.do?dispatch=process	\N	\N
681	\N	/OrderAction.do?dispatch=reloadImport	\N	\N
682	\N	/OrderAction.do?dispatch=importExcel	\N	\N
683	\N	/OrderImportAction.do?dispatch=input	\N	\N
684	\N	/OrderImportAction.do?dispatch=back	\N	\N
685	\N	/ShippingPositionsAction.do?dispatch=delete	\N	\N
686	\N	/GoodsRestAction.do?dispatch=saveComment	\N	\N
687	\N	/StuffCategoriesAction.do?dispatch=showInMontage	\N	\N
688	\N	/StuffCategoriesAction.do?dispatch=delete	\N	\N
689	\N	/MontageAdjustmentAction.do?dispatch=input	\N	\N
690	\N	/MontageAdjustmentsHistoryAction.do?dispatch=show	\N	\N
691	\N	/OrdersLogisticsAction.do?dispatch=formirExcel	\N	\N
692	\N	/OrderImportAction.do?dispatch=process	\N	\N
693	\N	/ContractorEditActionConditionForContract.do?dispatch=addRowInAccountGrid	\N	\N
694	\N	/CustomCodeHistoryAction.do	\N	\N
695	\N	/CustomCodeFromHistoryAction.do?dispatch=edit	\N	\N
696	\N	/ContractorAction.do?dispatch=deleteRowFromAccountGrid	\N	\N
697	\N	/OrderAction.do?dispatch=newContractor	\N	\N
698	\N	/ContractorAddActionOrder.do?dispatch=create	\N	\N
699	\N	/ContractorAddActionOrder.do?dispatch=process	\N	\N
700	\N	/ContractsClosedAction.do?dispatch=filter	\N	\N
701	\N	/ContractClosedAction.do?dispatch=process_block	\N	\N
702	\N	/GoodsCirculationAction.do?dispatch=formirExcel	\N	\N
703	\N	/ContractorAddActionCommercialProposal.do?dispatch=addPersonInContractor	\N	\N
704	\N	/PersonActionAddCommercialProposal.do?dispatch=createFromContractor	\N	\N
705	\N	/PersonActionAddCommercialProposal.do?dispatch=process	\N	\N
706	\N	/ContractorAddActionCommercialProposal.do?dispatch=fromContactPerson	\N	\N
707	\N	/SpecificationAction.do?dispatch=ajaxSpecificationPaymentsGrid	\N	\N
708	\N	/SpecificationAction.do?dispatch=ajaxAddToGrid	\N	\N
709	\N	/SpecificationAction.do?dispatch=ajaxReloadDate	\N	\N
710	\N	/SpecificationAction.do?dispatch=ajaxRecalcGrid	\N	\N
711	\N	/SpecificationAction.do?dispatch=ajaxRemoveFromGrid	\N	\N
712	\N	/SpecificationAction.do?dispatch=ajaxReloadPrices	\N	\N
713	\N	/ContractorAddActionCommercialProposal.do?dispatch=editPersonInContractor	\N	\N
714	\N	/PersonActionAddCommercialProposal.do?dispatch=editInContractor	\N	\N
715	\N	/ContractorRequestAction.do?dispatch=selectProduce	\N	\N
716	\N	/ContractorRequestSelectNomenclatureAction.do?dispatch=input	\N	\N
717	\N	/ContractorRequestSelectNomenclatureAction.do?dispatch=select	\N	\N
718	\N	/ContractorRequestAction.do?dispatch=retFromProduceOperation	\N	\N
719	\N	/ContractsClosedAction.do?dispatch=delete	\N	\N
720	\N	/ConditionForContractAction.do?dispatch=importExcel	\N	\N
721	\N	/ConditionForContractImportAction.do?dispatch=input	\N	\N
722	\N	/ConditionForContractImportAction.do?dispatch=process	\N	\N
723	\N	/InstructionAction.do?dispatch=show	\N	\N
724	\N	/ContractorRequestAction.do?dispatch=deleteAttachment	\N	\N
725	\N	/ContractAction.do?dispatch=delete	\N	\N
726	\N	/ShippingActionCalculationState.do?dispatch=reload	\N	\N
727	\N	/ShippingActionCalculationState.do?dispatch=editShippingPositions	\N	\N
728	\N	/ShippingPositionsActionCalculationState.do?dispatch=input	\N	\N
729	\N	/ShippingPositionsActionCalculationState.do?dispatch=changeRoute	\N	\N
730	\N	/ShippingPositionsActionCalculationState.do?dispatch=filter	\N	\N
731	\N	/ShippingPositionsActionCalculationState.do?dispatch=add	\N	\N
732	\N	/ShippingPositionsActionCalculationState.do?dispatch=save	\N	\N
733	\N	/ShippingActionCalculationState.do?dispatch=back_from_edit_position	\N	\N
734	\N	/ShippingActionCalculationState.do?dispatch=process	\N	\N
735	\N	/ConditionForContractAction.do?dispatch=deleteAttachment	\N	\N
736	\N	/SpecificationAction.do?dispatch=ajaxReloadReminder	\N	\N
737	\N	/ConditionForContractAction.do?dispatch=newContractor	\N	\N
738	\N	/ContractorAddActionConditionForContract.do?dispatch=create	\N	\N
739	\N	/ContractorAddActionConditionForContract.do?dispatch=addCountry	\N	\N
740	\N	/AddCountryActionAddConditionForContract.do?dispatch=create	\N	\N
741	\N	/AddCountryActionAddConditionForContract.do?dispatch=process	\N	\N
742	\N	/ContractorRequestAction.do?dispatch=ajaxContractorRequestPrintGrid	\N	\N
743	\N	/ContractorRequestAction.do?dispatch=ajaxAddToGrid	\N	\N
744	\N	/ContractorRequestAction.do?dispatch=ajaxRemoveFromGrid	\N	\N
745	\N	/ConditionForContractImportAction.do?dispatch=back	\N	\N
746	\N	/OrderTypesListAction.do	\N	\N
747	\N	/ShowPrevResponse.do?dispatch=markExecute	\N	\N
748	\N	/ProduceCostAction.do?dispatch=deleteProduce	\N	\N
749	\N	/ShippingPositionsActionCalculationState.do?dispatch=clear	\N	\N
750	\N	/ContractorAddActionCommercialProposal.do?dispatch=blockContactPerson	\N	\N
751	\N	/ContractAction.do?dispatch=deleteSpecification	\N	\N
752	\N	/ContractorEditActionConditionForContract.do?dispatch=addRowInUserGrid	\N	\N
753	\N	/OrdersStatisticsAction.do?dispatch=cleanAll	\N	\N
754	\N	/RoleAction.do?dispatch=edit	\N	\N
755	\N	/UsersAction.do?dispatch=block	\N	\N
756	\N	/OrderProduceAction.do?dispatch=newReadyForShipping	\N	\N
757	\N	/OrderProduceAction.do?dispatch=newProductTerm	\N	\N
758	\N	/ContractorEditActionConditionForContract.do?dispatch=addPersonInContractor	\N	\N
759	\N	/PersonActionEditActionConditionForContract.do?dispatch=createFromContractor	\N	\N
760	\N	/PersonActionEditActionConditionForContract.do?dispatch=process	\N	\N
761	\N	/ContractorEditActionConditionForContract.do?dispatch=fromContactPerson	\N	\N
762	\N	/NomenclatureAction.do?dispatch=changeCategory	\N	\N
763	\N	/ContractorRequestAction.do?dispatch=ajaxChangeRequestTypeId	\N	\N
764	\N	/ContractClosedAction.do?dispatch=processBlock	\N	\N
765	\N	/ContractorRequestsAction.do?dispatch=deliver	\N	\N
766	\N	/ShowPrevResponse.do?dispatch=block	\N	\N
767	\N	/ConditionForContractAction.do?dispatch=newContactPerson	\N	\N
768	\N	/RateNDSAction.do?dispatch=input	\N	\N
769	\N	/SpecificationImportAction.do?dispatch=recalcPriceByCustomPercent	\N	\N
770	\N	/LogsAction.do?dispatch=filter	\N	\N
771	\N	/ContractorAddActionOrder.do?dispatch=addPersonInContractor	\N	\N
772	\N	/PersonActionAddActionOrder.do?dispatch=createFromContractor	\N	\N
773	\N	/PersonActionAddActionOrder.do?dispatch=process	\N	\N
774	\N	/ContractorAddActionOrder.do?dispatch=fromContactPerson	\N	\N
775	\N	/ContractorAddActionOrder.do?dispatch=addCountry	\N	\N
776	\N	/AddCountryActionAddOrder.do?dispatch=create	\N	\N
777	\N	/AddCountryActionAddOrder.do?dispatch=process	\N	\N
778	\N	/ContractorAddActionOrder.do?dispatch=fromAddCountry	\N	\N
779	\N	/ProduceCostAction.do?dispatch=show	\N	\N
780	\N	/ContractorEditActionConditionForContract.do?dispatch=editPersonInContractor	\N	\N
781	\N	/PersonActionEditActionConditionForContract.do?dispatch=editInContractor	\N	\N
782	\N	/SpecificationImportAction.do?dispatch=show	\N	\N
783	\N	/AssemblesAction.do?dispatch=filter	\N	\N
784	\N	/OutgoingLetterAction.do?dispatch=deleteAttachment	\N	\N
785	\N	/ProduceCostReportAction.do?dispatch=formir	\N	\N
786	\N	/ProduceCostReportAction.do?dispatch=formirExcel	\N	\N
787	\N	/PaySummAction.do?dispatch=input	\N	\N
788	\N	/ContractAction.do?dispatch=newContractor	\N	\N
789	\N	/ContractorAddActionContract.do?dispatch=create	\N	\N
790	\N	/ContractAction.do?dispatch=retFromContractor	\N	\N
791	\N	/GoodsRestLithuaniaUploadFileAction.do?dispatch=back	\N	\N
792	\N	/OrderAction.do?dispatch=new_contractor_for	\N	\N
793	\N	/ContractorEditActionConditionForContract.do?dispatch=deleteRowFromUserGrid	\N	\N
794	\N	/CalculationStateAction.do?dispatch=editContractor	\N	\N
795	\N	/ContractorEditActionCalculationState.do?dispatch=edit	\N	\N
796	\N	/CalculationStateAction.do?dispatch=retFromContractor	\N	\N
797	\N	/ContractorEditActionConditionForContract.do?dispatch=deleteRowFromAccountGrid	\N	\N
798	\N	/ContractorAddActionConditionForContract.do?dispatch=addPersonInContractor	\N	\N
799	\N	/PersonActionAddActionConditionForContract.do?dispatch=createFromContractor	\N	\N
800	\N	/PersonActionAddActionConditionForContract.do?dispatch=process	\N	\N
801	\N	/ContractorAddActionConditionForContract.do?dispatch=fromContactPerson	\N	\N
802	\N	/ContractorAddActionConditionForContract.do?dispatch=process	\N	\N
803	\N	/ContractorEditActionCalculationState.do?dispatch=process	\N	\N
804	\N	/ShippingAction.do?dispatch=print_notice	\N	\N
805	\N	/NoticeForShippingPrintAction.do	\N	\N
806	\N	/BlanksAction.do?dispatch=printExample	\N	\N
807	\N	/BlankAction.do?dispatch=edit	\N	\N
808	\N	/HeadImgsListAction.do	\N	\N
809	\N	/BlankTypesListAction.do	\N	\N
810	\N	/TimeboardsAction.do?dispatch=filter	\N	\N
811	\N	/AssemblePositionsAction.do?dispatch=add	\N	\N
812	\N	/AssembleAction.do?dispatch=process	\N	\N
813	\N	/AssembleAction.do?dispatch=deleteProduce	\N	\N
814	\N	/ClosedRecordAction.do?dispatch=input	\N	\N
815	\N	/PurposeAction.do?dispatch=edit	\N	\N
816	\N	/PurposeAction.do?dispatch=process	\N	\N
817	\N	/PurposesAction.do?dispatch=process	\N	\N
818	\N	/TimeboardAction.do?dispatch=show	\N	\N
819	\N	/ShippingDocTypeAction.do?dispatch=input	\N	\N
820	\N	/ShippingDocTypeAction.do?dispatch=process	\N	\N
821	\N	/ShippingDocTypesAction.do?dispatch=process	\N	\N
822	\N	/OrderProduceAction.do?dispatch=deleteProductTerm	\N	\N
823	\N	/GoodsRestLithuaniaAction.do?dispatch=delete	\N	\N
824	\N	/FixAttachments.do	\N	\N
825	\N	/UploadFileAction.do?dispatch=input	\N	\N
826	\N	/UploadFileAction.do?dispatch=back	\N	\N
827	\N	/ContractorRequestAction.do?dispatch=reloadNoContract	\N	\N
828	\N	/GoodsRestAction.do?dispatch=saveDepartment	\N	\N
829	\N	/ActionsListAction.do	\N	\N
830	\N	/ActionAction.do?dispatch=process	\N	\N
831	\N	/ActionsAction.do?dispatch=process	\N	\N
832	\N	/ContractAction.do?dispatch=attach	\N	\N
833	\N	/SpecificationAction.do?dispatch=attach	\N	\N
834	\N	/DefferedAttachmentsAction.do?dispatch=init	\N	\N
835	\N	/DefferedAttachmentsAction.do?dispatch=download	\N	\N
836	\N	/DefferedAttachmentsAction.do?dispatch=back	\N	\N
837	\N	/CommercialProposalAction.do?dispatch=ajaxProducesCommercialProposalGrid	\N	\N
838	\N	/CommercialProposalAction.do?dispatch=ajaxChangeNDSByString	\N	\N
839	\N	/CommercialProposalAction.do?dispatch=ajaxRecalcCommercialProposalGrid	\N	\N
840	\N	/CommercialProposalsAction.do?dispatch=checkPrice	\N	\N
841	\N	/ContactPersonsListAction.do	\N	\N
842	\N	/CommercialProposalAction.do?dispatch=ajaxChangeCurrency	\N	\N
843	\N	/CommercialProposalAction.do?dispatch=ajaxChangeCourse	\N	\N
844	\N	/ConditionForContractAction.do?dispatch=processForce	\N	\N
845	\N	/CommercialProposalAction.do?dispatch=ajaxProducesForAssembleMinskGrid	\N	\N
846	\N	/ProducesForAssembleMinskAction.do?dispatch=input	\N	\N
847	\N	/ProducesForAssembleMinskAction.do?dispatch=save	\N	\N
848	\N	/CommercialProposalAction.do?dispatch=backFromSelect	\N	\N
849	\N	/ProducesForAssembleMinskAction.do?dispatch=filter	\N	\N
850	\N	/ProducesForAssembleMinskAction.do?dispatch=add	\N	\N
851	\N	/CommercialProposalAction.do?dispatch=ajaxChangeSalePriceForAssembleMinskGrid	\N	\N
852	\N	/CommercialProposalAction.do?dispatch=ajaxRecalcForAssembleMinskGrid	\N	\N
853	\N	/CommercialProposalAction.do?dispatch=ajaxGetTotal	\N	\N
854	\N	/CommercialProposalAction.do?dispatch=printContract	\N	\N
855	\N	/CommercialProposalAction.do?dispatch=ajaxChangeReverseCalc	\N	\N
856	\N	/ContractorsAction.do?dispatch=block	\N	\N
857	\N	/CommercialProposalAction.do?dispatch=ajaxChangeNDS	\N	\N
858	\N	/ShippingAction.do?dispatch=backFromEditPosition	\N	\N
859	\N	/ContractClosedAction.do?dispatch=deleteClosedRecord	\N	\N
860	\N	/ContractClosedAction.do?dispatch=editClosedRecord	\N	\N
861	\N	/SettingAction.do?dispatch=edit	\N	\N
862	\N	/SettingAction.do?dispatch=process	\N	\N
863	\N	/SettingsAction.do?dispatch=process	\N	\N
864	\N	/ContractorAction.do?dispatch=blockContactPerson	\N	\N
865	\N	/SelectCPOrderAction.do?dispatch=input	\N	\N
866	\N	/SelectCPOrderAction.do?dispatch=select	\N	\N
867	\N	/ConditionForContractAction.do?dispatch=clone	\N	\N
868	\N	/ContractorRequestAction.do?dispatch=ajaxChangeCrqSeller	\N	\N
869	\N	/ProducesForAssembleMinskAction.do?dispatch=clear	\N	\N
870	\N	/AttachmentsAction.do?dispatch=delete	\N	\N
871	\N	/UploadFileAction.do?dispatch=process	\N	\N
872	\N	/trusted/NoPermission.do?dispatch=input	\N	\N
873	\N	/trusted/NoPermission.do?dispatch=ajaxProducesCommercialProposalGrid	\N	\N
874	\N	/CommercialProposalAction.do?dispatch=editPurchasePurposes	\N	\N
875	\N	/PurchasePurposesActionCommercialProposal.do?dispatch=execute	\N	\N
876	\N	/ProducesForAssembleMinskAction.do?dispatch=ajaxReservedInfoGrid	\N	\N
877	\N	/ProducesForAssembleMinskAction.do?dispatch=delete	\N	\N
878	\N	/ProduceMovementForGoodsRestAction.do?dispatch=reload	\N	\N
879	\N	/PurchasePurposesActionCommercialProposal.do?dispatch=edit	\N	\N
880	\N	/PurchasePurposeActionCommercialProposal.do?dispatch=edit	\N	\N
881	\N	/PurchasePurposeActionCommercialProposal.do?dispatch=process	\N	\N
882	\N	/NomenclatureAction.do?dispatch=downloadDoubleValues	\N	\N
883	\N	/ContractsClosedAction.do?dispatch=blockSelected	\N	\N
884	\N	/UserRolesAction.do?dispatch=delete	\N	\N
885	\N	/ContractsClosedAction.do?dispatch=edit	\N	\N
886	\N	/Menu.do?current_menu_id=id.lithuania_goods_rest	\N	\N
887	\N	/Menu.do?current_menu_id=id._minsk_goods_rest	\N	\N
888	\N	/OrderAction.do?dispatch=newContractorFor	\N	\N
889	\N	/ContractActionCalculationState.do?dispatch=deleteSpecification	\N	\N
890	\N	/PaymentAction.do?dispatch=ajaxPaymentSumsGrid	\N	\N
891	\N	/PaymentAction.do?dispatch=ajaxChangeAccount	\N	\N
892	\N	/PaymentAction.do?dispatch=ajaxChangeContractor	\N	\N
893	\N	/PaymentAction.do?dispatch=ajaxChangeSum	\N	\N
894	\N	/PaySummAction.do?dispatch=ajaxChangeSpecification	\N	\N
895	\N	/ShippingAction.do?dispatch=ajaxShippingsGrid	\N	\N
896	\N	/ShippingAction.do?dispatch=ajaxChangeSerialNumYearOut	\N	\N
897	\N	/PaymentAction.do?dispatch=ajaxChangeCourse	\N	\N
898	\N	/ShippingAction.do?dispatch=ajaxChangeSpecification	\N	\N
899	\N	/ShippingAction.do?dispatch=ajaxMakeMine	\N	\N
900	\N	/PaymentAction.do?dispatch=show	\N	\N
901	\N	/ContractorAddActionOutgoingLetter.do?dispatch=addCountry	\N	\N
902	\N	/AddCountryActionAddOutgoingLetter.do?dispatch=create	\N	\N
903	\N	/AddCountryActionAddOutgoingLetter.do?dispatch=process	\N	\N
904	\N	/ContractorAddActionOutgoingLetter.do?dispatch=fromAddCountry	\N	\N
905	\N	/ContractorRequestAction.do?dispatch=newContractor	\N	\N
906	\N	/ContractorAddActionContractorRequest.do?dispatch=create	\N	\N
907	\N	/ContractorAddActionContractorRequest.do?dispatch=process	\N	\N
908	\N	/ShippingAction.do?dispatch=ajaxChangeMontage	\N	\N
909	\N	/AssemblePositionsAction.do?dispatch=delete	\N	\N
910	\N	/ShowPrevResponse.do?dispatch=checkPrice	\N	\N
911	\N	/NomenclatureProducesImportAction.do?dispatch=back	\N	\N
912	\N	/UnitAction.do?dispatch=edit	\N	\N
913	\N	/UnitAction.do?dispatch=process	\N	\N
914	\N	/UnitsAction.do?dispatch=process	\N	\N
915	\N	/OrderAction.do?dispatch=ajaxCheckSave	\N	\N
916	\N	/OrderProduceAction.do?dispatch=forceProcess	\N	\N
917	\N	/DeliveryRequestAction.do?dispatch=ajaxCheckSaveError	\N	\N
918	\N	/DeliveryRequestAction.do?dispatch=ajaxCheckSave	\N	\N
919	\N	/PurposeAction.do?dispatch=input	\N	\N
920	\N	/ShippingActionCalculationState.do?dispatch=backFromEditPosition	\N	\N
921	\N	/OrderAction.do?dispatch=printLetter	\N	\N
922	\N	/ShippingActionCalculationState.do?dispatch=printNotice	\N	\N
923	\N	/ShippingAction.do?dispatch=printNotice	\N	\N
924	\N	/ConditionForContractAction.do?dispatch=ajaxChangeContract	\N	\N
925	\N	/CommercialProposalAction.do?dispatch=ajaxChangePurchasePurpose	\N	\N
926	\N	/ContractorAction.do?dispatch=fireContactPerson	\N	\N
927	\N	/ContractorAddActionOrder.do?dispatch=editPersonInContractor	\N	\N
928	\N	/PersonActionAddActionOrder.do?dispatch=editInContractor	\N	\N
929	\N	/CurrencyRateAction.do?dispatch=input	\N	\N
930	\N	/BlankAction.do?dispatch=process	\N	\N
931	\N	/ContractorAddActionOutgoingLetter.do?dispatch=deleteRowFromUserGrid	\N	\N
932	\N	/ContractorAddActionOutgoingLetter.do?dispatch=addPersonInContractor	\N	\N
933	\N	/PersonActionAddActionOutgoingLetter.do?dispatch=createFromContractor	\N	\N
934	\N	/PersonActionAddActionOutgoingLetter.do?dispatch=process	\N	\N
935	\N	/ContractorAddActionOutgoingLetter.do?dispatch=fromContactPerson	\N	\N
936	\N	/CountryAction.do?dispatch=create	\N	\N
937	\N	/CountryAction.do?dispatch=process	\N	\N
938	\N	/CountriesAction.do?dispatch=process	\N	\N
939	\N	/ContractsClosedAction.do?dispatch=unblock	\N	\N
940	\N	/OrderAction.do?dispatch=reloadDeleteAllRows	\N	\N
941	\N	/ContractsClosedAction.do?dispatch=reloadContract	\N	\N
942	\N	/ContractorAddActionConditionForContract.do?dispatch=fireContactPerson	\N	\N
943	\N	/ContractorAddActionConditionForContract.do?dispatch=editPersonInContractor	\N	\N
944	\N	/PersonActionAddActionConditionForContract.do?dispatch=editInContractor	\N	\N
945	\N	/AddCountryActionAddCommercialProposal.do?dispatch=process	\N	\N
946	\N	/MontageAdjustmentHistoryAction.do?dispatch=input	\N	\N
947	\N	/MontageAdjustmentHistoryAction.do?dispatch=process	\N	\N
948	\N	/MontageAdjustmentHistoryAction.do?dispatch=edit	\N	\N
949	\N	/DeliveryRequestAction.do?dispatch=show	\N	\N
950	\N	/CustomCodeFromHistoryAction.do?dispatch=create	\N	\N
951	\N	/CustomCodeFromHistoryAction.do?dispatch=process	\N	\N
952	\N	/CustomCodeHistoryAction.do?dispatch=process	\N	\N
953	\N	/PaymentAction.do?dispatch=newContractor	\N	\N
954	\N	/ContractorAddActionPayment.do?dispatch=create	\N	\N
955	\N	/PaymentAction.do?dispatch=retFromContractor	\N	\N
956	\N	/ContractorAction.do?dispatch=delete	\N	\N
957	\N	/OrderAction.do?dispatch=ajaxOrderPaymentsGrid	\N	\N
958	\N	/OrderAction.do?dispatch=ajaxOrderPaySumsGrid	\N	\N
959	\N	/OrderAction.do?dispatch=ajaxRecalcPaymentGrid	\N	\N
960	\N	/SpecificationAction.do?dispatch=ajaxRecalcPaymentGrid	\N	\N
961	\N	/OrderAction.do?dispatch=ajaxAddToPaymentGrid	\N	\N
962	\N	/SpecificationAction.do?dispatch=ajaxAddToPaymentGrid	\N	\N
963	\N	/OrderAction.do?dispatch=ajaxRecalcPaySumGrid	\N	\N
964	\N	/ClosedRecordAction.do?dispatch=deleteSelected	\N	\N
965	\N	/OrderAction.do?dispatch=ajaxRemoveFromPaymentGrid	\N	\N
966	\N	/OrderAction.do?dispatch=ajaxAddToPaySumGrid	\N	\N
967	\N	/OrderAction.do?dispatch=ajaxRemoveFromPaySumsGrid	\N	\N
968	\N	/SpecificationAction.do?dispatch=ajaxRemoveFromPaymentGrid	\N	\N
969	\N	/CountriesAction.do?dispatch=show	\N	\N
970	\N	/CountriesAction.do?dispatch=mergeCountries	\N	\N
971	\N	/ContractsAction.do?dispatch=selectCP	\N	\N
972	\N	/SelectCPContractsAction.do?dispatch=input	\N	\N
973	\N	/SelectCPContractsAction.do?dispatch=select	\N	\N
974	\N	/ContractAction.do?dispatch=importCP	\N	\N
975	\N	/ContractorAddActionCommercialProposal.do?dispatch=addRowInAccountGrid	\N	\N
976	\N	/ContractorAddActionCommercialProposal.do?dispatch=deleteRowFromAccountGrid	\N	\N
977	\N	/CustomCodesAction.do?dispatch=execute	\N	\N
978	\N	/CustomCodesAction.do?dispatch=checkLaw240	\N	\N
979	\N	/CalculationStateAction.do?dispatch=backToCalcStateFromContract	\N	\N
980	\N	/ContractorAction.do?dispatch=editReputation	\N	\N
981	\N	/ReputationsAction.do?dispatch=execute	\N	\N
982	\N	/ReputationAction.do?dispatch=input	\N	\N
983	\N	/NumbersListAction.do	\N	\N
984	\N	/ReputationAction.do?dispatch=process	\N	\N
985	\N	/ContractorAction.do?dispatch=fromEditReputation	\N	\N
986	\N	/ContractorAddActionCommercialProposal.do?dispatch=fireContactPerson	\N	\N
987	\N	/ContractClosedAction.do?dispatch=retClosedRecord	\N	\N
988	\N	/PaymentAction.do?dispatch=ajaxChangeCourseNBRB	\N	\N
989	\N	/CommercialProposalAction.do?dispatch=ajaxChangeFreePrices	\N	\N
990	\N	/OrderProduceAction.do?dispatch=deleteReadyForShipping	\N	\N
991	\N	/BlankAction.do?dispatch=create	\N	\N
992	\N	/BlankAction.do?dispatch=reload	\N	\N
993	\N	/ContractorEditActionConditionForContract.do?dispatch=fireContactPerson	\N	\N
994	\N	/Menu.do?current_menu_id=id.personalOffice	\N	\N
995	\N	/PersonalOfficeAction.do?dispatch=input	\N	\N
996	\N	/Menu.do?current_menu_id=id.office	\N	\N
997	\N	/OfficeAction.do?dispatch=input	\N	\N
998	\N	/OfficeAction.do?dispatch=ajaxPaymentMessagesGrid	\N	\N
999	\N	/Menu.do?current_menu_id=id.personalSettings	\N	\N
1000	\N	/UserSettingsAction.do?dispatch=input	\N	\N
1001	\N	/UserSettingAction.do?dispatch=edit	\N	\N
1002	\N	/UserSettingsAction.do	\N	\N
1003	\N	/UserSettingAction.do?dispatch=process	\N	\N
1004	\N	/UserSettingsAction.do?dispatch=process	\N	\N
1005	\N	/ConditionForContractAction.do?dispatch=reloadSeller	\N	\N
1006	\N	/OfficeAction.do?dispatch=ajaxRemovePaymentMessages	\N	\N
1007	\N	/Menu.do?current_menu_id=id.filesPaths	\N	\N
1008	\N	/FilesPathsAction.do	\N	\N
1009	\N	/FilesPathAction.do?dispatch=edit	\N	\N
1010	\N	/FilesPathAction.do?dispatch=process	\N	\N
1011	\N	/FilesPathsAction.do?dispatch=process	\N	\N
1012	\N	/UserAction.do?dispatch=defferedAttach	\N	\N
1013	\N	/UserAction.do?dispatch=retFromAttach	\N	\N
1014	\N	/UserAction.do?dispatch=back	\N	\N
1015	\N	/ContractorsAction.do?dispatch=formirExcel	\N	\N
1016	\N	/ShowPrevResponse.do?dispatch=editPersonInContractor	\N	\N
1017	\N	/ContactPersonAddAction.do?dispatch=create	\N	\N
1018	\N	/ContactPersonAddActionOutgoingLetter.do?dispatch=create	\N	\N
1019	\N	/ContactPersonAddActionOrder.do?dispatch=create	\N	\N
1020	\N	/ContactPersonAddActionConditionForContract.do?dispatch=create	\N	\N
1021	\N	/AssembleAction.do?dispatch=show	\N	\N
1022	\N	/CurrencyRateAction.do?dispatch=process	\N	\N
1023	\N	/CurrencyRateAction.do?dispatch=receiveFromBank	\N	\N
1024	\N	/ContactPersonEditActionConditionForContract.do?dispatch=addRowInUserGrid	\N	\N
1025	\N	/CurrencyRateAction.do?dispatch=edit	\N	\N
1026	\N	/CurrenciesAction.do?dispatch=postReceiveFromBankCourses	\N	\N
1027	\N	/ContractorAddActionPayment.do?dispatch=process	\N	\N
1028	\N	/ContactPersonAction.do?dispatch=addRowInUserGrid	\N	\N
1029	\N	/ContactPersonAddActionContractorRequest.do?dispatch=create	\N	\N
1030	\N	/ShippingAction.do?dispatch=newContractor	\N	\N
1031	\N	/ContractorAddActionShipping.do?dispatch=create	\N	\N
1032	\N	/ShippingAction.do?dispatch=retFromContractor	\N	\N
1033	\N	/UserAction.do?dispatch=downloadAttachment	\N	\N
1034	\N	/ProduceCostCustomAction.do?dispatch=back	\N	\N
1035	\N	/DeliveryRequestAction.do?dispatch=delete	\N	\N
1036	\N	/ContractClosedAction.do?dispatch=show	\N	\N
1037	\N	/ShippingPositionsActionCalculationState.do?dispatch=delete	\N	\N
1038	\N	/ContractorEditActionConditionForContract.do?dispatch=addCountry	\N	\N
1039	\N	/AddCountryActionEditConditionForContract.do?dispatch=create	\N	\N
1040	\N	/ContractorEditActionConditionForContract.do?dispatch=fromAddCountry	\N	\N
1041	\N	/ContractorEditActionCalculationState.do?dispatch=addRowInUserGrid	\N	\N
1042	\N	/ContractorEditActionCalculationState.do?dispatch=deleteRowFromUserGrid	\N	\N
1043	\N	/ContractorEditActionCalculationState.do?dispatch=addRowInAccountGrid	\N	\N
1044	\N	/ContractorsAction.do?dispatch=print	\N	\N
1045	\N	/ContractorsPrintAction.do	\N	\N
1046	\N	/OfficeAction.do?dispatch=ajaxMessagesGrid	\N	\N
1047	\N	/OfficeAction.do?dispatch=ajaxRemoveMessages	\N	\N
1048	\N	/OrderAction.do?dispatch=reloadDontCalculate	\N	\N
1049	\N	/SelectKPConditionForContractAction.do?dispatch=select?dispatch=filter	\N	\N
1050	\N	/CommercialProposalAction.do?dispatch=ajaxChangeCalculate	\N	\N
1051	\N	/PurchasePurposeActionCommercialProposal.do?dispatch=input	\N	\N
1052	\N	/CustomCodesAction.do?dispatch=block	\N	\N
1053	\N	/NomenclatureAction.do?dispatch=uploadTemplate	\N	\N
1054	\N	/UploadFileTemplateNomenclatureAction.do?dispatch=input	\N	\N
1055	\N	/UploadFileTemplateNomenclatureAction.do?dispatch=back	\N	\N
1056	\N	/PaymentAction.do?dispatch=ajaxUpdateCourses	\N	\N
1057	\N	/StuffCategoriesAction.do?dispatch=mergeStuffCategories	\N	\N
1058	\N	/OrderAction.do?dispatch=editExecuted	\N	\N
1059	\N	/OrderExecutedProducesAction.do?dispatch=edit	\N	\N
1060	\N	/OrderExecutedProducesAction.do?dispatch=ajaxOrderExecutedProducesGrid	\N	\N
1061	\N	/OrderExecutedProducesAction.do?dispatch=back	\N	\N
1062	\N	/OrderExecutedProducesAction.do?dispatch=ajaxNewExecutedDateChanged	\N	\N
1063	\N	/OrderExecutedProducesAction.do?dispatch=ajaxChangeValue	\N	\N
1064	\N	/OrderExecutedProducesAction.do?dispatch=process	\N	\N
1065	\N	/ContractorAction.do?dispatch=deleteRowFromUserGrid	\N	\N
1066	\N	/CommercialProposalAction.do?dispatch=ajaxRemoveFromCommercialProposalGrid	\N	\N
1067	\N	/CommercialProposalAction.do?dispatch=ajaxDeleteAllProducesCommercialProposalGrid	\N	\N
1068	\N	/CommercialProposalAction.do?dispatch=ajaxRemoveFromProducesForAssembleMinskGrid	\N	\N
1069	\N	/UsersAction.do?dispatch=filter	\N	\N
1070	\N	/ContractorEditActionCalculationState.do?dispatch=fireContactPerson	\N	\N
1071	\N	/CommercialProposalAction.do?dispatch=ajaxDeleteAllProducesForAssembleMinskGrid	\N	\N
1072	\N	/SpecificationAction.do?dispatch=ajaxCalculateDeliveryDate	\N	\N
1073	\N	/OrdersLogisticsAction.do?dispatch=cleanAll	\N	\N
1074	\N	/CalculationStateAction.do?dispatch=payment	\N	\N
1075	\N	/PaymentActionCalculationState.do?dispatch=edit	\N	\N
1076	\N	/PaymentActionCalculationState.do?dispatch=back	\N	\N
1077	\N	/PaymentActionCalculationState.do?dispatch=process	\N	\N
1078	\N	/OrderExecutedProducesAction.do?dispatch=ajaxDeleteColumn	\N	\N
1079	\N	/PaymentActionCalculationState.do?dispatch=newPaySum	\N	\N
1080	\N	/PaySummActionCalculationState.do?dispatch=insert	\N	\N
1081	\N	/PaySummActionCalculationState.do?dispatch=process	\N	\N
1082	\N	/PaymentActionCalculationState.do?dispatch=retFromPaySumOperation	\N	\N
1083	\N	/PaySummActionCalculationState.do?dispatch=back	\N	\N
1084	\N	/CalculationStateAction.do?dispatch=backToCalcStateFromPayment	\N	\N
1085	\N	/CalculationStateAction.do?dispatch=backToCalcStateFromShipping	\N	\N
1086	\N	/trusted/NoPermission.do?dispatch=ajaxPaymentSumsGrid	\N	\N
1087	\N	/trusted/NoPermission.do?dispatch=ajaxChangeCourse	\N	\N
1088	\N	/OfficeAction.do?dispatch=ajaxEconomistMessages	\N	\N
1089	\N	/Menu.do?current_menu_id=id.woodwork_work_files	\N	\N
1090	\N	/WoodworkWorkFilesAction.do?dispatch=show	\N	\N
1091	\N	/WoodworkWorkFilesUploadFileAction.do?dispatch=input	\N	\N
1092	\N	/WoodworkWorkFilesUploadFileAction.do?dispatch=process	\N	\N
1093	\N	/WoodworkWorkFilesAction.do?dispatch=download	\N	\N
1094	\N	/OfficeAction.do?dispatch=ajaxSetCorrectMenuId	\N	\N
1095	\N	/ContractClosedAction.do?dispatch=deleteSelected	\N	\N
1096	\N	/GoodsCirculationAction.do?dispatch=cleanAll	\N	\N
1097	\N	/ContractorRequestAction.do?dispatch=ajaxLinkedOrdersGrid	\N	\N
1098	\N	/ContractorRequestAction.do?dispatch=selectOrder	\N	\N
1099	\N	/SelectOrderContractorRequestAction.do?dispatch=input	\N	\N
1100	\N	/SelectOrderContractorRequestAction.do?dispatch=select	\N	\N
1101	\N	/ContractorRequestAction.do?dispatch=returnFromSelectOrder	\N	\N
1102	\N	/ProduceCostAction.do?dispatch=importExcel	\N	\N
1103	\N	/ProduceCostImportAction.do?dispatch=input	\N	\N
1104	\N	/ProduceCostImportAction.do?dispatch=back	\N	\N
1105	\N	/ProduceCostImportAction.do?dispatch=process	\N	\N
1106	\N	/Menu.do?current_menu_id=id.current_works	\N	\N
1107	\N	/CurrentWorksAction.do?dispatch=input	\N	\N
1108	\N	/CurrentWorksAction.do?dispatch=filter	\N	\N
1109	\N	/ContractorRequestAction.do?dispatch=ajaxRemoveFromOrderGrid	\N	\N
1110	\N	/ConditionForContractAction.do?dispatch=uploadTemplate	\N	\N
1111	\N	/UploadFileTemplateCFCAction.do?dispatch=input	\N	\N
1112	\N	/UploadFileTemplateCFCAction.do?dispatch=process	\N	\N
1113	\N	/ContractorEditActionCalculationState.do?dispatch=editPersonInContractor	\N	\N
1114	\N	/PersonActionEditActionCalculationState.do?dispatch=editInContractor	\N	\N
1115	\N	/ContractorEditActionCalculationState.do?dispatch=fromContactPerson	\N	\N
1116	\N	/ContractorEditActionCalculationState.do?dispatch=deleteRowFromAccountGrid	\N	\N
1117	\N	/CurrencyAction.do?dispatch=input	\N	\N
1118	\N	/OrderAction.do?dispatch=produceMovement	\N	\N
1119	\N	/GoodsCirculationAction.do?dispatch=filter	\N	\N
1120	\N	/SellerAction.do?dispatch=edit	\N	\N
1121	\N	/SellerAction.do?dispatch=process	\N	\N
1122	\N	/Menu.do?current_menu_id=id.languages	\N	\N
1123	\N	/LanguagesAction.do	\N	\N
1124	\N	/SellerAction.do?dispatch=input	\N	\N
1125	\N	/UsersAction.do?dispatch=clearFilter	\N	\N
1126	\N	/LanguagesListAction.do	\N	\N
1127	\N	/RoleAction.do?dispatch=input	\N	\N
1128	\N	/ContractActionCalculationState.do?dispatch=attach	\N	\N
1129	\N	/SpecificationActionCalculationState.do?dispatch=attach	\N	\N
1130	\N	/DepartmentAction.do?dispatch=input	\N	\N
1131	\N	/DepartmentAction.do?dispatch=process	\N	\N
1132	\N	/DepartmentsAction.do?dispatch=process	\N	\N
1133	\N	/Number1CHistoryAction.do?dispatch=show	\N	\N
1134	\N	/MontageAdjustmentsAction.do?dispatch=filter	\N	\N
1135	\N	/CountryAction.do?dispatch=delete	\N	\N
1136	\N	/ContractorRequestAction.do?dispatch=printPNPTimeSheet	\N	\N
1137	\N	/LogsAction.do?dispatch=formirExcel	\N	\N
1138	\N	/Number1CFromHistoryAction.do?dispatch=edit	\N	\N
1139	\N	/RouteAction.do?dispatch=input	\N	\N
1140	\N	/RouteAction.do?dispatch=process	\N	\N
1141	\N	/RouteAction.do?dispatch=edit	\N	\N
1142	\N	/MultipleFileUpload.do?dispatch=input	\N	\N
1143	\N	/MultipleFileUpload.do?dispatch=save	\N	\N
1144	\N	/MultipleFileUpload.do?dispatch=back	\N	\N
1145	\N	/ContractorAddActionOrder.do?dispatch=fireContactPerson	\N	\N
1146	\N	/CommercialProposalAction.do?dispatch=defferedAttach	\N	\N
1147	\N	/CommercialProposalAction.do?dispatch=retFromAttach	\N	\N
1148	\N	/DepartmentAction.do?dispatch=edit	\N	\N
1149	\N	/CommercialProposalAction.do?dispatch=downloadAttachment	\N	\N
1150	\N	/WoodworkWorkFilesAction.do?dispatch=delete	\N	\N
1151	\N	/CommercialProposalAction.do?dispatch=deleteAttachment	\N	\N
1152	\N	/CommercialProposalsAction.do?dispatch=formirExcel	\N	\N
1153	\N	/ContractorEditActionCalculationState.do?dispatch=editReputation	\N	\N
1154	\N	/ReputationsActionEditCalculationState.do?dispatch=execute	\N	\N
1155	\N	/ReputationActionEditCalculationState.do?dispatch=input	\N	\N
1156	\N	/ContractorEditActionCalculationState.do?dispatch=fromEditReputation	\N	\N
1157	\N	/Number1CFromHistoryAction.do?dispatch=save	\N	\N
1158	\N	/Number1CFromHistoryAction.do?dispatch=create	\N	\N
1159	\N	/OrdersAction.do?dispatch=reload	\N	\N
1160	\N	/UnitAction.do?dispatch=create	\N	\N
1161	\N	/ContractorEditActionCalculationState.do?dispatch=addPersonInContractor	\N	\N
1162	\N	/PersonActionEditActionCalculationState.do?dispatch=createFromContractor	\N	\N
1163	\N	/PersonActionEditActionCalculationState.do?dispatch=process	\N	\N
1164	\N	/CurrencyAction.do?dispatch=process	\N	\N
1165	\N	/NomenclatureProduceCustomCodeHistoryAction.do?dispatch=show	\N	\N
1166	\N	/NomenclatureProduceCustomCodeFromHistoryAction.do?dispatch=show	\N	\N
1167	\N	/NomenclatureProduceCustomCodeFromHistoryAction.do?dispatch=save	\N	\N
1168	\N	/NomenclatureProduceCustomCodeFromHistoryAction.do?dispatch=edit	\N	\N
1169	\N	/WoodworkWorkFilesUploadFileAction.do?dispatch=back	\N	\N
1170	\N	/ReputationsActionEditCalculationState.do?dispatch=edit	\N	\N
1171	\N	/ReputationActionEditCalculationState.do?dispatch=edit	\N	\N
1172	\N	/ReputationActionEditCalculationState.do?dispatch=process	\N	\N
1173	\N	/ContractorAddActionShipping.do?dispatch=process	\N	\N
1174	\N	/DefferedAttachmentsAction.do?dispatch=show	\N	\N
1175	\N	/DefferedAttachmentsAction.do?dispatch=delete	\N	\N
1176	\N	/ReputationsAction.do?dispatch=edit	\N	\N
1177	\N	/ReputationAction.do?dispatch=edit	\N	\N
1178	\N	/OrderAction.do?dispatch=ajaxRecalculatePaymentGrid	\N	\N
1179	\N	/SpecificationImportsAction.do?dispatch=ajaxGetLaterDates	\N	\N
1180	\N	/OrderAction.do?dispatch=deferredAttach	\N	\N
1181	\N	/SpecificationAction.do?dispatch=ajaxRecalculatePaymentGrid	\N	\N
1182	\N	/SpecificationImportsAction.do?dispatch=ajaxSetSentDate	\N	\N
1183	\N	/ContractAction.do?dispatch=deferredAttach	\N	\N
1184	\N	/ContractorRequestAction.do?dispatch=deferredAttach	\N	\N
1185	\N	/GoodsRestAction.do?dispatch=generate	\N	\N
1186	\N	/SpecificationAction.do?dispatch=deferredAttach	\N	\N
1187	\N	/CommercialProposalAction.do?dispatch=deferredAttach	\N	\N
1188	\N	/SpecificationAction.do?dispatch=deferredAttachCopy	\N	\N
1189	\N	/OutgoingLetterAction.do?dispatch=deferredAttach	\N	\N
1190	\N	/InstructionAction.do?dispatch=deferredAttach	\N	\N
1191	\N	/ShowPrevResponse.do?dispatch=fireContactPerson	\N	\N
1192	\N	/CalculationStateAction.do?dispatch=generate	\N	\N
1193	\N	/MarginAction.do?dispatch=generate	\N	\N
1194	\N	/ShippingAction.do?dispatch=ajaxCheckBeforeSave	\N	\N
1195	\N	/ShippingAction.do?dispatch=ajaxManagersGrid	\N	\N
1196	\N	/GoodsCirculationAction.do?dispatch=generate	\N	\N
1197	\N	/ContractClosedAction.do?dispatch=ajaxClosedContractRecordsGrid	\N	\N
1198	\N	/ProduceMovementForGoodsCirculationAction.do?dispatch=input	\N	\N
1199	\N	/ProduceMovementForGoodsCirculationAction.do?dispatch=back	\N	\N
1200	\N	/GoodsCirculationAction.do?dispatch=fromProduceMovement	\N	\N
1201	\N	/ShippingReportAction.do?dispatch=generate	\N	\N
1202	\N	/MarginAction.do?dispatch=generateExcel	\N	\N
1203	\N	/CommercialProposalAction.do?dispatch=generateExcel	\N	\N
1204	\N	/CalculationStateAction.do?dispatch=generateExcel	\N	\N
1205	\N	/OrdersLogisticsAction.do?dispatch=generate	\N	\N
1206	\N	/OrdersLogisticsAction.do?dispatch=generateExcel	\N	\N
1207	\N	/SpecificationImportAction.do?dispatch=generateExcel	\N	\N
1208	\N	/CalculationStateAction.do?dispatch=generateGrid	\N	\N
1209	\N	/ContractClosedAction.do?dispatch=ajaxChangeContractClosedDate	\N	\N
1210	\N	/ContractClosedAction.do?dispatch=ajaxDeleteSelected	\N	\N
1211	\N	/ContractClosedAction.do?dispatch=ajaxDeleteClosedRecord	\N	\N
1212	\N	/ShippingReportAction.do?dispatch=generateExcel	\N	\N
1213	\N	/OrdersStatisticsAction.do?dispatch=generate	\N	\N
1214	\N	/OrdersStatisticsAction.do?dispatch=generateExcel	\N	\N
1215	\N	/GoodsRestAction.do?dispatch=generateExcel	\N	\N
1216	\N	/GoodsCirculationAction.do?dispatch=generateExcel	\N	\N
1217	\N	/DeferredAttachmentsAction.do?dispatch=init	\N	\N
1218	\N	/DeferredAttachmentsAction.do?dispatch=download	\N	\N
1219	\N	/DeferredAttachmentsAction.do?dispatch=back	\N	\N
1220	\N	/ContractActionCalculationState.do?dispatch=deferredAttach	\N	\N
1221	\N	/SpecificationActionCalculationState.do?dispatch=deferredAttachCopy	\N	\N
1222	\N	/CommercialProposalsAction.do?dispatch=generateExcel	\N	\N
1223	\N	/ContractorsAction.do?dispatch=generateExcel	\N	\N
1224	\N	/ConditionForContractAction.do?dispatch=ajaxGetReputation	\N	\N
1225	\N	/CommercialProposalAction.do?dispatch=ajaxGetReputation	\N	\N
1226	\N	/SpecificationActionCalculationState.do?dispatch=deferredAttach	\N	\N
1227	\N	/OrdersUnexecutedAction.do?dispatch=generate	\N	\N
1228	\N	/ConditionsForContractAction.do?dispatch=checkPrice	\N	\N
1229	\N	/SpecificationImportAction.do?dispatch=recalcPrices	\N	\N
1230	\N	/LogsAction.do?dispatch=generateExcel	\N	\N
1231	\N	/trusted/NoPermission.do?dispatch=cleanAll	\N	\N
1232	\N	/trusted/NoPermission.do?dispatch=generateExcel	\N	\N
1233	\N	/PaymentActionCalculationState.do?dispatch=newContractor	\N	\N
1234	\N	/ContractorAddActionPaymentCalculationState.do?dispatch=create	\N	\N
1235	\N	/PaymentActionCalculationState.do?dispatch=retFromContractor	\N	\N
1236	\N	/ProduceCostReportAction.do?dispatch=generate	\N	\N
1237	\N	/Menu.do?current_menu_id=id.lithuania_goods_circulation	\N	\N
1238	\N	/DeferredAttachmentsAction.do?dispatch=show	\N	\N
1239	\N	/PaySumAction.do?dispatch=insert	\N	\N
1240	\N	/PaySumAction.do?dispatch=back	\N	\N
1241	\N	/PaySumAction.do?dispatch=ajaxChangeSpecification	\N	\N
1242	\N	/PaySumAction.do?dispatch=process	\N	\N
1243	\N	/PaySumActionCalculationState.do?dispatch=insert	\N	\N
1244	\N	/PaySumActionCalculationState.do?dispatch=process	\N	\N
1245	\N	/PaySumActionCalculationState.do?dispatch=back	\N	\N
1246	\N	/PaySumAction.do?dispatch=input	\N	\N
1247	\N	/PaySumAction.do?dispatch=edit	\N	\N
1248	\N	/ContractorAddActionContract.do?dispatch=process	\N	\N
1249	\N	/RoleAction.do?dispatch=process	\N	\N
1250	\N	/RolesAction.do?dispatch=process	\N	\N
1251	\N	/SpecificationImportAction.do?dispatch=produceView	\N	\N
1252	\N	/NomenclatureProduceForSpecificationImportAction.do?dispatch=edit	\N	\N
1253	\N	/NomenclatureProduceForSpecificationImportAction.do?dispatch=back	\N	\N
1254	\N	/NomenclatureProduceForSpecificationImportAction.do?dispatch=print	\N	\N
1255	\N	/ContractorRequestAction.do?dispatch=printSellerAgreement	\N	\N
1256	\N	/ProduceMovementForGoodsCirculationAction.do?dispatch=reload	\N	\N
1257	\N	/ContractorRequestAction.do?dispatch=printSellerRequest	\N	\N
1258	\N	/CommercialProposalProduceSelectNomenclatureAction.do?dispatch=select?dispatch=filter	\N	\N
1259	\N	/OrdersUnexecutedAction.do?dispatch=generateExcel	\N	\N
1260	\N	/SelectCPOrderAction.do?dispatch=select?dispatch=filter	\N	\N
1261	\N	/UserAction.do?dispatch=deferredAttach	\N	\N
1262	\N	/ShowPrevResponse.do?dispatch=show	\N	\N
1263	\N	/CommercialProposalAction.do?dispatch=uploadTemplate	\N	\N
1264	\N	/UploadFileTemplateCPAction.do?dispatch=input	\N	\N
1265	\N	/UploadFileTemplateCPAction.do?dispatch=back	\N	\N
1266	\N	/DeferredAttachmentsAction.do?dispatch=delete	\N	\N
1267	\N	/ContractorAddActionConditionForContract.do?dispatch=addRowInAccountGrid	\N	\N
1268	\N	/ContractorAddActionConditionForContract.do?dispatch=deleteRowFromAccountGrid	\N	\N
\.


--
-- Data for Name: dcl_action_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_action_role (act_id, rol_id) FROM stdin;
\.


--
-- Data for Name: dcl_asm_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_asm_list_produce (apr_id, asm_id, prd_id, opr_id, apr_count) FROM stdin;
\.


--
-- Data for Name: dcl_assemble; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_assemble (asm_id, asm_create_date, usr_id_create, asm_edit_date, usr_id_edit, asm_number, asm_date, asm_block, asm_count, prd_id, opr_id, asm_type, stf_id) FROM stdin;
8	2026-02-14 23:22:56.61099	1	2026-02-14 23:22:56.61099	1	ASM-001	2026-01-15	0	5	1	\N	1	1
9	2026-02-14 23:22:56.61099	1	2026-02-14 23:22:56.61099	1	ASM-002	2026-01-20	0	3	1	\N	2	2
10	2026-02-14 23:22:56.61099	2	2026-02-14 23:22:56.61099	2	ASM-003	2026-01-25	1	8	1	\N	1	1
11	2026-02-14 23:22:56.61099	3	2026-02-14 23:22:56.61099	3	ASM-004	2026-02-01	0	12	1	\N	1	3
12	2026-02-14 23:22:56.61099	1	2026-02-14 23:22:56.61099	1	ASM-005	2026-02-05	0	2	1	\N	2	2
13	2026-02-14 23:22:56.61099	2	2026-02-14 23:22:56.61099	2	ASM-006	2026-02-10	1	7	1	\N	1	1
14	2026-02-14 23:22:56.61099	4	2026-02-14 23:22:56.61099	4	ASM-007	2026-02-12	0	4	1	\N	1	4
\.


--
-- Data for Name: dcl_attachment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_attachment (att_id, att_parent_id, att_parent_table, att_name, att_file_name, att_link_id, usr_id, att_create_date) FROM stdin;
\.


--
-- Data for Name: dcl_blank; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_blank (bln_id, bln_type, bln_name, lng_id, bln_charset, bln_preamble, bln_note, bln_usage) FROM stdin;
1	1	Бланк LINTERA RU	1	UTF-8	\N	\N	\N
2	1	Бланк LINTERA EN	2	UTF-8	\N	\N	\N
3	2	Бланк DCL Group	1	UTF-8	\N	\N	\N
\.


--
-- Data for Name: dcl_blank_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_blank_image (bim_id, bln_id, bim_name, bim_image) FROM stdin;
\.


--
-- Data for Name: dcl_catalog_number; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_catalog_number (ctn_id, stf_id, prd_id, ctn_number, mad_id) FROM stdin;
\.


--
-- Data for Name: dcl_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_category (cat_id, parent_id, cat_name) FROM stdin;
100	\N	Номенклатура
1	100	Гидравлика
2	100	Фильтрация
3	100	Абразивный инструмент
4	100	Пилы
5	100	Станки
6	100	Ножи
7	100	Фрезы
8	100	Насосы
9	100	Цилиндры
10	100	Прочее
\.


--
-- Data for Name: dcl_cfc_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cfc_list_produce (ccp_id, cfc_id, stf_id, prd_id, ccp_price, ccp_count, ccp_nds_rate, cpr_id) FROM stdin;
\.


--
-- Data for Name: dcl_cfc_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cfc_message (ccm_id, cfc_id, usr_id, ccm_create_date, ccm_message, ctr_id) FROM stdin;
\.


--
-- Data for Name: dcl_commercial_proposal; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_commercial_proposal (cpr_id, cpr_create_date, usr_id_create, cpr_edit_date, usr_id_edit, cpr_number, cpr_date, ctr_id, cpr_concerning, cpr_preamble, cur_id, cpr_course, cpr_nds, trm_id_price_condition, cpr_country, cpr_pay_condition, trm_id_delivery_condition, cpr_delivery_address, cpr_sum_transport, cpr_delivery_term, cpr_add_info, cpr_final_date, usr_id, cpr_proposal_received_flag, cpr_date_accept, cpr_block, cpr_img_name, cpr_summ, cps_id, cpr_nds_by_string, cpr_sum_assembling, cpr_old_version, cpr_check_price, cpr_check_price_date, usr_id_check_price, cur_id_table, cpr_assemble_minsk_store, bln_id, cpr_all_transport, cpr_concerning_invoice, cpr_can_edit_invoice, cpr_pay_condition_invoice, cpr_delivery_term_invoice, cpr_final_date_invoice, cpr_comment, executor_id, cpr_executor_flag, pps_id, cpr_reverse_calc, cps_id_seller, cps_id_customer, cpr_prepay_percent, cpr_prepay_sum, cpr_delay_days, cpr_no_reservation, cpr_provider_delivery, cpr_provider_delivery_address, cpr_delivery_count_day, cpr_free_prices, cpr_donot_calculate_netto, cpr_print_scale, cpr_contract_scale, cpr_invoice_scale, cpr_guaranty_in_month, ctr_id_consignee, cpr_final_date_above, cpr_tender_number, cpr_tender_number_editable, cpr_proposal_declined) FROM stdin;
\.


--
-- Data for Name: dcl_con_list_spec; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_con_list_spec (spc_id, con_id, spc_number, spc_date, spc_summ, spc_summ_nds, spc_executed, spc_nds_rate, spc_delivery_date, spc_add_pay_cond, spc_original, spc_montage, spc_group_delivery, spc_delivery_cond, spc_delivery_term_type, spc_percent_or_sum, spc_delivery_percent, spc_delivery_sum, spc_pay_after_montage, spc_annul, spc_annul_date, spc_comment, usr_id, spc_letter1_date, spc_letter2_date, spc_letter3_date, spc_complaint_in_court_date, spc_additional_days_count) FROM stdin;
\.


--
-- Data for Name: dcl_con_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_con_message (cms_id, con_id, spc_id, usr_id, cms_create_date, cms_message, ctr_id) FROM stdin;
\.


--
-- Data for Name: dcl_cond_for_contract; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cond_for_contract (cfc_id, cfc_create_date, usr_id_create, cfc_edit_date, usr_id_edit, cfc_place, cfc_place_date, usr_id_place, cfc_execute, cfc_execute_date, usr_id_execute, ctr_id, cfc_doc_type, cfc_con_number_txt, cfc_con_date, cur_id, con_id, cfc_spc_number_txt, cfc_spc_date, cfc_pay_cond, cfc_delivery_cond, cfc_guarantee_cond, cfc_montage_cond, cfc_date_con_to, cfc_count_delivery, cps_id_sign, cps_id, cfc_delivery_count, cfc_custom_point, pps_id, cfc_comment, cfc_need_invoice, cfc_check_price, cfc_check_price_date, usr_id_check_price, sln_id, cfc_annul, cfc_annul_date, usr_id_edit_annul, cfc_edit_annul_date) FROM stdin;
\.


--
-- Data for Name: dcl_contact_person; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contact_person (cps_id, ctr_id, cps_name, cps_phone, cps_fax, cps_block, cps_position, cps_on_reason, cps_email, cps_mob_phone, cps_contract_comment, cps_fire) FROM stdin;
1	1	Луковсков В.Е.	(+370 349) 61161	(+370 349) 61297	1	Директор	Устава	\N	\N	\N	\N
2	3	Пранович В.Г.	(+375 17) 328-66-31	(+375 17) 328-60-41	1	\N	\N	\N	\N	\N	\N
3	5	Пранович В.Г.	(+375 17) 3870240	(+375 17) 3870250	1	Директор	Устава	\N	\N	в лице Директора Прановича В.Г., действующего на основании Устава	\N
4	7	Пац Василий Николаевич	(+375 22) 224-18-16	(+375 22) 224-18-16	\N	Директор	Устава	\N	\N	\N	\N
5	9	Маненок А.И.	(+375 17) 211 87 48	(+375 17) 211 87 36	\N	\N	\N	\N	\N	\N	\N
6	11	Гутковский и.В.	(01794) 37-2-21	(01794) 53-0-89	\N	\N	\N	\N	\N	\N	\N
7	13	Боровик Николай Николаевич	(+375 17) 340 78 11	(+375 17) 340 03 22	\N	начальник отдела по подготовке опытного производства	\N	omts.belniilit@gmail.com	(+375 29) 640 78 11	\N	\N
8	15	Винник М.	217 - 20 - 72	217 - 20 - 22	\N	\N	\N	\N	\N	\N	\N
10	17	Нефедов Д.В.	0222-22-17-69	\N	\N	\N	\N	\N	\N	\N	\N
12	19	Скребец Виктор Адамович	(+375 1597) 2 52 06	(+375 17) 210 81 96	\N	главный инженер	\N	victor@leor.by	\N	\N	\N
13	21	Бебех А.Н.	(+375 1710) 467 49	(+375 1710) 467 49	\N	\N	\N	\N	\N	\N	\N
14	23	Павлов С.А.	(+375 1561) 215 46	(+375 1561) 266 73	\N	\N	\N	\N	\N	\N	\N
15	25	Курильчик А.Е.	8-02334-5-51-66	8-02334-5-60-52	\N	\N	\N	\N	\N	\N	\N
16	27	 Лапко Александр Николаевич	+375 17 242 92 40	+375 17 243 16 90	\N	Генеральный директор	устава	lan@maz-man.com.by	+375 29 114 08 00	\N	\N
17	29	Зам. ген. директора Гуль А.Г.	0212 37-66-34	0212 56-31-53	\N	\N	\N	\N	\N	\N	\N
18	31	Лагодич В.	284 71 86	237 71 88	1	менеджер	\N	\N	\N	\N	1
19	33	Керножицкий В.А.	(+375 225) 51 11 89	(+375 225) 44 71 77	\N	Главный механик	\N	\N	\N	\N	\N
20	35	Аблажей Михаил иванович	\N	(0152) 33 21 81	\N	\N	\N	\N	\N	\N	\N
21	37	Василькова Галина Петровна	(+375 216) 518150	(+375 216) 518152	\N	\N	\N	vasilkova@krasnyborets.com	\N	\N	\N
22	39	Руководителю ВТО Луцевичу В.К.	203 23 70	203 23 70	\N	\N	\N	\N	\N	\N	1
216	25	Начальник УКО Козлова и.В.	(02334) 5-54-62	(02334) 5-54-62	\N	\N	\N	\N	\N	\N	\N
218	25	Виницкая Анна Владимировна	8-02334-5-47-92	8-02334-5-69-02	\N	\N	\N	\N	\N	\N	\N
220	25	Начальник УКО Козлова и.В.	(02334) 5-54-62	(02334) 5-54-62	\N	\N	\N	\N	\N	\N	\N
226	39	Зубовичу В.В.	203-23-70	226-62-47	\N	\N	\N	\N	\N	\N	1
250	39	Сладковский А.С.	(+375 17) 306 20 32	(+375 17) 306 20 32	\N	\N	\N	\N	\N	\N	\N
282	39	Юницкий В.Р.	(+375 17) 226 60 52	(+375 17) 226 60 52	\N	Начальник ОСТО	\N	\N	\N	\N	1
286	31	Лагодич В.И.	284 71 86	237 71 88	1	начальник группы ВЭД	\N	\N	\N	\N	1
288	31	Лагодич В.И.	284 71 86	237 71 88	1	Начальник группы ВЭД	\N	\N	\N	\N	1
326	25	Марушкевич Татьяна	8-0233-45-46-77	8-0233-45-60-52	\N	\N	\N	\N	\N	\N	\N
328	25	Гл. механик Борщев С.М., Ткачев и.	375-2334-56222	375-2334-26902	\N	\N	\N	\N	\N	\N	\N
352	25	Риторев и.В.	(+375 233) 4213 54	(+375 233) 4213 54	\N	инженер УМТС	дов	\N	\N	вдв	\N
366	29	Коршак В.И.	(0212) 37-66-34	(0212) 36-31-53	\N	\N	\N	\N	\N	\N	\N
388	39	Воробьев А.В.	(+375 17) 226 61 13	(+375 17) 201 30 32	\N	Руководитель группы	\N	\N	\N	\N	\N
406	29	Демиденко Г.И.	0212 37-66-34	0212 36-31-53	\N	\N	\N	\N	\N	\N	\N
422	29	Демиденко Г.И.	(0212) 37-66-34	(0212) 36-31-53	\N	\N	\N	\N	\N	\N	\N
468	37	Осипов Ю.В.	(8-0216) 21-81-60	(8-0216) 21-81-23	\N	\N	\N	\N	\N	\N	\N
486	37	Цыганков Л.Е.	(8-0216) 21-81-59	(8-0216) 21-81-23	\N	\N	\N	\N	\N	\N	\N
528	33	 Бундюков Ю.В.	(+375 225) 411-479	(+375 225) 43-31-11	\N	Начальник ОКО	\N	\N	\N	\N	\N
598	15	Геннадий	217-20-35	217-20-38	\N	\N	\N	\N	\N	\N	\N
692	33	ОМТСм для Сергея	618 55 71	(0225) 43 31 11	\N	\N	\N	\N	\N	\N	\N
756	33	Жук В.В.	(0225) 41 08 39	(0225) 41 08 39	\N	\N	\N	\N	\N	\N	\N
758	25	Чернявский Н.Н.	+375 2334 55454	+375 2334 55487	\N	\N	\N	\N	\N	\N	\N
760	25	тендерная комиссия, Чернявский Н.Н.	+375 2334 55454	+375 2334 55487	\N	\N	\N	\N	\N	\N	\N
794	15	Технический директор Ракомсин А.П.	+375 17 217 9602	+375 17 217 9796	\N	\N	\N	\N	\N	\N	\N
802	39	Клыч В.А.	(+375 17) 226-62-54	(+375 17) 226-62-43	\N	Нач. конструкторского бюро ОТР 	\N	\N	\N	\N	\N
824	11	Кравцов В.	\N	\N	\N	\N	\N	\N	\N	\N	\N
826	11	Кравцов	(01794)37-2-21	(01794)55-9-95	\N	\N	\N	\N	\N	\N	\N
848	39	Брага Ю.В.	(+375 17) 203 23 70	(+375 17) 203 23 70	\N	руководитель группы з/ч ВТО 	\N	\N	\N	\N	1
886	39	Шинкевич А.В.	(+375 17) 203 35 01	(+375 17) 203 47 12	\N	главный механик 	\N	\N	\N	\N	\N
920	13	Дубиковский Вячеслав Касперович	240-35-22	240-35-22	\N	\N	\N	\N	\N	\N	\N
922	39	Литвинов С.А.	(+375 17) 226-62-54	(+375 17) 226-62-43	\N	\N	\N	\N	\N	\N	\N
930	39	Третьяков П.И.	017 203 32 02	017 203 32 02	\N	\N	\N	\N	\N	\N	1
938	7	Евгений	(0222) 24-79-92	(0222) 24-17-87	\N	\N	\N	\N	\N	\N	\N
944	39	Гацко Василий Васильевич	(+375 17) 226-61-13	(+375 17) 306-20-32	\N	Начальник СИП 	\N	\N	\N	\N	\N
952	25	Кутырев Ю.А.	(8-02334) 55463	(8-02334) 56052	\N	\N	\N	\N	\N	\N	\N
958	39	Кузнецова С.К.	(+375 17) 203-23-70	(+375 17) 203-23-70	\N	\N	\N	\N	\N	\N	\N
972	25	Щербакова Е.Н.	02334 5-67-03	02334 5-69-01	\N	\N	\N	\N	\N	\N	\N
998	33	Штарбекер С.А.	(+375 225) 410 863	(+375 225) 43 31 11	\N	экономист ОМТСМ	\N	\N	\N	\N	\N
1000	33	тендерный отдел ОАО "Белшина"	\N	(+375 225) 411 428	\N	\N	\N	\N	\N	\N	\N
1006	39	Бончковский А.Ю.	017 203 32 02	017 203 32 02	\N	\N	\N	\N	\N	\N	1
1016	15	Господину Урбанайтесу В.Н.  начальнику отдела импорта	(+375 17) 2172134	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	1
1020	33	ООПТ	(0225) 411428	(0225) 411428	\N	\N	\N	\N	\N	\N	\N
4158	15	Галко Евгений Евгениевич	217-97-56	217-23-55	\N	зам гл технолога	\N	\N	\N	\N	\N
1030	13	Мельников А.П.	(+375 17) 241-08-22	(+375 17) 240-03-22	\N	директор	устава	\N	\N	в лице директора Мельникова А.П., действующего на основании Устава	\N
1050	15	Гачков В.П.	217-92-80	217-20-22	\N	\N	\N	\N	\N	\N	\N
1054	39	Савельев О.В.	218-64-11	203-32-02	\N	\N	\N	\N	\N	\N	1
1076	39	Рыков В.А.	(017) 226-61-13	(017) 201-30-32	\N	\N	\N	\N	\N	\N	\N
1136	39	Жилач В.М.	203-79-54	203-32-02	\N	\N	\N	\N	\N	\N	\N
1162	33	Грак Сергей Сергеевич	(+ 375 225)411639	\N	\N	\N	\N	\N	\N	\N	\N
1196	1	Вайдас Мингилас 	(+370-349) 61161	(+370-349) 61297	1	\N	\N	\N	\N	\N	1
1226	39	Завадская	\N	(+375 17) 226-60-52	\N	\N	\N	\N	\N	\N	\N
1326	27	Зам. генерального директора Жаврид В.Ю.	(+375 17) 762-44-72	(+375 17) 762-44-72	\N	\N	\N	\N	\N	\N	\N
1344	15	Начальник бюро комплектующих Пышная С.А.	(+375 17) 2172019	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	\N
1624	27	Рудковский Д.П.	(+375 17) 217-6216	(+375 17) 217-6231	\N	\N	\N	\N	\N	\N	\N
1658	15	Чайчиц В.В.	+375 17 2178042	+375 17 2172022	\N	\N	\N	\N	\N	\N	\N
1762	39	Зусин Г.М.	(+375 17) 203-04-69	(+375 17) 226-60-52	\N	\N	\N	\N	\N	\N	\N
1770	25	Марченко Владимир Григорьевич 	(02334) 56347	(02334) 55391	\N	экономист	\N	\N	\N	\N	\N
1790	39	Карюк А.С.	(+375 17) 203-0469	(+375 17) 226-6052	\N	инженер ОСТО	\N	\N	\N	\N	\N
1792	29	Петрухин В.В.	(0212) 37-09-26	(0212) 36-31-53	\N	\N	\N	\N	\N	\N	\N
1826	27	Зам.директора по производству Наумчик В.П.	(+375 17) 210-5015	(+375 17) 243-1690	\N	\N	\N	\N	\N	\N	\N
1988	27	Орлов Г.О.	(+375 17) 210 5015	(+375 17) 243 1690	\N	\N	\N	\N	\N	\N	\N
2006	15	Ковалевский П.М.	217 94 92	217 94 92	\N	\N	\N	\N	\N	\N	\N
2096	25	Бурулева	+375 2334 54398	+ 375 2334 56052	\N	\N	\N	\N	\N	\N	\N
2192	11	Корочкина Мария ивановна	(01794) 37-2-21	(01794)53-0-89	\N	Главный инженер	\N	\N	\N	\N	\N
2206	33	Баранов А.В.	8 (0225) 44-78-41	8 (0225) 41-13-99	\N	\N	\N	\N	\N	\N	\N
2210	15	Пышная С.А.	(+375 17) 2172019	(+375 17) 2172022	\N	Начальник УВЭС по импорту	\N	\N	\N	\N	\N
2262	29	Гудков В.В.	80212364175	80212363153	\N	\N	\N	\N	\N	\N	\N
2266	39	Нужный В.М.	(+375 17) 226 61 13	(+375 17) 306 20 32	\N	\N	\N	\N	\N	\N	\N
2306	39	Подоровский Сергей Анатольевич	(+375 17) 203 31 45	(+375 17) 201 30 32	\N	Начальник бюро МТС 	\N	\N	\N	\N	\N
2362	25	Борщов Сергей Михайлович	(+375 2334) 5-62-22	(+375 2334) 269 02	\N	\N	\N	\N	\N	\N	\N
2372	1	Балтроманайтис М.	+370 698 37351	+370 349 61161	1	\N	\N	\N	\N	\N	1
2396	15	Начальник УВК Демянко О.И.	(+375 17) 217 2013	(+375 17) 217 2008	\N	\N	\N	\N	\N	\N	\N
2476	15	Бурина Татьяна Александровна	80172179734	80172179734	\N	\N	\N	\N	\N	\N	\N
2486	1	Rolandas Budrevicius	+370-349-61161	+370-349-61297	1	\N	\N	\N	\N	\N	1
2610	37	Абрамов Александр Юрьевич	802161218152	802161218152	\N	\N	\N	\N	\N	\N	\N
2672	39	Смольский Александр	(+375 17) 226 61 13	(+375 17) 306 20 32	\N	\N	\N	\N	\N	\N	\N
2678	1	Стучинскас Лаурас	(+370-349) 61161	(+370-349) 61297	1	\N	\N	\N	\N	\N	1
2746	39	Дуксин Дмитрий Петрович	(+375 17) 2186293	\N	\N	\N	\N	\N	\N	\N	\N
2754	1	Вильма Матиёшайтене	(+370 349) 69602	(+370 349) 61297	1	\N	\N	\N	\N	\N	1
2816	21	Ярошонок Ю.В.	(029) 140-65-53	(01742) 295-80	\N	\N	\N	\N	\N	\N	\N
2858	25	Мельников Руслан Николаевич	8-02334-56047	8-02334-56052	\N	\N	\N	\N	\N	\N	\N
2860	33	Солодкову Сергею	8-0225-410-270	8-0225-433-111	\N	\N	\N	\N	\N	\N	\N
2988	33	Господарик Руслан Леонидович	(+375 225) 447841	(+375 225) 411399	\N	инженер	\N	\N	\N	\N	\N
2996	33	Манкевич Олег Вячеславович	(0225) 41 08 90	(0225) 41 08 90	\N	инженер отдела комплектации	\N	\N	\N	\N	\N
3030	39	Целуйко Н.Г.	203-32-02	\N	\N	\N	\N	\N	\N	\N	1
3040	27	Главный конструктор Стецко А.П.	(+375 17) 210 50 15	(+375 17) 243 16 90	\N	\N	\N	\N	\N	\N	\N
3110	29	Тендерная комиссия	80212376980	80212363153	\N	\N	\N	\N	\N	\N	\N
3138	25	Здоровцова Ольга	8(02334)5-57-33	8(02334)5-57-23	\N	инженер по ПСР	\N	\N	\N	\N	\N
3186	25	Ячная Н.Ф.	8-02334-54604	8-02334-55839	\N	\N	\N	\N	\N	\N	\N
3194	31	Реут Валерий Николаевич	(+375 17) 504 85 27	(+375 17) 504 85 27	\N	Начальник Отдела МТСиК	\N	reut@medin.by	\N	\N	\N
3208	25	Королев А.В.	(02334) 24423, 55391	\N	\N	Начальник УМТС	\N	grb.ows@bmz.gomel.by	\N	\N	\N
3282	33	Садовский С.Г.	(0225) 41 08 63	(0225) 43 13 48	\N	инженер ОМТС М	.	\N	\N	\N	\N
3504	25	Зубакова Мария	+375 2334 56431	+375 2334 56521	\N	\N	\N	\N	\N	\N	\N
3528	25	Пасютин Д.И.	+375 2334 55363	+375 2334 55457	\N	\N	\N	\N	\N	\N	\N
3530	13	Гречаник Сергей	970-72-80	+375 17 3400322	\N	\N	\N	\N	\N	\N	\N
3560	33	Комаренко В.И.	8-0225-410-863	8-0225-433-111	\N	Заместитель генерального директора по материально-техническому снабжению	Доверенности №205 от 02.09.2009	\N	\N	\N	\N
3590	15	Шафаренко С.В.	(+375 17) 217-2297	(+375 17) 217-2022	\N	Начальник бюро импорта	\N	\N	\N	\N	\N
3676	15	Елисеенко Диана	+375 17 217 92 80	+375 17 217 20 22/09	\N	\N	\N	\N	\N	\N	\N
3712	39	Молочников А.В.	(+375 29) 919 43 45	(+375 17) 203 32 02	\N	\N	\N	\N	\N	\N	\N
3772	15	ирина Дорожко	+375 172 17 20 72	+375 172 17 20 22	\N	\N	\N	\N	\N	\N	\N
4004	31	Углицких Алексей	284-71-86	284-71-86	\N	инженер по снабжению	\N	\N	\N	\N	1
4086	39	Шакура Андрей Анатольевич	(+375 17) 203 32 02	(+375 17) 218 64 11	\N	инженер	\N	\N	\N	\N	\N
4100	31	Лебедев Сергей Михайлович	8-029-751-91-43	284-71-86	\N	Главный конструктор	\N	\N	\N	\N	\N
4129	13	Хохлова Т.С.	340-05-22	340-03-22	\N	\N	\N	\N	\N	\N	\N
4142	15	Сенченя Владимир Анатольевич	+375 17 2172381	+375 17 2172022	\N	\N	\N	\N	\N	\N	\N
4148	15	Мостовая Валентина Васильевна	217-96-32	\N	\N	нач. бюро ОМТС	\N	\N	\N	\N	\N
5529	15	Веренич Андрей	217 92 80	217 20 22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
4204	15	Начальник отдела импорта Дунчик М.В.	(+375 17) 217 2134	(+375 17) 217 2022	\N	\N	\N	\N	\N	\N	\N
4221	15	 Плетежев Виктор Алексеевич	\N	217-95-00	\N	 Главный инженер АСЗ	\N	\N	\N	\N	\N
4236	15	исаевич Александр Георгиевич	+ 375 17 217-96-12	+375 17 217-90-89	\N	\N	\N	\N	\N	\N	\N
4243	15	Владимир Александрович Терашкевич 	\N	242-81-60	\N	Директор иШП	\N	\N	\N	\N	\N
4247	15	Сенченя Владимир	\N	 +375 17 217-20-22	\N	\N	\N	\N	\N	\N	\N
4289	19	инженер ОМТС Серебряков Аркадий Владимирович	(029) 210 81 96	210 81 96	\N	инженер ОМТС	\N	\N	\N	\N	\N
4334	27	Орлов Г.О.	+375 17 217 79 69	+375 17 243 04 23	\N	\N	\N	\N	\N	\N	\N
4353	39	Щурко Леонид	(+375 17) 203 04 69	(+375 17) 226 60 52	\N	инженер-конструктор ОСТО СИП 	\N	\N	\N	\N	1
4436	11	Грабовский Андрей Валерьевич	(01794) 3-72-21	(01794) 5-30-89	\N	Гл. механик	\N	\N	\N	\N	\N
4453	15	Павел Хмелевский	217 22 97	217 20 22	\N	\N	\N	\N	\N	\N	\N
4474	21	Виктор Кучик	(029) 6143111	(0174) 225193	\N	\N	\N	\N	\N	\N	\N
4475	35	главный механик Бричев Александр Алексеевич	8 029 6312894	\N	\N	\N	\N	\N	\N	\N	\N
4524	25	Клименец Е.К.	(02334) 5-49-10	(02334) 5-58-15	\N	\N	\N	\N	\N	\N	\N
4561	15	Миролевич Наталья Владимировна	+375 17 217 20 13	+375 17 217 25 41	\N	Начальник отдела УВК	\N	maz_uvk@tut.by	+375 29 365 47 27	\N	\N
4564	15	Потемкин Александр Георгиевич	+375 222 31 75 64	+375 222 24 51 66	\N	Зам Директора по качеству завода Могилевтрансмаш	\N	\N	\N	\N	\N
4577	15	Гармаш Элеонора Леонидовна	+375 17 217 22 97	+375 17 217 20 22	\N	Начальник Отдела импорта	\N	trade@maz.by	\N	\N	\N
4584	31	Крупко Михаил Григорьевич	(017) 294 55 51	(017) 285 31 31	\N	директор	Устава	\N	\N	\N	1
4645	15	Жук Павел Евгеньевич	(+375 17) 2179394	(+375 17) 2172022 / 2737696	\N	Начальник УВЭС по импорту	\N	\N	\N	\N	\N
4666	33	Бахурева М. Ф.	(+375 225) 410 572	(+375 225) 431 348	\N	\N	\N	\N	\N	\N	\N
4670	33	Гуща В.М.	+375-225-410-890	+375-225-411-428	\N	Главный инженер ОАО "Белшина"	Доверенности №237 от 16.07.2013	belshina@belshina.biz	\N	\N	\N
4787	39	Таганович Сергей иванович	-	-	\N	Главный инженер	Доверенности №62-35/2662 от 15.03.2018г	\N	-	в лице главного инженера Тагановича С. И., действующего на основании Доверенности №62-35/2662 от 15.03.2018г	\N
4803	33	Никитенко Вадим Георгиевич	(+375 225) 410 219, (029) 377 64 77	(+375 225) 43 41 47	\N	зам. главного инженера ЗМШ по техническому развитию	\N	zmsh-tr@belshina.biz	\N	\N	\N
4812	35	Барейко Александр	+375 29 7846959	+375 152 526361	\N	\N	\N	\N	\N	\N	\N
4819	39	Черныш Андрей Михайлович	(+375 29) 386 77 95, (+375 17) 203 32 02	(+375 17) 203 32 02, 218 64 11	\N	\N	\N	\N	\N	\N	\N
4873	15	Захарик Андрей Михайлович	\N	(+375 17) 2179796	\N	Заместитель генерального директора - Технический директор ОАО "МАЗ"	\N	\N	\N	\N	\N
4925	37	Александр Козыревич	+375 216-21-81-50	+375 216-21-81-52	\N	товаровед отдела обеспечения	\N	\N	\N	\N	\N
4929	39	Жуковский А.А.	\N	+375 17 2186411	\N	\N	\N	\N	+375 29 6587806	\N	\N
4932	33	Гюлалиев Афлан Тарланович	(+375 225) 410825	(+375 225) 431348	\N	Начальник ОМТС	\N	\N	(+375 29) 1785843	\N	1
4934	25	Макаревич и.И.	(02334) 54598	(02334) 55391, 24423	\N	И.о. начальника УМТС	\N	\N	\N	\N	\N
4942	39	Кацубо Евгений иванович	(+375 17) 2186200	(+375 17) 2186243	\N	\N	\N	otr@atlant.com.by	\N	\N	\N
4958	15	Тирашкевич В.А.	\N	\N	\N	директор иШП ОАО "МАЗ" 	доверенности №108-16-19 от 25.02.2009	\N	\N	\N	\N
4959	15	Никитин Павел	(+375 17) 217-9816	\N	\N	инженер иШП	\N	\N	\N	\N	\N
5007	1	Andrius Liutkus 	(+370 349) 61161	(+370 349) 61297	1	\N	\N	andrius.liutkus@lintera.info	\N	\N	\N
5017	15	Баранов Валерий Петрович 	\N	(+375 29) 2172065	\N	Директор по качеству ОАО "МАЗ"	\N	\N	\N	\N	\N
5054	15	начальнику бюро комплектующих господину К.Баранову	\N	\N	\N	\N	\N	\N	\N	\N	\N
5090	37	игорь Петрович Лаппо	(0216) 21-81-37	(0216) 21-81-52	\N	\N	\N	\N	(+375 44) 7768029	\N	\N
5158	39	Миклашевич Вадим игоревич	(+375 17) 306 20 32	(+375 17) 306 20 32	\N	\N	\N	\N	\N	\N	\N
5164	15	Гайдук Анастасия	(+375 17) 2172 381	(+375 17) 2172 009	\N	\N	\N	\N	\N	\N	\N
5208	39	Кривоблоцкая Татьяна	+375 17 2186145	+375 17 3062032	\N	\N	\N	\N	\N	\N	\N
5314	15	Бадун Ольга	(+375 17) 2179280	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	\N
5315	15	Ковалевич А.П.	217 23 81	217 20 22	\N	Заместитель начальника отдела закупок оборудования	\N	\N	\N	\N	\N
5357	15	Житковец Владимир Андреевич	(+375 17) 2179611	(+375 17) 2172355	\N	Главный технолог ОАО "МАЗ"	\N	\N	\N	\N	\N
5365	33	Бешанов А.П.	(+375 225) 432592	(+375 225) 433111	\N	\N	\N	\N	\N	\N	\N
5388	29	Зуев Л.А.	(0212) 37-69-07	(0212) 36-31-53	\N	\N	\N	\N	\N	\N	\N
5399	7	Владимир Григорьевич	(0222) 24-79-92	(0222) 24-79-92	\N	\N	\N	\N	\N	\N	\N
5404	15	Варабей О.Л.	(+375 17) 2172019	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	1
5451	5	Абрамович А.Г.	141	\N	1	заместитель директора по экономическим вопросам	доверенности №122 от 21.05.2015	\N	\N	в лице заместителя директора по экономическим вопросам Абрамовича А.Г., действующего на основании доверенности №122 от 21.05.2015	1
5452	1	Мостеницене Татьяна	(+370 349) 61161	(+370 349) 61297	1	\N	\N	tatjana.mosteneciene@lintera.info	\N	\N	\N
5455	1	Чинчене Вита	(+370 349) 61161	\N	1	\N	\N	vita.cinciene@lintera.info	\N	\N	\N
5474	15	Люсиков В.А.	(+375 17) 2172134	(+375 17) 2172022	\N	Зам. генерального директора ОАО "МАЗ" по ВЭС	Доверенности №101-1-16/61 от 12.01.2010	\N	\N	\N	\N
5583	33	Рябко Леонид Леонидович	(+375 225) 411651	(+375 225) 411651	\N	главный инженер ЗМШ	\N	\N	(+375 29) 1828151 	\N	\N
5641	13	Бондарик Н.Е.	341-08-22	340-03-22	\N	\N	\N	\N	\N	\N	\N
5654	15	Теран Л.Ф.	217 96 37	217 96 37	\N	Начальник УЗОиЗЧ	\N	\N	\N	\N	\N
5704	15	Червяк Анатолий Сергеевич	217-22-31	217-93-82	\N	Главный инженер литейного производства	\N	\N	\N	\N	\N
5739	37	игнаткович Г.В.	(0216) 21-83-81	(0216) 21-81-31	\N	\N	\N	\N	\N	\N	\N
5750	15	Таруть Юрий иванович	+375 17 217 98 09	+375 17 217 90 89	\N	главный инженер	доворенность №098-20/135 от 06.02.2014	\N	\N	в лице главного инженера Таруть Ю.И., действующего на основании доворенности №098-20/135 от 06.02.2014 	\N
5771	33	Катеринич Д.С.	\N	\N	\N	Генеральный директор	Устав	\N	\N	\N	\N
5790	33	Березкин Евгений Михайлович	(+375 225) 410836	\N	\N	начальник ОМА	\N	\N	\N	\N	\N
5848	1	Olegas Beleckis	(+370 349) 61161	(+370 349) 61297	1	\N	\N	\N	\N	\N	1
5858	31	Борисевич Владимир Владимирович	+375 17 294 55 51	+375 17 285 31 31	\N	заместитель директора	Устава	\N	+375 44 734 25 56, +375 29 753 75 01	\N	1
5939	33	Берникович Сергей	(+375 225) 447376	(+375 225) 449161	\N	\N	\N	\N	\N	\N	\N
5945	33	Екатерина	(0225) 43 44 21	\N	\N	инженер ОМТС М	\N	\N	\N	\N	\N
5964	33	Юлия	(0225) 44 65 86	\N	\N	инженер ОМТС	\N	bmizchemistry@belshina.biz	\N	\N	\N
6083	15	Копоть Виталий Анатольевич	+375 172 172325	+375 172 179089	\N	\N	\N	\N	\N	\N	\N
6139	39	Наталья Александровна	\N	(+375 17) 3062032	\N	\N	\N	\N	\N	\N	\N
6218	39	Лозовский Петр Феликсович	(+375 17) 2186318	(+375 17) 2266247	\N	\N	\N	LozovskyPF@atlant.com.by	\N	\N	\N
6277	33	Дегтярев А.В.	(+375 225) 447907	(+375 225) 431348	\N	директор механического завода ОАО "Белшина"	\N	\N	(+375 29) 1221322	\N	\N
6304	15	иванкович В.В.	(+375 17) 2172019	(+375 17) 2172022	\N	зам. генерального директора по МТСиК	доверенности	\N	\N	\N	\N
6314	15	Грамадский Е.В.	+375 17 217 23 25	+375 17 217 90 89	\N	инженер ОГМех	\N	ugmex@maz.by	\N	\N	\N
6318	15	Помазанская Т.Г.	217 97 89	217 90 89	\N	\N	\N	\N	\N	\N	\N
6372	37	Шумейко Геннадий Леонидович	(+375 216) 518126	(+375 216) 518152	\N	заместитель директора по общим вопросам начальник отдела материально-техническо	доверенности №8 от 01.01.2021г.	sdep@krasnyborets.com	\N	\N	\N
6374	13	Петкевич Олег Евгеньевич	(+375 17) 341-0822	(+375 17) 341-0822	\N	Заместитель директора по опытно-экспериментальному производству	Доверенности №37 от 12.02.2018 г. (действует до 11.05.2018)	\N	\N	в лице зам.директора Петкевича О.Е., действующего на основании Доверенности №20 от 26.01.2017г	\N
6423	25	Тендерная комиссия	\N	\N	\N	\N	\N	\N	\N	\N	\N
6427	37	Дмитрий (нач. ЭМО)	(0216) 21-83-81	(0216) 21-81-31	\N	\N	\N	\N	\N	\N	\N
6429	15	Мирончик В. Л. 	\N	\N	\N	И.О. главного инжинера 	\N	\N	\N	\N	\N
6435	15	инна Афанасьева	(+375 17) 217 23 81	(+375 17) 217 20 22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
6454	15	Пинчук Дмитрий	(+375 17) 217 91 27	(+375 17) 217 99 18	\N	инженер	\N	\N	\N	\N	\N
6507	15	Станишевская Л.В.	(+375 17) 217 23 25	(+375 17) 217 90 89	\N	\N	\N	\N	\N	\N	\N
6519	39	Захарчук Александр	(+375 17) 218 63 84	\N	\N	инженер ОСТО СИП	\N	zaharchukOSTO@atalant.com.by	(+375 29) 778 09 59 	\N	1
6589	39	Ленцкевич А.И.	\N	\N	\N	Зам. ген. деректора по коммерческим вопросам	\N	\N	\N	\N	\N
6592	39	Шумило В.С.	\N	\N	\N	Генеральный Директор	Устава	\N	\N	\N	1
6597	33	Балыко В.Н.	\N	(0225) 44-73-76	\N	Главный механик ЗМШ	\N	\N	\N	\N	\N
6675	15	Ковалевский П.М.	(+375 17)217-98-16	(+375 17)242-81-62	\N	Начальник ОМТС ИШЗ	\N	\N	\N	\N	\N
6680	15	Мышко А.П.	(+375 17) 2179986	(+375 17) 2172000	\N	Главный конструктор АМАЗа	\N	\N	\N	\N	\N
6709	39	Бруенков Сергей	(+375 29) 550-11-66	(+375 17) 218-64-11	\N	\N	\N	\N	\N	\N	\N
6744	9	Виталий Владимирович Барышев	+375 17 211 87 49	+375 17 211 87 49	\N	Специалист коммерческого отдела	\N	ko_rabota@mail.ru	+375 025 608 34 50	\N	\N
6766	15	Рудакова Т.М.	+375 17 2 179089	+375 17 2 179089	\N	\N	\N	\N	\N	\N	\N
6798	15	Невар Ф.Ф.	(+375 17) 2179120	(+375 17) 2172361	\N	Начальник УВЭС по экспорту	\N	\N	\N	\N	\N
6880	31	Чекан	(+375 17) 5048527	(+375 17) 5048527	\N	\N	\N	\N	\N	\N	1
6955	11	Яхновец А.Д.	(+375 1794) 53088	(+375 1794) 53089	\N	Директор	Устава	\N	\N	\N	\N
6988	21	Кучик Виктор Александрович	8-0174-226315	\N	\N	\N	\N	\N	8-029-6143111	\N	\N
7059	15	Морозько Ольга	+375 17 217 92 80	+375 17 217 20 22	\N	инженер	\N	\N	\N	\N	\N
7192	19	Кротин Б.С.	\N	(+375 17) 2108196	\N	директор	Устава	\N	\N	в лице директора Кротина Б.С., действующего на основании Устава	\N
7248	39	Кизевич Татьяна	(+375 17) 2186145	(+375 17) 3062032	\N	\N	\N	\N	\N	\N	\N
7302	15	Глушенок О.И.	(+735 172) 1796 32	(+735 172)  1794 92 	\N	\N	\N	\N	\N	\N	\N
7312	33	Бойцов и. Н.	\N	(+375 225) 4331 11	\N	Заместитель начальника ОКО ОАО Белшина	\N	\N	\N	\N	\N
7355	15	иваровский С.Е.	\N	(+375 17) 2172591	\N	Начальник УКК	\N	\N	\N	\N	\N
7382	29	Белецкий Андрей Владимирович	(+375212) 608588	(+375212) 363153, 364284	\N	Главный инженер	Доверенности	\N	(+375 29) 3065052	в лице главного инженера Белецкого А.В., действующего на основании доверенности №1 от 06.01.2011г.	\N
7387	27	Герасимович А.К.	 (+375 17) 3456352	(+375 17) 2430423	\N	\N	\N	\N	\N	\N	\N
7444	15	Петрович Алексей Анатольевич	(+375 17) 2179840	\N	\N	Начальник отдела подшипников и нормалей	\N	\N	\N	\N	\N
7554	15	Меркуль Татьяна Яковлевна	(+375 17) 2179632	(+375 17) 2179492	\N	инженер УМТС	приказа	maz-ozi@yandex.ru	(+375 44) 5765564	\N	\N
7638	15	Афанасьева инна Александровна	(+375 172) 1723 81	(+375 172) 1720 22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
7704	33	Голуб А.Г.	(+375 225) 410192	(+375 225) 438261	\N	\N	\N	golubag@belshina.biz	\N	\N	\N
7825	37	Сивцов Б.В.	(0216) 21 81 50	(0216) 21 81 52	\N	\N	\N	\N	\N	\N	\N
8064	15	Корзун Максим Анатольевич	(+375 17) 2179864	(+375 17) 2179089	\N	\N	\N	\N	\N	\N	\N
8112	33	Загоровский Н.В.	(+375 225) 411494	(+375 225) 433111	\N	Начальник ОКЛ	\N	\N	\N	\N	\N
8151	13	Фонов Владимир Викторович	(+375 17) 240 89 11	(+375 17) 240 03 22	\N	Главный конструктор	\N	niilit@mail.belpak.by	(+375 29) 643 85 19	\N	\N
8164	15	Барабанов Евгений	(+375 17) 2179632	(+375 17) 2179492	\N	Вед. Экономист УЗОиЗЧ	\N	\N	\N	\N	\N
8173	25	Ермоленко Дарья Сергеевна	(+375 2334) 55161	(+375 2334) 56048, 56245	\N	инженер	-	rdc.uko@bmz.gomel.by	\N	\N	\N
8181	15	Макарова Оксана Сергеевна	+(375 17) 2172381	(+375 17) 2172022	\N	\N	\N	\N	+(375 25) 6527710	\N	\N
8212	33	С.М. Шамко	(+375 225) 445158	(+375 225) 410797	\N	И.о. начальника отдела маркетинга закупок	\N	\N	\N	\N	\N
8271	39	Простаков Александр Владимирович	(+375 17) 203 32 02	(+375 17) 218 64 11	\N	\N	\N	duksin@atlant.com.by	(+375 29) 105 22 92	\N	\N
8296	25	Александр	(+375 2334)55425	\N	\N	экономист	\N	\N	(+375 29) 6554024	\N	\N
8303	33	Скридлевский и.И.	(+375 225) 410572	(+375 225) 431348	\N	Начальник и.И.	\N	\N	\N	\N	\N
8308	25	Киселев Александр	(+375 2334) 55464	(+375 2334) 56048	\N	\N	\N	mte.uko@bmz.gomel.by	\N	\N	\N
8309	15	Рябоконь Дмитрий	(+375 17) 2172381 	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	\N
8327	15	Тендерная комиссия	(375 17) 217 23 25	(+375 17) 217 90 89	\N	\N	\N	ugmex@maz.by	\N	\N	\N
8354	21	Романович С.Г.	(+375 174) 212-058	\N	\N	директор	Устава	\N	\N	в лице Директора Романовича С.Г., действующего на основании Устава	\N
8387	15	Вашкалай О.А.	\N	\N	\N	Заместитель директора автобусного завода	\N	\N	\N	\N	\N
8393	15	Зенин Д.Н.	+37517 217 99 00	+37517 217 20 22	\N	\N	\N	import-navesnoe@maz.by	\N	\N	\N
8448	33	Куракина Л.В.	(+375 225) 411870	(+375 225) 411399	\N	\N	\N	\N	\N	\N	\N
8491	15	Алисевич Елена Николаевна	\N	(+375 17) 217-20-22	\N	менеджер	\N	import-engines@maz.by	\N	\N	\N
8519	31	Васильев Денис Владимирович	\N	\N	\N	директор	Устава	\N	\N	\N	1
8629	39	Дмитрий Савчик	(+375 17) 218 61 45	(+375 17) 306 20 32	\N	\N	\N	\N	\N	\N	\N
8645	37	Любимов Олег	(+375 216) 218160	(+375 216) 218161	\N	\N	\N	\N	\N	\N	\N
8726	33	Шинкаренко Маргарита Александровна	(+375 225) 411 628	(+375 225) 43 13 48	\N	инженер	\N	\N	\N	\N	\N
8729	15	Алеся	(+375 17) 217 92 80	\N	\N	\N	\N	\N	\N	\N	\N
8911	15	Чуб А.С.	(+375 17) 217 92 80	(+375 17) 217 20 22	\N	инженер 	\N	import-equip@maz.by	\N	\N	\N
8949	7	Александр Валерьевич	(+375 222) 247992	\N	\N	\N	\N	\N	\N	\N	\N
9037	33	Андрейкин Андрей Николаевич	(+375 225) 411639	(+375 225) 709007	\N	\N	\N	\N	\N	\N	\N
9070	13	Эртман Сергей Александрович	+375 17 340 21 22	+375 17 340 21 22	\N	Главный инженер	Доверенности №376 от 17.04.2013	\N	\N	\N	\N
9093	37	Сазонов Владимир Владимирович.	(+375 216) 218153	(+375 216) 218152	\N	ведущий инженер ОМТС	\N	belsky@krasnyborets.com	(+375 29) 6283571	\N	\N
9094	7	Бовыкин А.Н.	(+375 222) 247992	(+375 222) 247992	\N	\N	\N	ogmksi@yandex.ru	\N	\N	\N
9224	39	Хасеневич Алина	(+375 17) 218 61 45	(+375 17) 306 20 32	\N	\N	\N	bm_sip@atlant.com.by	(+375 29) 179 03 38	\N	\N
9249	25	Комарова Анастасия Александровна	+375 2334 56221	+375 2334 56521	\N	\N	\N	bea.uko@bmz.gomel.by	\N	\N	\N
9256	11	Ефимчик Н.М.	(+375 1794) 37221	(+375 1794) 53089	\N	директор	Устава	\N	\N	\N	\N
9266	31	Васильев Денис Владимирович	\N	\N	\N	директор	Устава	\N	\N	\N	1
9278	33	Поляков К.В.	(+375 225) 410723	(+375 225) 411639	\N	инженер БОММ УКО	\N	polyakovkv@belshina.by	\N	\N	\N
9304	25	Чикилева Н.В.	(+375 2334) 56047	(+375 2334) 55839	\N	\N	\N	energ.okp@bmz.gomel.by	\N	\N	\N
9352	15	Лученок Татьяна Сергеевна	(+375 17) 2172381	(+375 17) 2172022	\N	\N	\N	import-equip@maz.by	\N	\N	\N
9377	39	Коротаев Сергей Александрович	(+375 17) 2033202	\N	\N	\N	\N	\N	(+37529) 3730955	\N	\N
9412	25	Карпенко Алексей Алексеевич	+375 2334 56449	+375 2334 56048	\N	\N	\N	kmt.uko@bmz.gomel.by	\N	\N	\N
9414	25	Суглоб Дмитрий Григорьевич	+375 2334 55462	+375 2334 55919	\N	\N	\N	sug.uko@bmz.gomel.by	\N	\N	\N
9500	37	Шкатуло Владимир иванович 	(+375216) 218123	(+375216) 218123	\N	Главный технолог	\N	\N	\N	\N	\N
9537	25	Белаш Сергей Владимирович	\N	\N	\N	Начальник УКО	\N	\N	\N	\N	\N
9595	25	Данилович С.П.	(02334) 55844	(02334) 56302	\N	инженер УМТС	\N	\N	\N	\N	\N
9641	25	Кветковский Виталий Евгеньевич	(+375 233) 455214	(+375 233) 456048	\N	\N	\N	\N	\N	\N	\N
9685	25	Одинец Марина Михайловна	(+375 2334) 55463	(+375 2334) 55919 	\N	\N	\N	omm.uko@bmz.gomel.by	\N	\N	\N
9698	25	Чернель В.К.	\N	\N	\N	заместитель генерального директора по коммерческим вопросам	доверенности №8/302 от 07.12.2016	\N	\N	\N	\N
9710	15	Дуньчик М.В.	(+375 17) 2172043	(+375 17) 2172022	\N	Начальник УВЭС по импорту	\N	\N	\N	\N	\N
9720	15	Гранковский Александр Александрович	\N	217 97 96	\N	Заместитель генерального директора ОАО "МАЗ" - управляющая компания холдинга "БЕЛ�	действующего на основании доверенности №098-18/105 от 23.01.2018г.	\N	\N	в лице заместителя генерального директора – технического директора Гранковского А.А., действующего на основании доверенности №098-18/105 от 23.01.2018г.	\N
9726	15	ивлев Олег Валерьевич	+375 17 217 20 13	+375 17 217 25 41	\N	Заместитель генерального директора по МТС и К	доверенности	uvk_mtm@maz.by	\N	\N	\N
9732	39	Авсянников Григорий Владимирович	(+375 17) 218 64 11	(+375 17) 203 32 02	\N	\N	\N	\N	(+375 29) 141 78 15	\N	\N
9746	25	Клачков Вячеслав Леонидович	(+375 2334) 54-782	\N	\N	\N	\N	\N	\N	\N	\N
9749	25	Анелькин Николай иванович	(02334) 56013	(02334) 56037	\N	и.о. заместителя ГД по техразвитию - главный инженер	устава	\N	\N	\N	\N
9830	25	Метлушко Д.А.	(+375 233)454604	(+375 233)454604	\N	\N	\N	\N	\N	\N	\N
9841	33	Карпенко Юрий	(+375 225) 41 01 92	(+375 225) 41 07 97	\N	\N	\N	karpenkoyua@belshina.biz	\N	\N	\N
9898	25	Савенок Анатолий Николаевич	\N	\N	\N	Генеральный директор	Устава	\N	\N	\N	\N
9939	25	Козлова и.В.	(02334) 55040	(02334) 31939	\N	инженер УМТС	\N	him.umtc@bmz.gomel.by	\N	\N	\N
10141	25	Дёмкин Тимур Александрович	8-02334-5-59-92	8-02334-5-65-21	\N	\N	\N	dta.uko@bmz.gomel.by	\N	\N	\N
10155	15	Денисов Владимир Васильевич	+375 17 217 20 19	+375 17 217 20 22	\N	Первый заместить зам.генерального директора по МТСиК	\N	\N	\N	\N	\N
10196	35	Аникеева Марина Евгеньевна	\N	\N	\N	Генеральный директор	Устава	\N	\N	\N	\N
10219	7	Моисеенко А.В.	(+375 222) 72 22 89	(+375 222) 72 22 89	\N	\N	\N	ogmksi@yandex.ru	(+375 29) 609 07 59	\N	\N
10222	15	Ковальчук Татьяна Сергеевна	+37517 217 23 81	+37517 217 20 22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
10226	25	Желобкова Алла Александровна	\N	+375(0) 2334 55839	\N	\N	\N	energ.okp@bmz.gomel.by	\N	\N	\N
10230	25	Меньков С.	(+375 2334) 55461	(+375 2334) 56041	\N	инженер	\N	oet.uko@bmz.gomel.by	\N	\N	\N
10271	25	Щукин С.В.	(+375 2334) 54915	(+375 2334) 55839	\N	инженер	\N	\N	\N	\N	\N
10329	15	Констанчук Дмитрий Леонидович	8(017)2179918	\N	\N	\N	\N	2179918@maz.by	\N	\N	\N
10334	15	Тумилович Г.А.	\N	\N	\N	первый заместитель технического директора - главный инженер ОАО "МАЗ" - управляюща	доверенности №098-20/329 от 12.11.2014 г.	\N	\N	\N	\N
10437	15	Тумилович Геннадий Антонович	\N	\N	\N	первый зам.технического директора - главный инженер	\N	\N	\N	\N	\N
10634	33	Карандеев Артем игоревич	(+375 225) 410192	(+375 225) 410797	\N	\N	\N	karandeevai@belshina.by	\N	\N	\N
10655	39	Шиманский Д. С.	\N	\N	\N	\N	\N	\N	\N	\N	1
10656	39	Шиманский Д. С.	(+375 17) 2186145	(+375 17) 3062032	\N	\N	\N	denis.shimansky@atlant.by	(+375 29) 5096744	\N	\N
10702	5	Каранин А.В.	(+375 17) 3870261	(+375 17) 3870259	1	инженер Сервисного центра	доверенность №04-02/6 от 03.01.2022 г.	aleksandr.karanin@lintera.info	(+375 29) 3597715	в лице инженера Сервисного центра Каранина А.В., действующего на основании доверенности №04-02/6 от 03.01.2022 г.	1
10703	5	Байдалов Д.В.	\N	\N	1	заместитель начальника отдела сервисного обслуживания деревообрабатывающего об	доверенность № 04-02/4 от 03.01.2024 г.	\N	\N	в лице заместителя начальника отдела сервисного обслуживания деревообрабатывающего оборудования Байдалова Д.В., действующего на основании доверенности № 04-02/4 от	\N
10707	15	Глинский Сергей Николаевич	(+375 17) 2179498	(+375 17) 2179498	\N	\N	\N	sborka_maz@mail.by	(+375 29) 1706500	\N	\N
10752	15	Никитенок илья	(+375 17) 2179140	\N	\N	 Заместитель главного инженера АСЗ	\N	\N	(+375 29) 3174495	\N	\N
10769	31	Шевченко Константин Васильевич	\N	\N	\N	директор	Устава	\N	\N	\N	1
10854	15	Пишкова Елена Сергеевна	+37517 2179280	+37517 2172022	\N	\N	\N	import-equip@maz.by	\N	\N	\N
10953	39	Круглик ирина	(+375 17)2186492	\N	\N	\N	\N	\N	(+375 29)3118542	\N	\N
11012	15	Колосов А.В	(37517) 217-98-64	217-90-89	\N	\N	\N	\N	\N	\N	\N
11064	15	Язвинский Леонид Брониславович	217-95-09	217-95-09	\N	\N	\N	uvk_amaz@maz.by	\N	\N	\N
11072	25	Литвинко Сергей Александрович	(+375 2334) 56231	(+375 2334) 31324	\N	\N	\N	\N	\N	\N	\N
11099	33	Курс игорь Николаевич     	+375225709421  	+375225709304	\N	\N	\N	kursin@belshina.by	\N	\N	\N
11168	15	Сидоренко А.М.	(+375 17) 2179816	\N	\N	\N	\N	\N	\N	\N	\N
11260	15	Горбачесвкий Кирилл	\N	\N	\N	\N	\N	\N	\N	\N	\N
11274	39	Семашко Юлия Петровна	(+375 17) 203 32 02	(+375 17) 203 32 02	\N	\N	\N	duksin@atlant.com.by	(+375 29) 114 72 54	\N	\N
11299	15	Ермаков Роман Николаевич	(+375 17) 217 21 34	\N	\N	\N	\N	import-component@maz.by	\N	\N	\N
11302	39	Святская Елена Сергеевна	(+375 17) 218 64 11	(+375 17) 203 32 02	\N	экономист по материально-техническому снабжению ОГМ	\N	duksin@atlant.com.by	\N	\N	\N
11347	25	Косиченко Ольга Вячеславовна	(+375 2334) 55460	(+375 2334) 55919	\N	инженер	\N	imp19.uko@bmz.gomel.by	\N	\N	\N
11385	15	Сидоренко Сергей Михайлови	+375-17-217-23-81	+375-17-217-20-22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
11482	15	Титов  и.Е.	(+375 17) 217 93 84	(+375 17) 217 90 89	\N	инженер УГМех	\N	ugmex@maz.by	\N	\N	\N
11508	15	Жилич Сергей Петрович	\N	\N	\N	Директор по качеству	Доверенности №098-17/58	\N	\N	\N	\N
11610	15	Сопелев А.Н.	(+375 222) 72-86-00	(+375 222) 72-89-18	\N	Главный инженер Завода "Могилевтрансмаш" ОАО "МАЗ"	\N	\N	\N	\N	\N
11670	25	иванчиков О.Е.	\N	\N	\N	Зам. начальника управления снабжением	\N	\N	\N	\N	\N
11693	15	Кармазинов игорь Леонидович	\N	\N	\N	Начальник бюро гидропривода	\N	\N	\N	\N	\N
11740	39	Бальвас Геннадий Николаевич	+375172186171 	+375172266052 	\N	руководитель группы по транспортному и вспомогательному оборудованию	\N	kbma@atlant.com.by	+375293784881 	\N	\N
11781	15	Хомякову В.В.	\N	\N	\N	директор	\N	\N	\N	\N	\N
11832	25	Стельмак Анастасия	(+375 2334) 54696	(+375 2334) 55919	\N	инженер	\N	ynf.uko@bmz.gomel.by	\N	\N	\N
11861	15	Андреев Михаил	+375 17 217 22 80	\N	\N	Начальник ЭАСУТП УИТ 	\N	asutp@maz.by	+375 29 154 32 39	\N	\N
11862	25	Анисимова ирина Александровна	\N	\N	\N	\N	\N	\N	\N	\N	\N
11863	25	Анисимова ирина Александровна	+375 2334 5 64 41	+375 2334 5 65 21	\N	\N	\N	amk.uko@bmz.gomel.by	\N	\N	\N
11905	25	Шаповалова Анастасия Олеговна	+375(2334)55462	+375(2334)55919	\N	\N	\N	sug.uko@bmz.gomel.by	\N	\N	\N
11919	25	Шаповалова А.О.	(+375 2334) 55462	(+375 2334) 55919	\N	инженер 	\N	sug.uko@bmz.gomel.by	\N	\N	\N
11964	21	Черевков В.	\N	\N	\N	гл.инженер	\N	\N	\N	\N	\N
11983	39	Муравьев Александр Анатольевич	(+375 17) 2033202	(+375 17) 2033202	\N	инженер по инструменту	\N	duksin@atlant.com.by	(+375 29) 1069548	\N	\N
11990	15	Винокурова Евгения	\N	\N	\N	\N	\N	\N	\N	\N	\N
12017	33	Юрий Закусов	\N	\N	\N	\N	\N	yury.zakusov@gmail.com	\N	\N	\N
12057	15	Станишевская Людмила Васильевна	(37517) 217-23-25	(37517) 217-90-89	\N	\N	\N	uzoizh_bm@maz.by	\N	\N	\N
12058	25	Воробей В.А.	(+375 2334) 55040	(+375 2334) 55040	\N	инженер 	\N	him.umtc@bmz.gomel.by	\N	\N	\N
12059	15	ивлев О.В.	(+375 17) 2179394	(+375 17) 2172022	\N	директора по закупкам	Доверенности № 098-17/244 от 11.07.2017 г.	\N	\N	\N	\N
12176	25	Вартаньян С.Г.	(+375 2334) 56047	(+375 2334) 55839	\N	инженер	\N	\N	\N	\N	\N
12193	33	Татьяна	(+375 225) 410966	 	\N	\N	\N	\N	\N	\N	\N
12201	11	Пилипенко Андрей Анатольевич	+375179453088	\N	\N	Директор	\N	\N	\N	\N	\N
12297	29	Роман	\N	\N	\N	инженер	\N	\N	(+375 44) 537 83 38	\N	\N
12303	33	Дашко Татьяна Аркадьевна	+375225410966	\N	\N	 	 	\N	\N	\N	\N
12310	15	Станислав Петров	+375 17 217 23 81	+375 17 217 20 22	\N	\N	\N	import-equip@maz.by	\N	\N	\N
12311	15	Буйницкая и.В.	+375172179864	+375172179089	\N	\N	\N	ugmex@maz.by	\N	\N	\N
12326	31	Юрий	\N	\N	\N	конструктор	\N	strochelov-y@medin.by	+375297763240	\N	\N
12348	25	Макрушевич В.Э.	\N	+375233456642	\N	Зам. ген. дир. по тех развитию - главный инженер	\N	\N	\N	\N	\N
12361	33	Лукашик В.Ю.	(+ 375 225) 411670	\N	\N	\N	\N	lukashikvyu@belshina.by	\N	\N	\N
12411	33	Каюшников Сергей Николаевич	\N	\N	\N	Первый заместитель генерального директора – главный инженер	доверенности №61 от 03.02.2017г.	\N	\N	\N	\N
12445	15	Коцюра Ольга Михайловна	(+375 17) 2172134	\N	\N	менеджер	\N	\N	\N	\N	\N
12550	5	Азаров В.П.	\N	\N	1	главный инженер - начальник Сервисного центра	доверенности №04-02/2 от 03.01.2024 г.	vladimir.azarov@lintera.info	(+375 29) 6206665	в лице главного инженера - начальника Сервисного центра Азарова В.П., действующего на основании доверенности №04-02/2 от 03.01.2024 г.	\N
12670	15	Пожарицкий Алексей Михайлович	\N	\N	\N	\N	\N	import-engines@maz.by	\N	\N	\N
12695	21	Лукомская ирина	\N	\N	\N	\N	\N	\N	\N	\N	\N
12728	15	Березовская Юлия Сергеевна	(+375 17) 2172208	(+375 17) 2172022	\N	\N	\N	import-chemia@maz.by	\N	\N	\N
12736	25	Волков Андрей Алексеевич	(+375 2334) 55958	(+375 2334) 55839	\N	Заместитель начальника УКО	Доверенности №8/350 от 28.12.2021 г.	av.uko@bmz.gomel.by	\N	\N	\N
12870	25	Науменко А.Ф.	(+375 2334) 55425	(+375 2334) 31324	\N	инженер	\N	riv.umtc@bmz.gomel.by	\N	\N	\N
12883	15	Шапутько Денис Александрович 	217-22-66	\N	\N	\N	\N	uvk_amaz@maz.by	\N	\N	\N
12971	5	Карпович А.Н.	(+375 17) 3870240	(+375 17) 3870250	1	заместитель директора по коммерческим вопросам	доверенности №04-02/1 от 03.01.2024 г.	andrey.karpovich@lintera.info	(+375 44) 7903895 	в лице заместителя директора по коммерческим вопросам Карповича А.Н., действующего на основании доверенности №04-02/1 от 03.01.2024 г.	\N
12972	5	Соболь В.Н.	(+375 17) 3870248	(+375 17) 3870251	1	заместитель директора по техническим вопросам	доверенности №04-02/1 от 03.01.2022 г.	viktor.sobol@lintera.info	(+375 29) 6206663	в лице заместителя директора по техническим вопросам Соболя В.Н., действующего на основании доверенности №04-02/1 от 03.01.2022 г.	1
12983	15	Тыманович Максим А.	+375 17 217 95 41	+37517 217 22 66	\N	\N	\N	\N	\N	\N	\N
13077	25	Власов Михаил Михайлович	(+375 2334) 56861	\N	\N	начальник ЭСПЦ-2 	\N	\N	(+375 29) 6844663	\N	\N
13078	25	Ковалев А.Н. 	(+375 2334) 56876 	\N	\N	механик (ведущий) ЭСПЦ-2	\N	\N	\N	\N	\N
13079	25	Буянов Андрей Михайлович	\N	\N	\N	Зам. начальника ЭСПЦ-2	\N	\N	(+375 44) 5747552 	\N	\N
13080	25	Кишкевич Денис	(+375 2334) 54043	(+375 2334) 55457	\N	Специалист бюро делопроизводства 	\N	tenderbmz@bmz.gomel.by	\N	\N	\N
13199	15	Сакович Андрей Юрьевич	(+375 17) 2179280	(+375 17) 2172009	\N	инженер	\N	import-equip@maz.by	\N	\N	\N
13203	15	Минчинский Д.Г.	(+375 17) 217 98 64	(+375 17) 217 90 89	\N	И.О. Начальника бюро УЗО и ЗЧ	\N	uzoizh_bm@maz.by	\N	\N	\N
13208	15	Бернацкий Денис Александрович	(+375 17) 2172339	(+375 17) 2172339	\N	Заместитель генерального директора ОАО "МАЗ" - управляющая компания холдинга БЕЛА	Доверенности №098-15/26 от 09.01.2025г	\N	\N	\N	\N
13218	15	А.В. Клавсуть                              	\N	\N	\N	\N	\N	uzoizh_bm@maz.by	\N	\N	\N
13309	15	Луценко А.И.	(+375 17) 2179809	(+375 17) 2172339	\N	Заместитель генерального директора ОАО «МАЗ» - управляющая компания холдинга «БЕ	Доверенности № 098-15/70 от 23.01.2019 года	\N	\N	\N	\N
13488	21	Михаленя А.Г.	\N	\N	\N	Главный технолог	\N	\N	\N	\N	\N
14968	31	Казакова Маргарита Петровна	\N	\N	\N	заместитель директора по финансам	Приказа № 179-К от 02.12.2019 г.	\N	\N	\N	\N
13564	15	Клавсуть Алексей Викторович	\N	\N	\N	Первый заместитель технического директора - Главный инженер 	Доверенности № 098-15/31 от 17.01.2019г., 	\N	\N	\N	\N
13614	13	Гетманчук Вадим	(+375 17) 341 09 11	\N	\N	инженер ОМТС	\N	omts2.belniilit@gmail.com	(+375 29) 158 51 85	\N	\N
13632	25	Макарец П.И.	\N	\N	\N	Главный специалист по коммерческим вопросам	доверенности 8/318 от 07.12.2018г.	\N	\N	\N	\N
13636	15	Ерофеева Мария Александровна	\N	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	\N
13652	13	Марушкевич Владимир Эдуардович	\N	\N	\N	Директор	Устава	\N	\N	\N	\N
13765	21	Колодовский Дмитрий Валерьевич 	\N	\N	\N	\N	\N	d.k@niva.by	+375 296 539 634	\N	\N
13903	15	Лисай Д.Н.	+375172179541	\N	\N	\N	\N	\N	\N	\N	\N
13944	15	К.В. Баранов	(+375 17) 2172043	(+375 17) 2172022	\N	Начальник УЗЭ	\N	\N	\N	\N	\N
13958	15	Долгий А.А.	(+375 17) 217 20 19	(+375 17) 217 20 22	\N	Начальник УЗК	\N	\N	\N	\N	\N
13963	25	Гузеева А. А.	(8 2334) 56791	\N	\N	инженер	\N	brk.uko@bmz.gomel.by	\N	\N	\N
13972	39	Коровкин Владимир	(+375 17) 218 61 72	\N	\N	инженер-конструктор	\N	\N	\N	\N	\N
13977	15	Петров Станислав Александрович	(+375 17) 2172381	(+375 17) 2172009	\N	инженер ОМТС	приказа	import-equip@maz.by	\N	\N	\N
14008	25	Масло Л.А.	(+375 2334) 56616	(+375 2334) 56642	\N	инженер по договорам управления организации ремонтов и технической диагностики	\N	\N	\N	\N	\N
14051	37	Шацкий Александр Егорович	\N	\N	\N	Главный инженер	доверенности №5 от 01.01.2020 г. (действует до 31.12.2020 г.)	\N	\N	\N	\N
14053	25	Солохина Людмила	(+375 2334) 56792	(+375 2334) 56792	\N	инженер	\N	slv.uko@bmz.gomel.by	\N	\N	\N
14099	15	Сайчик С.М.	(+375 17) 2172552	(+375 17) 2172552	\N	Начальник УОСиТСА в ДЗ	\N	\N	\N	\N	\N
14124	25	Мартынюк Е.	(+375 2334) 55461	(+375 2334) 55461	\N	инженер	\N	di.uko@bmz.gomel.by	\N	\N	\N
14161	15	Юрасев Сергей	+375 (017) 217 20 19	+375 (017) 217 20 22	\N	Начальник бюро комплектующих	\N	\N	\N	\N	\N
14186	25	Гарбузов А.А.	(+375 2334) 54604 	(+375 2334) 54604 	\N	инженер	\N	lvp.uko@bmz.gomel.by	\N	\N	\N
14354	39	Ярмола Екатерина	\N	\N	\N	специалист по закупкам	\N	\N	\N	\N	\N
14421	33	Шаройко иван Викторович	\N	\N	\N	первый заместитель генерального директора - главный инженер	Доверенности № 441 от 05.11.2018, действует до 05.11.2019	\N	\N	\N	\N
14430	25	Бориков Александр Петрович	\N	\N	\N	заместителя генерального директора по коммерческим вопросам	доверенности №8/427 от 28.12.2023	\N	\N	\N	\N
14473	15	Селихова Юлия	(+375 17) 217 99 18	(+375 17) 217 99 18	\N	инженер УЗО и ЗЧ	\N	maz_s.yulia@maz.by	\N	\N	\N
14486	13	Городецкий Борис ильич	(+375 17) 3408611	\N	\N	инженер-конструктор	\N	\N	\N	\N	\N
14566	25	Спат М.П.	(+375 2334) 5 46 77	(+375 2334) 5 58 39	\N	инженер	\N	ms.uko@bmz.gomel.by	\N	\N	\N
14576	13	Астапчик Татьяна Казимировна	(+375 17) 3410911	(+375 17)  3402122	\N	Начальник бюро материального-технического снабжения, сбыта и кооперации	\N	omts@belniilit.by	(+375 29) 6604087	\N	\N
14617	15	Шевандо Ольга Андреевна	(+375 17) 217 94 84	(+375 17) 217 94 84	\N	\N	\N	\N	\N	\N	\N
14628	15	Морозько Евгения	(+375 17) 217 92 80	(+375 17) 217 20 09	\N	инженер отдела импорта	\N	import-equip@maz.by	\N	\N	\N
14630	21	Щекотович Юрий	(+375 1742) 6 98 56	(+375 1742) 6 98 56	\N	инженер	\N	syn@niva.by	(+375 44) 789 50 85 	\N	\N
14644	15	Алёна Кононович	(+375 17) 217 22 97	\N	\N	Отдел тормозных систем  	\N	\N	\N	\N	\N
14670	15	Захаров Евгений Валерьевич	(+375 17) 2172022	(+375 17) 2172022	\N	Заместитель генерального директора - директор по закупкам	Доверенности № 098-15/45 от 16.01.2023 года	\N	\N	\N	\N
14709	13	Жеваго Павел Александрович	\N	\N	\N	Первый заместитель директора - главный инженер 	Доверенности № 183 от 11.04.2019	\N	\N	\N	\N
14714	39	Брашевец Николай Георгиевич	\N	\N	\N	Зам. генерального директора по техническим вопросам	доверенности №62-38/7777 от 26.06.2023г	\N	\N	в лице Зам. генерального директора по техническим вопросам Брашевца Н.Г., действующего на основании доверенности №62-38/7777 от 26.06.2023г	\N
14737	15	Елизавета Сивец	(+375 017) 217 21 34	(+375 017) 217 98 75	\N	Специалист по ВЭД	\N	\N	\N	\N	\N
14746	39	Король игорь Петрович	\N	\N	\N	Технолог	\N	\N	(+375 44) 7228158	\N	\N
14751	31	Елисеев Андрей Викторович	\N	\N	\N	директор	Устава	\N	\N	\N	\N
14772	33	Дайнеко Дмитрий Николаевич	(+375 225) 410 383	\N	\N	инженер Отдела комплектации	\N	daynekodn@belshina.by	\N	\N	\N
14833	25	Щетникова О.С.	(+375 2334) 56047	(+375 2334) 55839	\N	инженер	\N	mm.uko@bmz.gomel.by	\N	\N	\N
14838	15	Кравченко Александр Александрович	\N	\N	\N	главный инженер	Доверенности №098-15/302 от 25.07.2019 г. (действует до ...)	\N	\N	\N	\N
14839	15	Драпало Ольга	(+375 17) 217 23 81	(+375 17) 217 20 09	\N	инженер Бюро импорта	\N	import-equip@maz.by	\N	\N	\N
14924	15	Петроченко иван Леонидович	(+375 17) 217 99 23	(+375 17) 217 20 22	\N	Заместитель начальника УЗАиТ	\N	\N	\N	\N	\N
14939	35	Троцкин Павел	(+375 29) 744 77 94	\N	\N	инженер	\N	2694869@mail.ru	(+375 29) 744 77 94	\N	\N
14960	31	Карпиевич Александр	\N	\N	\N	инженер конструктор	\N	karpievich@medin.by	(+375 29) 7740483	\N	\N
14961	15	Соловец Александр иванович	\N	\N	\N	Начальник автобусного производства	\N	\N	+375295070299	\N	\N
14965	25	Локтионова А.О.	(+375 2334) 55462	(+375 2334) 55919	\N	инженер	\N	\N	\N	\N	\N
14970	39	Соколовский Д.В.	\N	\N	\N	генеральный директор	Устава	\N	\N	в лице генерального директора Соколовского Д.В., действующего на основании Устава	\N
14976	25	Ходосовский А.В.	(+375 2334) 56449	(+375 2334) 56245	\N	инженер	\N	kmt.uko@bmz.gomel.by	\N	\N	\N
14985	21	Лещёнко Александр Викентьевич	(+375 29) 147 64 95	\N	\N	инженер Филиала "Завод горно-шахтного обрудования"	\N	ogk@niva.by	(+375 29) 147 64 95	\N	\N
15036	5	Косаревский А.В.	(+375 17) 3870260	(+375 17) 3870259	1	начальник отдела сервисного обслуживания деревообрабатывающего оборудования	доверенность № 04-02/3 от 03.01.2024 г.	alexandr.kosarevskiy@lintera.info	(+375 29) 6206922	в лице начальника отдела сервисного обслуживания деревообрабатывающего оборудования Косаревского А.В., действующего на основании доверенности № 04-02/3 от 03.01.2024 г.	\N
15051	37	Черневич Татьяна Андреевна	\N	\N	\N	\N	\N	tatiche@krasnyborets.com	(+375 33) 3070650	\N	\N
15087	37	Бельский Дмитрий	(+375 216) 51 81 50	(+375 216) 51 81 52	\N	инженер	\N	belsky@krasnyborets.com	(+375 29) 5958588	\N	\N
15110	15	Гладун игорь Антониевич	\N	\N	\N	Главный инженер	доверенности №098-15/28 от 09.01.2025г.	\N	\N	\N	\N
15128	37	Крутько Виталий Аркадьевич	\N	\N	\N	Директор	Устава	\N	\N	\N	\N
15176	15	Белов К.В.	(+375 17) 2172298	(+375 17) 2172298	\N	\N	\N	\N	\N	\N	\N
15193	15	Касаткин А.М.	(+375 17) 217 99 23	(+375 17) 217 20 22	\N	Начальник УЗАиТ	\N	\N	\N	\N	\N
15255	15	Жилинский Андрей Леонидович	(+375 17) 2172134	(+375 17) 2179875	\N	\N	\N	\N	\N	\N	\N
15259	15	Зимина Анастасия ивановна	(+375 17) 2179946	(+375 17) 2172022	\N	\N	\N	\N	\N	\N	\N
15322	25	Шамак В.И.	(+375 2334) 54544	(+375 2334) 54544	\N	\N	\N	imp7.ows@bmz.gomel.by	\N	\N	\N
15333	21	Салин Дмитрий Валерьевич	\N	\N	\N	директор филиала УПП "Нива" - "Завод горно-шахтного оборудования"	генеральной доверенности №1 от 08.01.2020	\N	\N	\N	\N
15335	25	Боровикова А.В.	(+375 2334) 55164	\N	\N	инженер	\N	bav.uko@bmz.gomel.by	\N	\N	\N
15360	5	Ширяев Сергей	\N	\N	1	\N	\N	\N	\N	\N	1
15374	29	Ковальков Владимир Владимирович	(+375 212) 608610	\N	\N	Начальник отдела логистики	\N	vistanpostavki@mail.ru	(+375 29)1895768	\N	\N
15375	15	Крумкачева Татьяна	(+375 17) 217 23 81	(+375 17) 217 20 09	\N	инженер	\N	import-equip|@maz.by	\N	\N	\N
15377	29	Новацкий Д.В	(+375-212) 608605	(+375-212) 608607	\N	директор	Устава	vistanpostavki@mail.ru	\N	\N	\N
15426	15	Полещук Максим Павлович	(+375 17) 217 98 64	\N	\N	инженер УЗОиЗЧ	\N	maks.maz9864@gmail.com	\N	\N	\N
15472	37	Кучинский Д.М.	(+375 216) 51 81 50	(+375 216) 51 81 52	\N	инженер ОМТС	\N	belsky@krasnyborets.com	\N	\N	\N
15475	15	Кавалев Андрей Николаевич	(+375 17)  217 21 52	(+375 17)  217 21 52	\N	Начальник УЭКЗ	\N	\N	\N	\N	\N
15496	15	Счастный Перт игоревич	(+375 17) 217 21 14	(+375 17) 217 97 74	\N	\N	\N	\N	\N	\N	\N
15499	15	Ковалев А.Н.	(+375 17) 217 21 52	(+375 17) 217 97 74	\N	Начальник УЭКЗ	\N	\N	\N	\N	\N
15554	37	Мария Антоненко	(+375 216) 518150	(+375 216) 518150	\N	\N	\N	masha.kez@yandex.by	(+375 29) 2930520	\N	\N
15607	39	Ключник Сергей	(+375 17) 2186178	\N	\N	ведущий инженер КБ ТСО 	\N	kbma@atlant.by	(+375 29) 6812403	\N	\N
15612	13	Тендерная комиссия	\N	\N	\N	\N	\N	\N	\N	\N	\N
15624	25	Сакович А.Н.	\N	\N	\N	Заместитель генерального директора по коммерческим вопросам	доверенность №8/310 от 28.12.2020 	\N	\N	\N	\N
15683	15	Сечко Екатерина	(+375 17) 217 92 80	(+375 17) 217 20 09	\N	инженер	\N	import-equip@maz.by	\N	\N	\N
15686	37	Дервоед Е.М.	(+375 216) 518153	(+375 216) 218142	\N	Заместитель начальника ОМТС	\N	\N	belsky@krasnyborets.com	\N	\N
15698	15	Махомет Анастасия Викторовна	\N	\N	\N	\N	\N	\N	\N	\N	\N
15700	15	Козлова Мария Андреевна	\N	\N	\N	\N	\N	\N	\N	\N	\N
15716	15	Сивец Елизавета Сергеевна	(+375 17) 217 99 46	(+375 17) 217 25 41	\N	\N	\N	\N	\N	\N	\N
15807	25	Подольская В.	(+375 2334) 56636	(+375 2334) 31939	\N	инженер	\N	ekon.umtc@bmz.gomel.by	\N	\N	\N
15853	15	Дергай Анастасия Александровна	(+375 17) 2172297	\N	\N	Специалист по ВЭД	\N	import-navesnoe@maz.by	(+375 44) 5623701	\N	\N
15858	25	Бажан Елена Олеговна	(+375 2334) 5 51 45	\N	\N	инженер МТБ УКО	Доверенности № 8/335 от 02.09.2022	emto.uko@bmz.gomel.by	\N	\N	\N
15902	15	Коротчикова Анастасия Михайловна	(+375 017) 217 99 46	(+375 017) 217 99 46	\N	Начальник отдела импорта по обеспечению завода "Могилёвтрансмаш"	\N	\N	\N	\N	\N
15935	39	Мурашко Марина Александровна	(+375 17) 2033202	(+375 17) 2033202	\N	Специалист по закупкам 2 категории	\N	murashkoma@atlant.by	\N	\N	\N
16015	15	Егор Моисеев	+375 17 217 20 09	\N	\N	Экономист по снабжению	\N	import-equip@maz.by	\N	\N	\N
16016	21	Булва А.А.	\N	\N	\N	Зам.директора по качеству	\N	\N	\N	\N	\N
16195	25	Зубченко А.О.	(+375 2334) 55462	(+375 2334) 55919	\N	инженер	\N	sug.uko@bmz.gomel.by	\N	\N	\N
16439	7	Скребунов Денис Анатольевич	(+375 222) 72 22 89	(+375 222) 72 22 89	\N	Ведущий инженер-механик	\N	ogmksi@yandex.ru	(+375 44) 74956 28	\N	\N
16474	25	Филипцова Алена Валерьевна	(+375 2334) 5 54 62	(+375 2334) 5 59 19	\N	инженер энергетического бюро УКО	\N	sug.uko@bmz.gomel.by	\N	\N	\N
16516	25	Филипцова Алена Валерьевна	(+375 2334) 5 54 62	(+375 2334) 5 59 19	\N	инженер энергетического бюро Управления комплектации оборудования	\N	sug.uko@bmz.gomel.by	\N	\N	\N
16570	15	Неборако Александр Андреевич	+375 17 217 20 08	+375 17 217 20 08	\N	\N	\N	\N	\N	\N	\N
16592	25	Морозова Татьяна	(+375 2334) 5 46 77	(+375 2334) 5 58 39	\N	инженер	\N	ms.uko@bmz.gomel.by	\N	\N	\N
16645	25	Лысенко инна Николаевна	\N	\N	\N	Начальник Управления комплектации оборудования	Доверенности № 8/377 от 26.12.2023 ( действует с 01.01.2024 по 31.12.2026)	\N	\N	\N	\N
16702	15	Кондратович Елизавета Андреевна	(+375 17) 2172019	(+375 17) 2172297	\N	Специалист по ВЭД, Управление внешнеэкономических связей по импорту	\N	import-component@maz.by	\N	\N	\N
16722	15	Алейник Анастасия	(+375 17) 2179864	(+375 17) 2179089\t	\N	УЗОиЗЧ	\N	uzoizh_bm@maz.by	\N	\N	\N
16730	25	Вдовиченко ирина Александровна	(+375 2334) 5 54 62	(+375 2334) 5 54 62	\N	инженер УКО	\N	sug.uko@bmz.gomel.by	\N	\N	\N
16766	15	Екатерина	\N	\N	\N	\N	\N	\N	\N	\N	\N
16807	39	Кадушко Евгений	(+375 17) 2186411	\N	\N	Экономист по МТС	\N	evgeny.kadushko@atlant.by	\N	\N	\N
16823	15	Слабко Александр Владимирович	(+375 17) 2172152	(+375 17) 2172152	\N	\N	\N	uakz@maz.by	\N	\N	\N
16849	25	Пекурина Жанна	(+375 2334) 5 57 32	(+375 2334) 5 57 32	\N	инженер по проектно-сметной работе Управления проектирования и реконструкции	\N	eps3.upir@bmz.gomel.by	\N	\N	\N
16875	25	Пономарев Александр иванович	\N	\N	\N	инженер ОГМ	\N	tech.ogm@bmz.gomel.by	\N	\N	\N
16910	25	Ахременко Анастасия Валерьевна	(+375 2334) 5 59 58	(+375 2334) 5 59 19	\N	инженер энергетического отдела УКО	\N	av.uko@bmz.gomel.by	\N	\N	\N
16960	15	Апанович Надежда Михайловна	(+375 17) 2179280	\N	\N	\N	\N	import-equip@maz.by	\N	\N	\N
17037	15	Фоменков П.В.	(+375 17) 2172019	(+375 17) 2172019	\N	Начальник УВЭС по импорту	\N	\N	\N	\N	\N
17044	15	Лущик Полина Сергеевна	+375172179923	+375172179923	\N	\N	\N	\N	\N	\N	\N
17050	25	Шинкарева Анастасия	(+375 2334) 5 65 21	(+375 2334) 5 65 21	\N	инденер Электротехнического отдела Управления комплектации оборудования	\N	imp7.ows@bmz.gomel.by	\N	\N	\N
17051	15	Голодковский Николай	(+375 17) 217 97 89	(+375 17) 217 97 89	\N	инженер Бюро маркетинга	\N	uzoizh_bm@maz.by	\N	\N	\N
17067	25	Лимонова Татьяна Викторовна	+375 2334 55189	\N	\N	Тендерная комиссия	\N	eng1.uortd@bmz.gomel.by	\N	\N	\N
17141	39	Харитончик Дмитрий иванович	\N	\N	\N	генеральный директор	Устава	\N	\N	\N	\N
17186	39	Бурнос Марина	+375172186120	\N	\N	\N	\N	marina.burnos@atlant.by	+375296677953	\N	\N
17187	15	Разумейко Анастасия Юрьевна	 +(375)17 217 99 46	\N	\N	отдел импорта	\N	\N	\N	\N	\N
17192	31	Ярмольчик Жанна ивановна	\N	\N	\N	Заместитель директора по маркетингу	Доверенности № 1 от 03.01.2024 (действует до 31.12.2024)	\N	\N	\N	\N
17211	39	Шалковский Дмитрий Эдуардович	\N	\N	\N	Заместитель генерального директора по техническому обеспечению	Доверенности №62-38/13093 от 10.10.2025г	\N	\N	\N	\N
17357	15	Лавринович Елена Анатольевна	(+375 17) 2172019	(+375 17) 2172019	\N	\N	\N	\N	\N	\N	\N
17389	15	Гурченкова Елизавета Александровна	+375(17) 217 99 46 	+375(17) 217 99 46 	\N	\N	\N	\N	\N	\N	\N
17425	15	Наталья Романовская	(+375 17) 2172098	(+375 17) 2179774	\N	Ведущий специалист	\N	uakz@maz.by	\N	\N	\N
17446	25	Коваль Наталья Романовна	(+375 2334) 55 9 58	(+375 2334) 55 9 19	\N	инженер энергетического отдела Управления комплектации оборудования	\N	av.uko@bmz.gomel.by	\N	\N	\N
17455	15	Козик О.А.	(+375 17) 2172019	(+375 17) 2172019	\N	Зам. начальника УВЭС по импорту - начальник отдела	\N	\N	\N	\N	\N
17458	15	Бернацкий Денис Александрович	(+375 17) 2172525; (+375 17) 2179634	(+375 17) 2172363	\N	Заместитель генерального директора ОАО "МАЗ" — управляющая компания холдинга "БЕ�	приказа	\N	\N	\N	\N
17461	15	Рымар Александр	(+375 17) 217 98 64	(+375 17) 217 90 89	\N	инженер БМ УЗОИЗЧ	\N	uzoizh_bm@maz.by	\N	\N	\N
17484	15	Мороз Александр Владимирович	(+375 17) 2179774	\N	\N	Начальник управления по эффективности качества закупок	приказа	uakz@maz.by	\N	\N	\N
17569	25	Тараева Татьяна Михайловна	(+375 2334) 5 46 77	(+375 2334) 5 46 77	\N	инженер Управления комплектации оборудования	\N	ms.uko@bmz.gomel.by	\N	\N	\N
17641	31	Повпе Сергей Владимирович	(+375 17) 543 196 21	(+375 17) 543 19 22	\N	гшлавный конструктор	\N	povpe@medin.by	(+375 29) 620 32 71	\N	\N
\.


--
-- Data for Name: dcl_contact_person_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contact_person_user (cps_id, usr_id) FROM stdin;
\.


--
-- Data for Name: dcl_contract; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contract (con_id, con_create_date, usr_id_create, con_edit_date, usr_id_edit, con_number, con_date, ctr_id, cur_id, con_executed, con_summ, con_original, con_annul, con_annul_date, con_comment, sln_id, con_reusable, con_final_date) FROM stdin;
\.


--
-- Data for Name: dcl_contract_closed; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contract_closed (ctc_id, ctc_create_date, usr_id_create, ctc_edit_date, usr_id_edit, ctc_number, ctc_date, ctc_block) FROM stdin;
\.


--
-- Data for Name: dcl_contractor; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contractor (ctr_id, ctr_name, ctr_email, ctr_bank_props, ctr_unp, ctr_full_name, ctr_block, ctr_create_date, usr_id_create, ctr_edit_date, usr_id_edit, rpt_id, ctr_okpo, ctr_phone, ctr_fax, ctr_double_account, cut_id, ctr_index, ctr_region, ctr_place, ctr_street, ctr_building, ctr_add_info, ctr_comment) FROM stdin;
1	Линтера ЗАО	jonava@lintera.info	\N	LT566098412	ЗАО "ЛИНТЕРА"	1	\N	\N	2026-01-19 13:55:21	\N	5	\N	(+370 349) 61161	(+370 349) 61297	\N	16	\N	\N	\N	\N	\N	Литовская Республика 55101, г. Йонава, ул.Укмергес, 22	\N
3	Линтера Представительство	minsk@lintera.info	ОАО "Технобанк", 220002, г. Минск, ул. Кропоткина, 44, код 182	101569012	ПРЕДСТАВИТЕЛЬСТВО ЗАО “ЛИНТЕРА” В РБ	1	\N	\N	2026-01-19 13:55:21	\N	3	\N	\N	\N	\N	27	\N	\N	\N	\N	\N	220030, г. Минск, ул.Энгельса, 34а-306	\N
5	Линтера ТехСервис	minsk@lintera.info	ОАО "Технобанк", 220002, г. Минск, ул. Кропоткина, 44, SWIFT TECNBY22	800014037	Общество с ограниченной ответственностью “Линтера ТехСервис”	\N	\N	\N	2026-01-19 13:31:39	\N	5	\N	(+375 17) 3870240	(+375 17) 3870250	\N	27	\N	\N	\N	\N	\N	220118, г. Минск, ул. Машиностроителей, 29, пом. 103	\N
7	Могилёвский комбинат силикатных изделий (МКСИ)	ogmksi@yandex.ru	Р/счет BY76BPSB30121194350169330000 в Региональной  Дирекции №600 ОАО «БПС-Cбербанк» г.Могилев ,  БИК  BPSBBY2X.\r\r\nОКОНХ-16151 Код предприятия на ЖД-5224, Код станции-156609, Станция Могилев-1. 	700008113	Закрытое акционерное общество "Могилёвский комбинат силикатных изделий"	\N	\N	\N	2026-01-19 13:55:21	\N	3	002948757000	(+375 222) 72 22 89	(+375 222) 72 22 89	\N	27	212030	\N	 г.Могилёв	ул.Крупской	224	\N	\N
9	ТЕХНОСОЮЗПРОЕКТ	skb3@tspbel.com	\N	\N	ООО "ТЕХНОСОЮЗПРОЕКТ"	\N	\N	\N	2026-01-19 13:31:39	\N	3	\N	\N	\N	\N	27	\N	\N	\N	\N	\N	220114, Республика Беларусь, г.Минск, пр-т Скорины 115-307	\N
11	Любанский КСМ	lubanksm@lubanksm.belpak.minsk.by	в ОАО "Приорбанк" \r\r\nЦБУ 104 г.Солигорск, ул. Богомолова, 16ВА\r\r\nкод 153001749	600026013	ОАО "Любанский комбинат строительных материалов"	\N	\N	\N	2026-01-19 13:31:39	\N	3	05896053	(8-01794) 37-2-21	(8-01794) 53-0-89	\N	27	\N	\N	\N	\N	\N	223839, п/о Смольгово, Любанский р-н,  Минская обл., Республика Беларусь.	\N
13	БЕЛНИИЛИТ	omts.belniilit@gmail.com	р/с  BY53PJCB30120567131000000933 \r\r\n «Приорбанк» ОАО ЦБУ 100\r\r\nг.Минск, ул.Радиальная, 38а\r\r\nБИК PJCBBY2X\r\r\n	100023492	ОАО «БЕЛНИИЛИТ»	\N	\N	\N	2026-01-19 13:55:21	\N	3	002348505000	(+375 17) 340-21-22	(+375 17) 340-21-22	\N	27	220118	\N	 г.Минск	 ул.Машиностроителей	28	корпус 2, пом.13	\N
15	МАЗ	office@maz.by	в Филиале №511 АСБ «Беларусбанк», г.Минск, ул.Долгобродская,1    \r\r\nУНП 100349858\r\r\nБИК АКBBBY21511\r\r\n	100320487	ОАО "МАЗ"- управляющая компания холдинга "БЕЛАВТОМАЗ"	\N	\N	\N	2026-01-19 13:55:21	\N	5	0580729	+375 17 217 98 09	+375 17 217 23 39	\N	27	220021	\N	г.Минск	ул.Социалистическая	2	\N	\N
17	Акваснаб	akvasnab@mail.ru	\N	\N	ЧУПП "Акваснаб"	\N	\N	\N	2026-01-19 13:31:39	\N	3	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	г.Могилев, ул.Первомайская,20	\N
19	Леор Пластик	root@leor.by	в филиале ОАО "БелГазПромБанк", г. Гродно, ул. Калиновского, 63а, код 194, ОКПО 28813740	500301707	СП "Леор Пластик"	\N	\N	\N	2026-01-19 13:31:39	\N	3	\N	(+375 1597) 245 48	(+375 1721) 081 96	\N	27	\N	\N	\N	\N	\N	г. Новогрудок, ул. Свердлова, 38а	\N
21	НИВА УПП	uppniva@mail.ru	в ЦБУ №633 ОАО СБ "Беларусбанк", БИК AKBBBY2Х, г.Солигорск, ул. Козлова, 23а	600320994	УПП "Нива" Романовича С.Г.	\N	\N	\N	2026-01-19 13:55:21	\N	3	06086592	+375 (174) 212-058	+375 (174) 212-058                                                                                  	1	27	223710	Минская обл	Солигорский район	Метявичское шоссе	5/2	\N	\N
23	ЛИДАГРОПРОММАШ РУП	\N	   	500012183	ЛИДАГРОПРОММАШ РУП	\N	\N	\N	2026-01-19 13:55:21	\N	3	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	231300, Республика Беларусь, Гродненская обл., г.Лида, ул.игнатова, 52	\N
25	БМЗ – управляющая компания холдинга «БМК»	ofwork@bmz.gomel.by	Банк: ОАО "АСБ Беларусбанк",220089, Республика Беларусь, г.Минск, проспект.Дзержинского, 18\r\r\nУНП 100325912   \r\r\nSWIFT: AKBBBY2X	400074854	Открытое акционерное общество «Белорусский металлургический завод - управляющая компания холдинга «Белорусская металлургическая компания»	\N	\N	\N	2026-01-19 13:31:38	\N	2	04778771	(+ 375 233) 4548 21 	(+ 375 233) 4247 05                                                                                 	\N	27	247210	Гомельская обл.	г. Жлобин	ул. Промышленная	37	\N	\N
27	БМЕ-Дизель	bme@sml.by	ЗАО «Банк «Решение» г. Минск, ул. игнатенко, 11\r\r\nBIC: RSHNBY2X	808000755	ООО "БМЕ-Дизель"	\N	\N	\N	2026-01-19 13:55:21	\N	3	37533961	+375 17 55-55-285	+375 17 762-44-61	\N	27	\N	\N	\N	\N	\N	222223, Минская обл., Смолевичский р-н, д. Станок-Водица, ул. Заводская, 1	\N
29	ВИСТАН	info@vistan.ru	Дирекция ОАО «Белинвестбанк» по Витебской обл. \r\r\nБИК BLBBBY2X  \r\r\nАдрес банка: г.Витебск ,ул.Ленина, 22/16\r\r\n	300029332	ОАО "Вистан"	\N	\N	\N	2026-01-19 13:55:21	\N	3	058297952000	(+375 212) 608610	(+375 212) 608605	\N	27	210627	\N	\N	\N	\N	г.Витебск, ул.Дмитрова, 36/7	\N
31	Мединдустрия Сервис	'reut@medin.by'	ОАО «Банк Дабрабыт», г. Минск, ул. Коммунистическая, 49\r\r\nBIC (SWIFT)-MMBNBY22	800003039	Общество с ограниченной ответственностью "Мединдустрия Сервис"	\N	\N	\N	2026-01-19 15:59:14	\N	3	37614464	(+375 17) 504 85 27	(+375 17) 504 85 27	1	27	223043	Минский р-н, Папернянский с/	район д. Дубовляны	Производственная база ООО "	\N	каб. 35	\N
33	Белшина	belshina@belshyna.by	в филиале №703 ОАО "AСБ Беларусбанк»,  \r\r\nкод 760, г. Бобруйск, ул. Горького, 2 \r\r\nБИК: АКВВ BY 21703	700016217	ОАО "Белшина"	\N	\N	\N	2026-01-19 16:12:04	\N	3	147621337000	(+ 375 225) 70 90 07	(+ 375 225) 70 90 07	\N	27	213824	 Могилевская обл.	г.Бобруйск	Минское шоссе	д. 4	\N	\N
35	Молочный мир	gmk@tut.by	в ф-ле ОАО "Белгазпромбанк" - ГОУ, код 457, ул. С.Пограничников, 110	500040357	пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅР”	\N	\N	\N	2026-01-29 11:44:56	\N	3	\N	(+375 152) 430172	(+375 152) 430172	\N	27	\N	\N	\N	\N	\N	230005, г. Гродно. ул. Горького, 93	\N
37	Красный борец	borets@vitebsk.by	При расчетах в белорусских рублях:\r\r\n1) IBAN (№ счета) BY63BPSB30121177690169330000, \r\r\nОАО «БПС-Сбербанк», БИК BPSBBY2X\r\r\n2) IBAN (№ счета) № BY23AKBB30120351500092200000 ОАО «АСБ Беларусбанк», БИК AKBBBY2X \r\r\n3) IBAN (№ счета) BY50BAPB30124031400120000000, ОАО «Белагропромбанк», БИК BAPBBY2X\r\r\n\r\r\n\t\t\r\r\n\t\t\t\r\r\n	300053207	Открытое акционерное общество Оршанский станкостроительный завод  "Красный борец"	\N	\N	\N	2026-01-19 13:55:21	\N	3	055445322000	(+375 216) 518152	(+375 216) 518144	\N	27	211391	Витебская обл.	г. Орша	ул. Фридриха Энгельса	29	\N	\N
39	АТЛАНТ ЗАО	\N	IBAN: BY43AKBB30128000001395100000  \r\r\nОАО «АСБ Беларусбанк» \r\r\nSWIFT : AKBBBY2X\r\r\nДзержинского пр-т 18, Минск\r\r\n220089, Республика Беларусь\r\r\n\r\r\nБанк-корреспондент:\r\r\nCommerzbank AG, Франкфурт-на-Майне, Германия\r\r\nасс.400886596600EUR\r\r\nSWIFT:COBADEFF	100010198	ЗАО "АТЛАНТ" 	\N	\N	\N	2026-01-19 13:31:39	\N	3	00243352	(+375 17) 218 62 22 	(+375 17) 203 96 97	\N	27	\N	\N	\N	\N	\N	пр. Победителей, 61, г.Минск, 220035, Республика Беларусь 	\N
\.


--
-- Data for Name: dcl_contractor_request; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contractor_request (crq_id, crq_create_date, usr_id_create, crq_edit_date, usr_id_edit, crq_receive_date, ctr_id, cps_id, crq_request_type_id, con_id, lps_id, prd_id, crq_number, crq_deliver, usr_id_manager, usr_id_chief, usr_id_specialist, crq_city, ctr_id_other, crq_no_contract, stf_id, crq_serial_num, crq_year_out, crq_enter_in_use_date, crq_annul, crq_ticket_number, sln_id, crq_comment, crq_operating_time, con_id_for_work) FROM stdin;
\.


--
-- Data for Name: dcl_contractor_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_contractor_user (ctr_id, usr_id) FROM stdin;
1	4
3	162
5	1
5	9
5	19
5	21
5	38
5	66
5	106
5	110
5	123
5	142
5	143
5	148
5	162
5	164
5	193
5	206
5	211
5	222
7	9
7	21
7	60
11	19
11	82
11	164
13	9
13	10
13	60
13	119
13	130
13	206
15	1
15	9
15	11
15	21
15	60
15	82
15	106
15	110
15	119
15	122
15	123
15	130
15	138
15	139
15	142
15	161
15	169
15	191
15	193
15	206
15	210
15	211
15	215
19	9
19	123
21	9
21	82
21	123
21	206
21	211
25	9
25	19
25	110
25	193
25	206
25	211
27	11
27	38
27	123
27	193
29	142
29	206
31	9
31	11
31	38
31	142
31	143
31	193
31	206
33	9
33	82
33	106
33	110
33	122
33	139
33	161
33	169
33	191
33	193
33	196
33	206
33	210
33	211
35	9
35	161
37	9
37	110
37	138
37	161
37	206
37	211
39	9
39	21
39	60
39	82
39	106
39	110
39	122
39	139
39	161
39	169
39	185
39	191
39	196
39	206
39	210
39	211
39	214
\.


--
-- Data for Name: dcl_country; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_country (cut_id, cut_create_date, usr_id_create, cut_edit_date, usr_id_edit, cut_name) FROM stdin;
3	2009-10-16 08:51:13	60	2026-01-20 13:48:06	1	Германия
4	2009-10-20 15:17:07	60	2026-01-20 13:48:06	1	�?талия
6	2009-11-02 13:03:09	104	2026-01-20 13:48:06	1	США
7	2009-11-09 15:21:35	17	2026-01-20 13:48:06	1	Сербия
8	2009-11-10 08:31:43	104	2026-01-20 13:48:06	1	Тайвань
9	2009-11-16 08:31:04	116	2026-01-20 13:48:06	1	Нидерланды
10	2009-11-16 08:58:13	11	2026-01-20 13:48:06	1	Болгария
11	2009-11-18 11:22:51	26	2026-01-20 13:48:06	1	Словакия
13	2009-11-25 14:41:27	82	2026-01-20 13:48:06	1	Швеция
14	2009-12-07 14:44:35	62	2026-01-20 13:48:06	1	Франция
16	2009-12-15 10:14:27	60	2026-01-20 13:48:06	1	Литва
17	2009-12-21 13:46:19	60	2026-01-20 13:48:06	1	Австрия
19	2009-12-23 14:07:08	17	2026-01-20 13:48:06	1	Польша
20	2010-01-11 11:10:08	50	2026-01-20 13:48:06	1	�?спания
21	2010-01-26 13:40:59	9	2026-01-20 13:48:06	1	Финляндия
22	2010-01-26 13:42:27	9	2026-01-20 13:48:06	1	Чехия
23	2010-02-08 10:10:06	1	2026-01-20 13:48:06	1	Великобритания
24	2010-02-12 15:19:53	26	2026-01-20 13:48:06	1	Венгрия
25	2010-02-19 14:24:31	21	2026-01-20 13:48:06	1	Новая Зеландия
26	2010-03-12 16:14:18	9	2026-01-20 13:48:06	1	Бельгия
27	2010-04-05 08:20:26	28	2026-01-20 13:48:06	1	Беларусь
28	2010-04-06 09:00:12	26	2026-01-20 13:48:06	1	Канада
29	2010-05-27 08:36:09	62	2026-01-20 13:48:06	1	Эстония
30	2010-07-02 15:36:00	139	2026-01-20 13:48:06	1	Япония
31	2010-07-07 09:18:53	28	2026-01-20 13:48:06	1	�?ран
32	2010-07-21 14:38:39	123	2026-01-20 13:48:06	1	Пакистан
34	2010-09-27 18:16:53	60	2026-01-20 13:48:06	1	Китай
35	2010-10-06 13:46:08	62	2026-01-20 13:48:06	1	Турция
36	2010-10-27 15:04:20	119	2026-01-20 13:48:06	1	Швейцария
37	2010-11-30 08:51:35	148	2026-01-20 13:48:06	1	Дания
38	2011-01-12 13:46:54	62	2026-01-20 13:48:06	1	Казахстан
39	2011-03-17 15:14:33	123	2026-01-20 13:48:06	1	Румыния
40	2011-04-19 10:06:24	26	2026-01-20 13:48:06	1	Украина
41	2011-08-17 08:14:44	26	2026-01-20 13:48:06	1	Бразилия
42	2011-11-28 16:51:03	62	2026-01-20 13:48:06	1	Словения
43	2012-07-20 15:05:24	62	2026-01-20 13:48:06	1	Кипр
44	2012-09-13 10:29:07	62	2026-01-20 13:48:06	1	ОАЭ
45	2012-09-19 12:14:53	11	2026-01-20 13:48:06	1	Босния и Герцеговина
48	2012-12-18 09:01:35	175	2026-01-20 13:48:06	1	Латвия
49	2013-01-17 11:13:52	60	2026-01-20 13:48:06	1	Россия
50	2013-11-22 10:37:15	177	2026-01-20 13:48:06	1	Норвегия
51	2014-01-20 11:08:46	151	2026-01-20 13:48:06	1	Лихтенштейн 
52	2014-09-30 14:30:28	191	2026-01-20 13:48:06	1	Молдова
55	2014-11-10 08:47:47	11	2026-01-20 13:48:06	1	Армения
56	2014-11-13 15:51:37	123	2026-01-20 13:48:06	1	Гонконг
57	2015-05-15 14:31:44	11	2026-01-20 13:48:06	1	Кыргызская Республика
58	2016-01-12 15:52:31	123	2026-01-20 13:48:06	1	�?рландия
59	2016-06-20 12:03:53	206	2026-01-20 13:48:06	1	Объединенные Арабские Эмир
60	2016-12-05 15:36:30	142	2026-01-20 13:48:06	1	Панама
61	2017-01-30 14:47:26	193	2026-01-20 13:48:06	1	Азербайджан
62	2022-04-27 11:22:15	82	2026-01-20 13:48:06	1	ОАЭ
63	2022-05-10 09:09:38	21	2026-01-20 13:48:06	1	Узбекистан
64	2022-05-20 10:23:13	21	2026-01-20 13:48:06	1	Сингапур
65	2022-10-14 16:15:01	142	2026-01-20 13:48:06	1	Монголия
66	2022-12-02 08:44:58	19	2026-01-20 13:48:06	1	Корея
67	2022-12-02 08:45:56	19	2026-01-20 13:48:06	1	Южная Корея
68	2024-07-02 14:42:00	19	2026-01-20 13:48:06	1	Тайланд
\.


--
-- Data for Name: dcl_cpr_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cpr_list_produce (lpr_id, cpr_id, lpr_produce_name, lpr_price_netto, lpr_count, cus_id, lpr_coeficient, lpr_catalog_num, stf_id, prd_id, lpr_comment, lpc_id, lpr_sale_price, lpr_sale_cost_parking_trans, lpr_price_brutto, lpr_discount) FROM stdin;
\.


--
-- Data for Name: dcl_cpr_transport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cpr_transport (trn_id, cpr_id, stf_id, trn_sum) FROM stdin;
\.


--
-- Data for Name: dcl_crq_ord_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_crq_ord_link (crq_id, ord_id) FROM stdin;
\.


--
-- Data for Name: dcl_crq_print; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_crq_print (crp_id, crq_id, crp_reclamation_date, crp_lintera_request_date, crp_no_defect_act, crp_lintera_agreement_date, crp_deliver, crp_no_reclamation_act) FROM stdin;
\.


--
-- Data for Name: dcl_crq_stage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_crq_stage (crs_id, crq_id, crs_name, crs_comment, crs_print) FROM stdin;
\.


--
-- Data for Name: dcl_ctc_list; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ctc_list (lcc_id, ctc_id, spc_id, lcc_charges, lcc_montage, lcc_transport, lcc_update_sum) FROM stdin;
\.


--
-- Data for Name: dcl_ctc_pay; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ctc_pay (lcc_id, lps_id) FROM stdin;
\.


--
-- Data for Name: dcl_ctc_shp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ctc_shp (lcc_id, shp_id) FROM stdin;
\.


--
-- Data for Name: dcl_currency; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_currency (cur_id, cur_name, cur_no_round, cur_sort_order) FROM stdin;
1	BYR	\N	\N
2	EUR	1	\N
3	USD	1	\N
5	LTL	1	\N
6	LVL	1	\N
7	RUB	1	\N
8	JPY	1	\N
9	GBP	1	\N
10	CHF	1	\N
11	SEK	1	\N
12	PLN	1	\N
13	BYN	1	1
14	CNY	1	\N
15	KZT	1	\N
\.


--
-- Data for Name: dcl_currency_rate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_currency_rate (crt_id, cur_id, crt_date, crt_rate) FROM stdin;
1	2	2009-08-24	4056.930000
2	2	2009-08-25	4043.180000
3	2	2009-08-26	4036.690000
4	3	2009-08-26	2828.000000
5	3	2009-08-25	2827.000000
6	3	2009-08-24	2839.000000
\.


--
-- Data for Name: dcl_cus_code_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_cus_code_history (id, prd_id, cus_code, date_created) FROM stdin;
\.


--
-- Data for Name: dcl_custom_code; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_custom_code (cus_id, cus_code, cus_description, cus_percent, cus_instant, cus_create_date, cus_id_create, cus_edit_date, cus_id_edit, usr_create_date, usr_id_create, usr_edit_date, usr_id_edit, cus_law_240_flag, cus_block) FROM stdin;
1	4911101000	Каталог товарный	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
2	4911101000	Каталог товарный	15.00	2006-03-23 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
7	8466928000	Автоподатчик, датчик для установки положения ножа (для рейсмусн. станка), корпус (запчасть к деревообрабат. станку), конвейер ленточный к кромкооблиц. станку, линейка направл. (часть деревообраб. станка), податчик (части к фрезерному станку), ролик поперечн. рамки, нитеводите�	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	8413502000	Агрегаты гидравлические (насосы объемн. возвратно-поступательн. прочие; гидравлические станции)	0.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	8466928000	Автоподатчик, датчик для установки положения ножа (для рейсмусн. станка), корпус (запчасть к деревообрабат. станку), конвейер ленточный к кромкооблиц. станку, линейка направл. (часть деревообраб. станка), податчик (части к фрезерному станку), ролик поперечн. рамки, нитеводите�	5.00	2006-03-23 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
11	7326909809	Балансир, втулка, переходник, задвижка, заслонка, сердечник промеж. холодильника, скоба, удлинитель (вал), шайба-дроссель, шнек, переходник (для рейсм. станка), пластина твердосплавная, плита для монтажа гидроаппаратов, поршень, зажим для патрубка, корпус клапана, кольца порш�	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
14	8412904008	Блок аккумуляторный, проушина (прочие части гидравл. силовых установок и двигателей), поршень статор (часть гидравлического двигателя), пластина внешняя для гидромотора, корпус тормоза для гидромотора, блок цилиндров	10.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	8466940000	Втулка переходная (для металлообрабатывающих станков), блок инструментальный, корпус револьверной головки 8-ми позиционный (проч. приспособления к станкам  для обработки металлов), мембрана силиконовая	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	8481101909	Блок подготовки воздуха (проч. чугун./стальн. литые клапаны редукцион. для регулировки давления)	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
17	8481100500	Блок подготовки воздуха с фильтром (клапаны редукционные для регулировки давления), фильтр-регулятор, маслораспылитель	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	7318156900	Винт из черных металлов (с внутренним шестигранником)	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	6805200000	Бумага шлифовальная (природн./искусствен. абразивн. порошок или зерно только на бум./картон. основе), лента шлифовальная для шлифмашинки	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	8483102909	Вал (валы трансмиссионные (включая кулачковые и коленчатые) и кривошипы стальные кованые)	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	8466930000	Кабелеукладчик, ролик направляющий, скребок, модуль GXR, GXC, собачка подающая (станок Vollmer) (до 01.01.2012)	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
24	8483405900	Прочие вариаторы скорости (проч. зубчатые передачи, кроме зубчат. колес, цепн. звездочек и др.)включая гидротрансформаторы.	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	8481807100	Вентили проходные из чугунного литья (арматура прочая из чугунного литья)	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	7318149900	Винт резьбовой самонарезающий из черных металлов, винт установочный	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	7415330000	Винт медный (винты; болты и гайки из меди)	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	7318159009	Винты и болты из черных металлов прочие (винты и болты из черн. металлов с головками)	15.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	8414900000	Вставка металлическая шумогасителя минеральная, корпус промежуточного холодильника, элемент высокого давления, пластина графитовая (пр. части для насосов возд./вакуумн., возд./газ. компрессоров), комплект заслонок для вакуумного насоса деревообрабатывающего центра, мебр�	5.00	2005-10-25 00:00:00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: dcl_delivery_request; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_delivery_request (dlr_id, dlr_create_date, usr_id_create, dlr_edit_date, usr_id_edit, dlr_place_date, usr_id_place, dlr_number, dlr_date, dlr_fair_trade, dlr_wherefrom, dlr_comment, dlr_place_request, dlr_include_in_spec, dlr_annul, dlr_need_deliver, dlr_ord_not_form, dlr_executed, dlr_guarantee_repair, dlr_minsk) FROM stdin;
\.


--
-- Data for Name: dcl_department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_department (dep_id, dep_name) FROM stdin;
1	АСУ
2	Логистика
3	Администрация
4	Автоматизация
5	Гидравлика
6	Дeрeвообработка
7	Бухгалтерия
8	Сервисная станция
9	инструмент
10	Жлобин
11	Экономический
12	ТО деревообработка
13	Литовский офис
14	Гидравлика (Автоматизация)
15	Отдел модернизации оборудования
\.


--
-- Data for Name: dcl_dlr_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_dlr_list_produce (drp_id, dlr_id, prd_id, opr_id, drp_price, drp_count, stf_id, ctr_id, prs_id, drp_purpose, sip_id, receive_manager_id, receive_date, apr_id, asm_id, drp_max_extra, spc_id) FROM stdin;
\.


--
-- Data for Name: dcl_field_comment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_field_comment (fcm_id, fcm_key, fcm_value) FROM stdin;
1	Order.ord_in_one_spec	Галочку следует убрать если товар заказывается:\r\r\nа) для разных клиентов и/или под разные спецификации;\r\r\nб) на склад (в этом случае колонки для клиента, по договору, и спецификации у соответствующих позиций заполнять не надо)
9	Order.contractNumberWithDate	В выпадающем списке отображаются только НЕзакрытые договора. Закрытый договор - договор, у которого по всем спецификациям отгружен товар на 100% и получена оплата 100%.\r\r\nВ журнале "Договора" закрытые договора автоматически отмечаются галочкой [V].\r\r\n\r\r\nЕсли требуется разместить заказ под новый договор (или спецификацию), они должны быть внесены юристами в журнал "Договора".
10	Order.specificationNumberWithDate	В выпадающем списке отображаются только НЕзакрытые спецификации. Закрытая спецификация - спецификация, по которой отгружен товар на 100% и получена оплата 100%.\r\r\nВ журнале "Договора" закрытые спецификации автоматически отмечаются галочкой [V].\r\r\n\r\r\nЕсли требуется разместить заказ под новую спецификацию, она должна быть внесена юристами в журнал "Договора".
11	contractor.ctr_address	Поле для редактирования недоступно. Заполняется автоматически при заполнении полей, которые находятся ниже.\r\r\n\r\r\nДлина поля: 1000 знаков.\r\r\n
12	CalculationState.contractorCalcState.name	Поле привязано к справочнику "Контрагенты"\r\r\n\r\r\nВ выпадающем списке работает автофильтр по набору символов без учёта регистра.\r\r\n\r\r\nНапример: если набрать "маз", то в выпадающем списке отобразятся контрагенты, в наименовании которых присутствует буквосочетание "маз".\r\r\n\r\r\nВ списке первый пункт - "Все". Если выбрать его, то отчёт будет сформирован по всем контрагентам с учётом остальных настроек отчёта.
13	Shipping.contractor.name	Поле привязано к справочнику "Контрагенты"\r\r\n\r\r\nВ выпадающем списке работает автофильтр по набору символов без учёта регистра.\r\r\n\r\r\nНапример: если набрать "маз", то в выпадающем списке отобразятся контрагенты, в наименовании которых присутствует буквосочетание "маз".\r\r\n\r\r\nКнопка "Добавить" служит для добавления в справочник "Контрагенты" нового контрагента, если он отсутствует в выпадающем списке.
14	contractor.ctr_name	Наименования отображаются в выпадающих списках в журналах и документах в алфавитном порядке. Поэтому для облегчения их поиска сокращения типа УП, ЗАО, ООО и т.п.,  сюда вносить не надо, ну а если очень хочется, то их можно ставить в конце наименования.\r\r\nНаименования вносятся в справочник без кавычек.\r\r\n\r\r\nЕсли наименование имеет аббревиатуру, то можно указывать и наименование, и аббревиатуру. Это облегчит поиск по набору символов в выпадающих списках в электронных документах.\r\r\n\r\r\nПример правильного заполнения:\r\r\nМТЗ, Минский тракторный завод
15	contractor.ctr_full_name	Полное наименование - это то, что будет отображаться в печатных формах документов. Допускается указывать полное или сокращённое наименование в соответствии с учредительными документами контрагента. Его следует указывать с соблюдением общепринятых правил написания названий организаций в официальных документах. Сначала указывается форма собственности, затем наименование в кавычках.\r\r\n\r\r\nПример ПРАВИЛЬНОГО заполнения:\r\r\nООО "Рога и Копыта"\r\r\n\r\r\nПримеры неправильного заполнения:\r\r\nООО Рога и Копыта\r\r\nРога и Копыта ООО\r\r\nРога и Копыта
18	ContactPerson.cps_on_reason	Обычно это Устав (для руководителей) или доверенность (для прочих сотрудников).\r\r\nСледует указывать название, номер и дату документа.
19	Nomenclature.filter_catalog_number	Фильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, каталожный номер которых содержит данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
20	Nomenclature.filter_produce	Фильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, наименование которых содержит данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
21	Nomenclature.filter_type	Фильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, тип которых содержит данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
22	Nomenclature.filter_params	Фильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, основные парамерты которых содержат данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
23	Nomenclature.filter_add_params	Фильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, дополнительные параметры которых содержат данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
24	Nomenclature.filter_cusCode	Автофильтр выпадающего списка работает по набору символов без учёта регистра.\r\r\n\r\r\nБудут найдены все позиции с выбранным таможенным кодом.
25	ProduceCostProduce.stuff_category.name	Поле привязано к справочнику "Производители (продукты)"\r\r\n\r\r\nВ выпадающем списке работает автофильтр по набору символов без учёта регистра.\r\r\n\r\r\nНапример: если набрать "mar", то в выпадающем списке отобразятся производители, в наименовании которых присутствует буквосочетание "mar":\r\r\nMartin\r\r\nMarzorati\r\r\nTEMAR
26	ProduceCostProduce.produce.name	Поле привязано к справочнику "Номенклатура".\r\r\n\r\r\nПри нажатии на "Выбрать" происходит переход в справочник "Номенклатура", который отфильтрован в соответствии со значением поля "Производитель (продукт)".
27	ProduceCost.prc_number	Длина поля 50 символов.
28	CommercialProposal.null	Кнопка "Печать с-ф" недоступна, если:\r\r\n1. Низкие к-ты наценки\r\r\n(Все значения в колонке "Коэф-т наценки" должны быть >= 1,15)\r\r\n2. Низкий курс пересчёта\r\r\n(Значение поля "Курс пересчёта" должно быть >= k*1,05, где  k - курс НБРБ валюты, указанной в поле "Валюта таблицы", на дату, указанную в поле "дата".\r\r\nЕсли в справочнике "Валюты" отсутствует курс на ту дату, которая указана в поле "Дата", то берётся курс за предыдущую дату.)\r\r\n3. Чекбокс НДС построчно = [ ]\r\r\n
29	CommercialProposal.cpr_course_formatted	Данный курс используется для пересчёта валюты таблицы в валюту печати при выводе КП на печать (кнопка "Печать")\r\r\n\r\r\n1. Если "Валюта таблицы"="Валюта печати", то "Курс пересчёта" = 1\r\r\n2. Если "Валюта таблицы"<>"Валюта печати", то "Курс пересчёта" <> 1\r\r\n\r\r\nРекомендуемый min курс = Курс НБРБ * k, где k - коэф-т, который указывается администратором в настройках.
30	CommercialProposal.cpr_can_edit_invoice	Этот чекбокс отображается только у пользователей: администратор, экономист.\r\r\n\r\r\nЕсли отмечен, то появляется возможность вводить (редактировать) текст для с-ф в полях:\r\r\n- Условие оплаты\r\r\n- Срок поставки\r\r\n- Срок действия\r\r\n\r\r\n(Редактирование полей невозможно, если документ заблокирован)
31	CommercialProposal.cpr_comment	Для заметок. На печать не выводится.\r\r\n\r\r\nДлина 3000 знаков.
32	Nomenclature.filter_common	Поиск ведётся везде, где предусмотрено остальными полями фильтра.\r\r\nВнимание: Поиск по этому полю длится дольше, чем по другим полям.\r\r\n\r\r\nФильтр по набору символов без учёта регистра.\r\r\n\r\r\nПример. Если ввести "стол" или "СТОЛ", то фильтр найдёт все позиции, любое поле которых содержат данный набор символов:\r\r\nпистолет\r\r\nвакуумный стол\r\r\nи т.п.
35	ClosedRecord.lcc_charges	Если со знаком "+", то сумма будет вычтена из маржи.
36	ClosedRecord.lcc_montage	Если со знаком "+", то сумма будет вычтена из маржи.
37	ClosedRecord.lcc_transport	Если со знаком "+", то сумма будет вычтена из маржи.
38	ClosedRecord.lcc_update_sum	Если со знаком "+", то сумма будет вычтена из маржи.
39	Instruction.type.name	Для добавления пунктов в выпадающий список обратитесь к администратору.
40	Margin.view_montage_cost	Цепочка откуда тянем данные: отчёт маржа - документ отгрузка - позиция справочника номенклатура - поле Нормативы и тарифы монтажа и наладки (Тип оборудования) - действующий на дату отгрузки норматив/тариф - сумма общей стоимости работ и дороги.
41	contractor.country.name	Обязательное поле
42	CommercialProposalProduce.lpr_comment	Поле предназначено для впечатывания в КП дополнительных комментариев, пояснений для каждой отдельной позиции.\r\r\n\r\r\nТекст из данного поля при печати КП выводится в колонке "Наименование товара..." с новой строки после параметров товара.
43	Shipping.shp_summ_transport_formatted	Данные этого поля участвуют в расчёте маржи (отчёт "Маржа").
44	Order.ord_prod_for_1	Технические пометки:\r\r\n1. от чекбокса ЛТС зависит появление чекбокса "Когда заказ будет исполнен, весь товар сразу включить в спецификацию (импорт)";\r\r\nесли одновременно Линтера и ЛТС, то он есть, но неактивен.\r\r\n\r\r\n2. также если отдновременно два этих пункта, то "для клиента" и  "по договору" заполняются в табличной части...
45	Order.stuffCategory.name	При заполнении табличной части ниже значение этого поля автоматически устанавливается в фильтре справочника "Номенклатура". Это сделано для того, что бы в заказ к производителю не попали позиции, которые он не производит (других производителей). 
46	ConditionForContract.cfc_pay_cond	Длина поля 2500 знаков.
47	ConditionForContract.cfc_delivery_cond	Длина поля 2500 знаков.
48	ConditionForContract.cfc_guarantee_cond	Длина поля 2500 знаков.
49	ConditionForContract.cfc_montage_cond	Длина поля 2500 знаков.
50	ConditionForContract.cfc_count_delivery	Длина поля 1000 знаков.
51	TimeboardWork.tbw_from	Формат ввода времени:\r\r\nчч:мм\r\r\nhh:mm
52	TimeboardWork.tbw_to	Формат ввода времени:\r\r\nчч:мм\r\r\nhh:mm
53	TimeboardWork.tbw_hours_update_formatted	Корректировка времени. Единица измерения: часы.\r\r\n\r\r\nПрава доступа:\r\r\n1. пользователь, у которого "Начальник отдела" = ДА\r\r\n2. админ\r\r\n3. экономист\r\r\n
54	Order.not_merge_positions	При печати заказа одинаковые строки по умолчанию объединяются.\r\r\n\r\r\nЕсли чекбокс отмечен, то объединение не производится.
55	Contractors.title	1. Контрагентов можно объединять в случае если появился "двойник". Права: администратор.
56	Orders.state_3	Если чекбокс отмечен, то отображаются заказы, по которым не получено подтверждение от производителя в течение 3 дней с момента размещения заказа.\r\r\n\r\r\n(Сравниваются значения полей "Получено подтверждение заказа", "Заказ передан на производство" и текущая дата.)
57	Orders.state_a	Если чекбокс отмечен, то отображаются заказы, переданные на производство (т.е. те заказы, у которых заполнено поле "Заказ передан на производство").
58	Orders.state_b	Если чекбокс отмечен, то отображаются заказы, по которым получено подтверждение от производителя (т.е. те заказы, у которых заполнено поле "Получено подтверждение заказа").
59	Orders.state_exclamation	Сообщение о риске нарушить срок поставки появляется у заказов, если интервал между датами:\r\r\n- в заказе: "срок изготовления"\r\r\n- в спецификации к договору (указанной в поле "и спецификации"): "срок поставки"\r\r\nсоставляет менее 14 дней.
60	CommercialProposal.purchasePurpose.name	Права дооступа к редактированию списка: администратор.\r\r\n\r\r\n1. Если "КП составляется по товару, который лежит на складе в Минске"=[V] И "Цель приобретения товара:" = для розничной торговли, то:\r\r\n"Прод. цена, BYR" = "Цена по прейскуранту за ед., BYR" и неактивна.
61	ConditionForContract.purchasePurpose.name	Права дооступа к редактированию списка: администратор.
62	DeliveryRequest.dlr_date	На печать выводится дата из поля "Заявку разместил".
63	GoodsRest.title	Если отчёт формирует менеджер, то в колонках "Лежит на складе, сумма EUR (с/ст-ть + транспорт + таможня)" он видит данные только по тем позициям, которые заказывал он. \r\r\n\r\r\nЕсли отчёт формирует начальник отдела то в колонках "Лежит на складе, сумма EUR (с/ст-ть + транспорт + таможня)" он видит данные только по тем позициям, которые заказывали он и сотрудники его отдела.
64	ContractorRequest.contractNumberWithDate	1. Для формирования выпадающего списка должно быть заполнено поле "Контрагент".
66	ContractorRequest.equipment.fullList	1. Можно указать только одну уникальную позицию. Выбор происходит из списка, который состоит из оборудования, которое есть в отгрузках, которые привязаны к выбранному выше договору. Оборудованием считаются позиции, у которых в справочнике "Номенклатура" в колонке "Нормативы и тарифы монтажа и наладки (Тип оборудования)" есть хотя бы одно значение (на случай, если несколько производителей).\r\r\nПоле можно заполнить через выпадающий список с одним полем ввода, который можно фильтровать по набору символов без учёта регистра. При этом фильтрация затрагивает поля позиции: Наименование/Тип/Основные и доп. параметры, № по каталогу, Производитель (продукт), Серийный №.\r\r\nТ.е., например, можно выбрать позицию, набирая серийный номер.\r\r\n2. Поскольку данные тянутся из отгрузок, то изменение в отгрузке значений "Серийный №" или "Год выпуска" влечёт за собой изменения и в этой табличке.
67	ProduceCostReport.title	Отчёт предназначен для анализа расходов, связанных с доставкой грузов в РБ.\r\r\n\r\r\nДанные берутся из документов "Товар-себестоимость":\r\r\n- в колонку "Вес, кг" тянутся из ПОЛЯ "вес, кг"
68	ConditionForContract.cfc_custom_point	Данное поле должно заполняться во всех случаях, кроме осуществления поставок\r\r\nна условиях FCA и EXW.\r\r\n\r\r\nПример заполнения:\r\r\nПТО №06533 «Минск-СЭЗ», г. Минск, ул. Промышленная, 4.
69	Timeboard.tmb_date_formatted	Если не заполнено, то кнопка "Добавить" неактивна.\r\r\n\r\r\nНедоступно, если в табличной части есть хоть одна строка.
70	NomenclatureProduce.produce.block	Заблокированные позиции невозможно добавить в следующие документы:\r\r\nКП\r\r\nЗаказ\r\r\nЗаявка на доставку (поступление товаров)\r\r\nЗаявка на доставку (выбытие товаров)
72	MontageAdjustments.stuffCategory.name	Чтобы производитель отображался в списке, надо в справочнике "Производители (продукты)" в колонке "Отображать в списке в справочнике "Нормативы и тарифы монтажа" поставить галочку.
73	ConditionForContract.cfc_place	1. Заявки с неотмеченным чекбоксом юристами не обрабатываются.\r\r\n\r\r\n2. Чекбокс "Разместить заявку" неактивен, если колонка "Ед. изм." содержит недопустимое значение.\r\r\n(п2060)
74	Order.ord_by_guaranty	I.\r\r\nЕсли чекбокс отмечен, то  в сопроводительном письме во фразе \r\r\n"Позиции … заказываются на склад для …" слова "на склад" меняются на "по гарантии".\r\r\n\r\r\nII.\r\r\nЕсли:\r\r\n"Когда заказ будет исполнен, весь товар сразу включить в спецификацию (импорт)" = ДА \r\r\nИ\r\r\n"По гарантии" = ДА \r\r\nто:\r\r\n1. колонка "Продажная цена за единицу без НДС, бел.руб." не отображается (не требуется указание цен). \r\r\n2. в документе "Спецификации (импорт)" при импорте из заказа в левом окошке у таких зказов после номера с датой пишется красным жирным шрифтом "Гарантийный ремонт". В табличной части спеки-импорт в колонке "Продажная цена за единицу без НДС, бел.руб." будут нули.
75	ContractorRequest.crq_number	Присваивается автоматически при первом сохранении документа.
76	Instructions.title	- документ могут одновременно открывать пользователи с правами "только чтение"\r\r\n- документ могут одновременно открывать пользователи с правами "только чтение" и один пользователь с правами "редактирование"\r\r\n- два и более пользователя с правами "редактирование" одновременно документ открыть не могут\r\r\n
77	ShippingPositions.prc_date_min	Дата, которая подставляется в данное поле по умолчанию, = d-t, где:\r\r\nd - текущая системная дата\r\r\nt - число (количество дней), которое указывается в разделе "Администрирование -> Настройки".
78	user.usr_respons_person	Если чекбокс отмечен, то при нажатии на "сохранить" будет проверяться наличие заполнения Фамилии, имени и Должности на английском и немецком. (Это надо для печати заказов на нерускоязычных бланках.)
79	Order.ord_all_include_in_spec	Если:\r\r\n"Когда заказ будет исполнен, весь товар сразу включить в спецификацию (импорт)" = ДА \r\r\nИ\r\r\n"По гарантии" = ДА \r\r\nто:\r\r\n1. колонка "Продажная цена за единицу без НДС, бел.руб." не отображается (не требуется указание цен). \r\r\n2. в документе "Спецификации (импорт)" при импорте из заказа в левом окошке у таких зказов после номера с датой пишется красным жирным шрифтом "Гарантийный ремонт". В табличной части спеки-импорт в колонке "Продажная цена за единицу без НДС, бел.руб." будут нули.
80	Specification.user.userFullName	Значение этого поля влияет на фильтр отчёта "Состояние расчётов" ("Чьи спецификации:"). Это позволяет формировать отчёт о состоянии расчётов по договорам конкретного менеджера (отдела).
81	DeliveryRequestsIn	1. Аннулирование заявок. Аннулирование заявки возможно только если она ПОЛНОСТЬЮ НЕ ИСПОЛНЕНА (т.е. ни одна из позиций заявки не попала далее в электронные документы). Чтобы аннулировать частично исполненную заявку, менеджеру в первую очередь следует выяснить текущее состояние по позициям, обратившись к декларантам. Если заявке ещё можно дать "задний ход", то декларанты удалят позиции из своих электронных документов и заявку можно будет аннулировать.
82	CalculationState.userCalcState.userFullName	Заполнение этого поля позволяет делать выборку только по спецификациям (договорам) отдельно взятого менеджера. \r\r\n\r\r\nСвязь:\r\r\nдокумент "Договор" -> Спецификация -> поле "Чья спецификация" (указывается менеджер, который ведёт данную спецификацию)\r\r\n\r\r\n-------------\r\r\nКОП: 1331, 1342, 1344
83	CalculationState.departmentCalcState.name	Заполнение этого поля позволяет делать выборку только по спецификациям (договорам) отдельно взятого отдела. \r\r\n\r\r\n(Связь: документ "Договор" -> Спецификация -> поле "Чья спецификация" (указывается менеджер, который ведёт данную спецификацию) -> справочник "Пользователи" -> поле "Отдел")\r\r\n\r\r\n-------------\r\r\nКОП: 1331, 1342, 1344
84	Orders.contractor.name	Здесь указывается производитель, которому адресуется заказ.
85	Shipping.shp_montage_form	Чекбокс отмечается автоматически если у спецификации к договору (которая выьбрана в поле "№ Спецификации") отмечен чекбокс "Требуется монтаж и наладка".
87	DeliveryRequest.dlr_guarantee_repair	Только для случаев, если Линтера передаёт запчасти ЛТС безвозмездно.\r\r\n\r\r\nЕсли его отметить, то:\r\r\n1. колонка "Продажная цена за единицу без НДС, бел.руб." не отображается (не требуется указание цен). \r\r\n2. в поле "Назначение" автоматом подставляется "Ремонт (гарантийный / платный)"\r\r\n3. в документе "Спецификации (импорт)" при импорте из заявки в левом окошке у таких заявок после номера с датой пишется красным жирным шрифтом "Гарантийный ремонт". В табличной части спеки-импорт в колонке "Продажная цена за единицу без НДС, бел.руб." будут нули.
88	ConditionForContract.currency.name	1. Поле неактивно, если составляется спецификация к уже имеющемуся договору. Автоматически подставляется валюта указанного в поле "№ Договора (Контракта)" договора.
89	ConditionForContract.contractNumberWithDate	Для отображения списка следует заполнить поле "Покупатель". Будут отображены все договора с выбранным Покупателем, внесенные в журнал "Договора".\r\r\nОтображаются только те договора, у которых отмечен чекбокс "Многоразовый".
90	OrderProduce.drp_max_extra	Чекбокс не следует отмечать, если  товар везётся под конкретного клиента и конкретный договор.\r\r\n\r\r\nЧекбокс следует отмечать в случае, если товар везётся на склад (т.е. на этот товар ещё нет подписанных договоров и/или спецификаций). В этом случае мы как первый импортёр при составлении прейскуранта цен к ввозной цене накрутим 29,99%. Де-факто наценка обычно получается меньше, т.к. при расчёте ввозной цены мы страхуемся от колебаний курса евро за счёт нескольких процентов.\r\r\n\r\r\nПри необходимости за более подробной информацией обращаться к начальникам отделов или в экономический отдел.
91	Shipping.shp_serial_num_year_out	(Активно, если отмечен чекбокс "Требуется монтаж и наладка" [V].)\r\r\n\r\r\nЕсли отметить чекбокс, то в табличной части появится колонка "Серийный № / Год выпуска", в которой следует заполнить соответствующие поля.
92	Action.act_check_access	 Vladimir Petrov (12:02:06 11/05/2010)\r\r\nЭто мой задел на будущее для автоматической обработке прав. Не работает сейчас, потому что не доделан.
93	ContactPerson.cps_contract_comment	(Длина 300 знаков)\r\r\nЭто поле следует заполнять, если контактное лицо имеет право подписи.\r\r\nТекст из этого поля подставляется в бланк договора при его печати из Коммерческого предложения.\r\r\n\r\r\nОбразцы текстов для этого поля:\r\r\nа) если контрагент не является индивидуальным предпринимателем:\r\r\n\r\r\nв лице Директора иванова и.Т., действующего на основании Устава\r\r\n\r\r\nв лице заместителя директора Пупкина В.И., действующего на основании доверенности №1 от 01.01.2010\r\r\n\r\r\nб) если контрагент является индивидуальным предпринимателем:\r\r\n\r\r\nдействующий на основании свидетельства о государственной регистрации №101359908 от 09.10.2008 г.
94	Order.ord_shp_doc_number	Длина поля 60 символов.
95	ConditionForContract.cfc_comment	Длина 1000 знаков
96	CommercialProposal.cpr_reverse_calc	Если чекбокс отметить, то при заполнении строк вместо "Коэф-та наценки" требуется указывать Продажную цену в валюте печати (т.е. в валюте продажи). Коэффициент наценки будет рассчитан автоматически обратным счётом.
97	Specification.Specification.spc_payments	Если условия оплаты предусматривают оплату в несколько этапов, то, нажимая на зелёный "+", можно добавить необходимое количество строк в График платежей.\r\r\n\r\r\nПервая колонка заполняется, если части оплаты указаны в процентах. Суммы во второй колонке будут рассчитаны автоматически.\r\r\n\r\r\nВторая колонка заполняется, если части оплаты указаны в конкретных суммах. Проценты в первой колонке будут рассчитаны автоматически.\r\r\n\r\r\nВ третьей колонке указывается дата, до которой (включительно) должен поступить платёж.\r\r\n\r\r\nВ последней строке значение процентов равно 100 минус сумма процентов предыдущих строк, а значение суммы равно значение поля "Сумма" минус значения предыдущих строк.
120	SpecificationImport.title	1.\r\r\nКолонка "Заказчик"\r\r\nПри наведении курсора на наименование заказчика (или на саму клетку) отображается всплывающая подсказка с номером договора и спецификации, которые указаны в заказе (номер которого отображается в колонке "Заказ производителю"). \r\r\nЕсли в заказе указан заказчик, но не указаны договора и спецификации, то во всплывающем окне пишется: "НА СКЛАД".\r\r\nЕсли заказчик не указан, то во всплывающем окне пишется: "НА СКЛАД".
231	NomenclatureProduceCustomCodeFromHistory.customCode.code	Пометка в начале жирным шрифтом "Код не действует" появляется, если в справочнике "Таможенные коды" у кода отмечен чекбокс "заблокировано".
98	CommercialProposal.cpr_assemble_minsk_store	Если отмечено, то:\r\r\n1. "НДС построчно"=ДА и недоступно\r\r\n\r\r\n2. в колонках "НДС", "Стои- мость с НДС" округление до целых\r\r\n\r\r\n3. "Валюта таблицы" = "Валюта печати" = BYR и недоступны.\r\r\n\r\r\n4. Реализована возможность бронирования товара.\r\r\n   Условия:\r\r\n4.1. Товар автоматически бронируется на 10 дней. (Позиции, которые находятся в табличной части, бронируются до даты (включительно), указанной в поле "Срок действия")\r\r\n4.2. Товар автоматически снимается с брони если истёк срок действия КП и при этом не заполнено поле "Дата акцепта коммерческого предложения". Поле "Дата акцепта коммерческого предложения" заполняется менеджером, если клиент подписал договор и(или) внёс предоплату за товар до истечения срока действия коммерческого предложения.\r\r\n4.3. В период срока действия КП доступен чекбокс "Не бронировать товар (снять с брони)". Если его отметить и сохранить КП, то весь товар, который находится в табличной части, снимается с брони. Если с брони надо снять отдельную позицию или отдельное количество, то это осуществляется путём редактирования табличной части КП.\r\r\n4.4. Если была сделана отметка в поле "Дата акцепта коммерческого предложения", а клиент потом передумал, то товар снимается с брони менеджером вручную. Для этого следует отметить чекбокс "Не бронировать товар (снять с брони)".\r\r\n4.5. В ситуации, когда одновременно несколько пользователей создают КП и добавляют одни и те же позиции, бронируется товар у того, кто первым сохраняет КП с этими позициями. Другие пользователь при сохранении КП получат уведомление о невозможности забронировать товар.\r\r\n4.6. В период срока действия КП табличную часть можно редактировать (добавлять, убирать позиции, менять количество), но это будет происходить с учётом других КП, которые забронировали товар.\r\r\n\r\r\n5. Реализована возможность подбора продажной цены. \r\r\n    Условия:\r\r\n    1) 0 < a <= c\r\r\n    2) если a = c, то это продажа по ценам прейскуранта - нормальная ситуация (большинство случаев)\r\r\n    3) если b <= a < c, то это продажа товара с оптовой скидкой - нормальная ситуация\r\r\n    4) если 0 < a < b, то это продажа товара ниже цены приобретения (не путать с продажей ниже себестоимости) - ненормальная ситуация (допускается при реализации неликвидов). В таблице в колонке "Наценка, %" в этой строке значение буд
99	user.usr_no_login	Если отмечен, то при добавлении (редактировании) пользователя можно не заполнять поля:\r\r\nКод пользователя \r\r\nЛогин\r\r\nПароль\r\r\nПодтвердите пароль
100	ProduceMovement.title	Раздел "Приход". В скобках жирным шрифтом через точку с запятой показываются: количество остатка на момент формирования отчёта, инв. № в 1С.
101	contractor.ctr_phone	См. Приказ "Об общем порядке написания номеров телефонов и факсов" №052/07 от 14.02.2007 (в журнале "Приказы, распоряжения, инструкции")\r\r\n\r\r\nОбразец ПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 6668641\r\r\n\r\r\nОбразцы НЕПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 666-86-41\r\r\n+375-29-66686-41\r\r\n
102	contractor.ctr_fax	См. Приказ "Об общем порядке написания номеров телефонов и факсов" №052/07 от 14.02.2007 (в журнале "Приказы, распоряжения, инструкции")\r\r\n\r\r\nОбразец ПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 6668641\r\r\n\r\r\nОбразцы НЕПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 666-86-41\r\r\n+375-29-66686-41
103	contractor.ctr_bank_props	Указываются:\r\r\nПолное наименование банка, филиала\r\r\nАдрес банка\r\r\nКод банка
104	CommercialProposal.cpr_nds_by_string	По умолчанию этот чекбокс неактивен.\r\r\n1. Чекбокс становится активным когда "Цены указаны на условиях" = DDP и "Условие поставки" = DDP. Если его отметить, то в табличной части появляются колонки "НДС", "Стоимость с НДС", которые будут выводиться на печать.\r\r\n2. Если чекбокс "КП составляется по товару, который лежит на складе в Минске" = [V], то этот чекбокс отмечен и неактивен.
105	Countries.title	Справочник используется в справочнике "Контрагенты"
106	ProduceCost.prc_weight_formatted	Данные тянутся в отчёт "Товар-себестоимость".
108	ContractsClosed.title	1. Знак "!" в строке означает, что в документе есть хотя бы одна строка с пометкой "Копия" или "Проект".\r\r\n\r\r\n2. Выпадающий список поля "Контрагент" содержит только тех контрагентов, которые встречаются в документах этого журнала.
109	ContractsClosed.contractor.name	Выпадающий список поля "Контрагент" содержит только тех контрагентов, которые встречаются в документах этого журнала.
110	Contracts.title	Ограничения по доступу к документам:\r\r\n1. менеджер может иметь доступ только к тем договорам, в которых он указан в поле "Чья спецификация" (начальники отделов имеют доступ к договорам сотрудников своего отдела).
111	Contracts.oridinal_absent	Если отметить этот чекбокс и применить фильтр, то будут отображены договора, у которых у одной из спецификаций или у самого договора отсутствует галочка в чекбоксе "Оригинал".
112	GoodsRest.by_user	Активно, если заполнено поле "Отдел" и "Выводить только иТОГИ"=[V]
113	Contract.con_annul	Нельзя аннулировать договор, если:\r\r\n- на договор есть ссылки в других документах: оплата, отгрузка.\r\r\n- у него есть хотя бы одна закрытая спека.\r\r\n- у него есть хотя бы одна спека, к которой привязана отгрузка или оплата.\r\r\n\r\r\nАннулированный договор в журнале выделяется зачёркнутым шрифтом.
114	Setting.stn_value	Дробную часть отделять точкой.
115	Order.ord_date_conf_all	Если не отмечен, то данные о сроках изготовления товаров вносятся в каждую строку таблицы отдельно в режиме редактирования строки.
116	CommercialProposal.cpr_delay_days	Не более 60 дней.
118	CommercialProposal.cpr_no_reservation	В период срока действия КП доступен чекбокс "Не бронировать товар (снять с брони)". Если его в этот период отметить и сохранить КП, то весь товар, который находится в табличной части, снимается с брони.
119	Order.ord_prod_for_2	\N
227	CommercialProposal.cpr_proposal_received_flag	\N
121	ContractClosed.title	1. Cтроки сортируются в алфавитном порядке по колонке "Контрагент"\r\r\n2. Строка подсвечивается розовым, если:\r\r\n- у отгрузки в её табличной части есть позиции, которые в свою очередь тянутся из НЕЗАБЛОКИРОВАННЫХ документов "Товар-себестоимость"\r\r\n- договор или спецификация помечены "Копия" и/или "Проект".\r\r\n- отгрузка помечена "Копия" (эта пометка отображается если в документе "Отгрузка" не отмечен чекбокс "Оригинал")\r\r\n3. В строке цвет шрифта красный, если:\r\r\n- у спецификации "Разрешить частичное закрытие спецификации" = ДА И сумма отгрузок <> сумме оплат. Требуется нажать "..." и удалить лишние отгрузки/оплаты.
122	Order.title	1.\r\r\n"Когда заказ будет исполнен, весь товар сразу включить в спецификацию (импорт)= [V]\r\r\n\r\r\nПри редактировании (сохранении) строк в табличной части осуществляется проверка по следующей формуле:\r\r\nесли a/b/c>1,5, где\r\r\na - Продажная цена за единицу без НДС, бел.руб.\r\r\nb - курс из справочника "валюты" валюты, указанной в графе "Валюта" на дату заказа\r\r\nс - Цена нетто,\r\r\n1,5 - к-т, который можно поменять в настройках (админ),\r\r\nто выдаётся сообщение:\r\r\n"Проверьте цену в поле "Продажная цена за единицу без НДС, бел.руб.". Возможно, допущена ошибка и цена указана больше, чем требуется. Убедитесь, что Вы внесли именно ЦЕНУ ЗА 1 ШТ, а не СУММУ ЗА ВСЁ КОЛИЧЕСТВО"\r\r\n\r\r\n2.\r\r\nКолонка "Кол-во исполнено".\r\r\nЕсли у строки "Кол-во исполнено"<"Кол-во", то фон ячейки подсвечивается розовым цветом. (исключение: подчинённые строки).
123	OrderProduce.drp_price	При редактировании (сохранении) строк в табличной части осуществляtncz проверка по следующей формуле:\r\r\nесли a/b/c>1,5, где\r\r\na - Продажная цена за единицу без НДС, бел.руб.\r\r\nb - курс из справочника "валюты" валюты, указанной в графе "Валюта" на дату заказа\r\r\nс - Цена нетто,\r\r\n1,5 - к-т, который можно поменять в настройках (админ),\r\r\nто выдаётся сообщение:\r\r\n"Проверьте цену в поле "Продажная цена за единицу без НДС, бел.руб.". Возможно, допущена ошибка и цена указана больше, чем требуется. Убедитесь, что Вы внесли именно ЦЕНУ ЗА 1 ШТ, а не СУММУ ЗА ВСЁ КОЛИЧЕСТВО"\r\r\n
124	DeliveryRequestProduce.drp_price	При редактировании (сохранении) строк в табличной части осуществляtncz проверка по следующей формуле:\r\r\nесли a/b/c>1,5, где\r\r\na - Продажная цена за единицу без НДС, бел.руб.\r\r\nb - курс из справочника "валюты" валюты, указанной в графе "Валюта" на дату заказа\r\r\nс - Цена нетто,\r\r\n1,5 - к-т, который можно поменять в настройках (админ),\r\r\nто выдаётся сообщение:\r\r\n"Проверьте цену в поле "Продажная цена за единицу без НДС, бел.руб.". Возможно, допущена ошибка и цена указана больше, чем требуется. Убедитесь, что Вы внесли именно ЦЕНУ ЗА 1 ШТ, а не СУММУ ЗА ВСЁ КОЛИЧЕСТВО"
126	DeliveryRequestProduce.drp_max_extra	Чекбокс не следует отмечать, если  товар везётся под конкретного клиента и конкретный договор.\r\r\n\r\r\nЧекбокс следует отмечать в случае, если товар везётся на склад (т.е. на этот товар ещё нет подписанных договоров и/или спецификаций). В этом случае мы как первый импортёр при составлении прейскуранта цен к ввозной цене накрутим 29,99%. Де-факто наценка обычно получается меньше, т.к. при расчёте ввозной цены мы страхуемся от колебаний курса евро за счёт нескольких процентов.\r\r\n\r\r\nПри необходимости за более подробной информацией обращаться к начальникам отделов или в экономический отдел.
127	CommercialProposal.invoiceScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
128	CommercialProposal.printScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
129	CommercialProposal.contractScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
130	Order.letterScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
131	Order.printScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
132	NomenclatureProduce.printScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
133	ContractorRequest.actScale	Масштабирование размера шрифтов в документе.\r\r\n<100% - уменьшение\r\r\n>100% - увеличение
134	NomenclatureProduce.title	I. Возможность редактирования (внесения изменений)\r\r\nЕсли позиция попала хотя бы в один электронный документ, то для редактирования становятся недоступными следующие поля:\r\r\n- Наименование товара (перевод)\r\r\n- Тип  \r\r\n- Основные параметры  \r\r\n- Доп. параметры  \r\r\n- Ед. изм.\r\r\n- Производитель\r\r\n- № по каталогу\r\r\n(доступ имеет Администратор)
135	ConditionForContract.ConditionForContract.cfc_spc_numbers_help	   В этом поле через запятую указываются значения поля "№ новой спецификации" документов "Условия для составления договора (контракта)", у которых такое же значение поля "№ Договора (Контракта)".\r\r\n   Причём номера из тех заявок, у которых есть отметка "Заявка выполнена" пишутся жирным зелёным шрифтом.
136	ConditionForContract.contactPerson.cps_name	Обязательные поля\r\r\n- "должность:"\r\r\n- "Тел.:" ИЛИ "Моб."
137	ShippingReport.title	1.\r\r\nКолонка "Сумма без НДС, EUR"\r\r\nРасчёт значений в колонке:\r\r\nа) "Валюта"=BYR\r\r\n=Сумма без НДС / курс EUR на дату отгрузки\r\r\nб) "Валюта"=EUR\r\r\n=Сумма без НДС\r\r\nв) "Валюта"= прочие валюты\r\r\n=Сумма без НДС * курс валюты на дату отгрузки / курс EUR на дату отгрузки\r\r\n\r\r\n2.\r\r\nЕсли табличная часть документа Отгрузка пустая \r\r\nи\r\r\nВыводить итоги по каждой отгрузке = ДА\r\r\nИ\r\r\nне требуется разбивать итог отгрузки,\r\r\n\r\r\nто всётаки сумма в отчёт берётся из поля "Сумма с НДС" документа Отгрузка.\r\r\n
138	contractors.user.userFullName	У пользователей с правами "менджер" по умолчанию заполнено. У пользователей с другими правами - пустое.\r\r\n\r\r\nЧтобы у менеджера по умолчанию отображался нужный ему контрагент следует:\r\r\n- очистить это поле\r\r\n- найти нужного контрагента в справочнике (если контрагент отсутствует, то создать(добавить) нового)\r\r\n- в режиме редактирования контрагента во вкладке "Курируют" добавить себя в список.
139	ContactPerson.cps_phone	См. Приказ "Об общем порядке написания номеров телефонов и факсов" №052/07 от 14.02.2007 (в журнале "Приказы, распоряжения, инструкции")\r\r\n\r\r\nОбразец ПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 6668641\r\r\n\r\r\nОбразцы НЕПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 666-86-41\r\r\n+375-29-66686-41\r\r\n
140	ContactPerson.cps_mob_phone	См. Приказ "Об общем порядке написания номеров телефонов и факсов" №052/07 от 14.02.2007 (в журнале "Приказы, распоряжения, инструкции")\r\r\n\r\r\nОбразец ПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 6668641\r\r\n\r\r\nОбразцы НЕПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 666-86-41\r\r\n+375-29-66686-41\r\r\n
141	ContactPerson.cps_fax	См. Приказ "Об общем порядке написания номеров телефонов и факсов" №052/07 от 14.02.2007 (в журнале "Приказы, распоряжения, инструкции")\r\r\n\r\r\nОбразец ПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 6668641\r\r\n\r\r\nОбразцы НЕПРАВИЛЬНОГО написания номера телефона:\r\r\n(+375 29) 666-86-41\r\r\n+375-29-66686-41\r\r\n
142	ConditionForContract.contactPersonSign.cps_name	<b>ФИО лица, уполномоченного подписывать Договор, следует указывать полностью.</b>\r\r\n\r\r\n<i>Правильно:</i>\r\r\nиванов иван иванович\r\r\nиванов и.И.\r\r\n\r\r\n<i>Неправильно:</i>\r\r\nиван иванович\r\r\nиванов иван\r\r\nи.И.И.\r\r\nИ.И.\r\r\nиваныч
143	DeliveryRequestPositions.manager.userFullName	По умолчанию подставляется тот пользователь, который составляет заявку. Соответственно, в левом "окне" отображаются заказы, которые принадлежат пользователю (созданы пользователем), указанному в поле фильтра.\r\r\nЧтобы отобразить заказы всех пользователей следует в списке выбрать пункт "Все".
144	PaySumm.contractNumberWithDate	Отображаются договора:\r\r\nнезакрытые\r\r\n<b>И</b>\r\r\nу которых значение поля "Валюта" совпадает со значением поля "Валюта" документа "Оплата".
145	Specification.Specification.spc_delivery_cond	У ЗАКРЫТОЙ спецификации доступны для редактирования админом\r\r\n
146	Specification.Specification.spc_add_pay_cond	<b>26.07.2012 Ахраменка:</b> При внесении договоров на техническое обслуживание, ремонт гидросистем и проверку чистоты масел в поле «Условия оплаты» необходимо вносить условия пункта  5.3. Договора (Заказчик производит окончательный расчет за выполненные работы в течение 3 дней от даты подписания Акта сдачи-приемки выполненных работ на основании выставленных счетов), независимо от того какие именно это работы. \r\r\n\r\r\nТехнич.: У ЗАКРЫТОЙ спецификации доступны для редактирования админом.
147	Specification.spc_annul	Дату можно не указывать.\r\r\nПрава: админ, юрист, экономист.\r\r\nАннулированная спецификация в табличной части "Спецификации" выделяется зачёркнутым шрифтом.
149	Contract.con_comment	Длина: 5000
150	Specification.spc_comment	Длина: 5000
151	Specification.spc_montage	Если "Требуется монтаж и наладка"=[V], то чекбокс "Оплата после монтажа" становится активным, но не обязательным.
152	Specification.spc_pay_after_montage	Если "Требуется монтаж и наладка"=[V], то чекбокс "Оплата после монтажа" становится активным, но не обязательным.
153	Contract.con_annul_date_formatted	Дату можно не указывать
154	SumLprPrice	Сумма нетто = сумма произведений цен нетто на кол-во по всем строкам.
232	Order.ord_comment_covering_letter	Текстовое\r\r\nДлина = 1000 знаков
155	ConditionForContract.cfc_doc_type2	Если отмечено [V], то:\r\r\n- в поле "№ Договора (Контракта)"  после номера и даты контрактов, у которых поле "Многоразовый"=ДА, писать: "Многоразовый. Срок действия: до <значение поля "срок действия">".\r\r\n- в выпадающем списке поля "№ Договора (Контракта)" отображаются договора, у которых поле "Многоразовый"=ДА.\r\r\n\r\r\nСправа от выпадающего списка жирным зелёным: "Многоразовый. Срок действия: до <значение поля "срок действия">"
156	ProducesForAssembleMinsk.ProducesForAssembleMinskRestCountHeader	Если кликнуть на цифру, показывающую Бронь, то появится табличка с детализацией по брони.
157	CustomCodes.CustomCodesLaw240Header	Колонка "Постановление № 240/5 от 25 февраля 2011 г. О расчетах по импорту некоторых товаров"\r\r\n\r\r\nЕсли в этой колонке стоит [V], то в документе "Спецификация (импорт)" с новой строки под таможенным кодом пишется жирным шрифтом "Пост. №240/5". (Такие товары везём отдельными спецификациями.)\r\r\n\r\r\n(<b>ОБНОВЛЕНО!!! Постановление утратило силу с 20 сентября 2011 года в связи с принятием постановления Совета Министров Республики Беларусь, Национального банка Республики Беларусь от 20.09.2011 N 1250/21.</b>)
158	SpecificationImport.SpecificationImportExpirationHeader	Указывается кол-во дней оставшихся до истечения срока поставки по договору.\r\r\nПоложительное число красным шрифтом означает просрочку.
159	ContractsClosed.ContractsClosedWarnsHeader	Восклицательный знак появляется, если в документе есть "проблемные" строки (подсвечиваются розовым).\r\r\nПодробнее про "проблемные" строки написано в справке к самому документу.
160	Payments.PaymentsNotesHeaderCourseNBRB	Указывается справочно, если при расчёте суммы EUR используется другой курс.
161	Payment.pay_course_nbrb_formatted	Указывается справочно, если при расчёте эквивалента в EUR в поле "Курс" используется другое значение.\r\r\n\r\r\nЕсли поле "Валюта" = BYR, то:\r\r\n- Если a=b, то поле "Курс НБРБ" = 0.\r\r\n- Если a<>b, то поле "Курс НБРБ"=b.\r\r\na - значение поля "Курс"\r\r\nb - Курс EUR НБРБ из справочника валют на дату документа "Оплата"\r\r\nи\r\r\nПоле "Курс НБРБ" нельзя редактировать."\r\r\n
163	CommercialProposal.cpr_free_prices	Если отмечен, то в табличной части должно быть "Прод. цена, BYR" > "Цена на складе за ед., BYR"\r\r\n\r\r\nИ\r\r\n\r\r\nb>s/n*e*k, где\r\r\nb - Прод. цена, BYR\r\r\ns - Лежит на складе, сумма EUR (с/ст-ть + транспорт + таможня) \r\r\nn - Количество\r\r\n(s, n - проще всего брать из дока товар-себестоимость, из которого в режиме "Выбор позиций" взяли позицию в табличную часть КП.\r\r\ns="Себестоимость за 1 ед., EUR" * n + "Транспорт, EUR" + "Таможенные расходы, EUR")\r\r\ne - курс EUR на дату КП (из справочника Валюты)\r\r\nk - значение minCourseCoefficient из настроек
164	ProduceMovement.divide_into_chain	\N
165	Office.title	<b>Модуль: информирование о поступающих оплатах.</b>\r\r\nПринцип отображения информации:\r\r\n- если оплата не привязана к контрагенту, то сообщение о её поступлении видят все менеджеры\r\r\n- если оплата привязана к контрагенту, то её видят все менеджеры, которые курируют контрагента (справочник "Контрагенты" - редактировать контрагента - вкладка "Курируют")\r\r\n- если оплата привязана к контрагенту и распределена по спецификациям договоров, то информацию видят те менеджеры, которым принадлежат спецификации (Журнал "Договора" - Редактировать Договор - Редактировать Спецификацию - поле "Чья спецификация")\r\r\n\r\r\n<b>Модуль: информирование о договорах.</b>\r\r\nПоявляется соответствующая запись:\r\r\n- если у договора или у спецификации отметить чекбокс "Оригинал" и сохранить документ;\r\r\n- при отметке в журнале "Условия для составления договора (контракта)" у заявки чекбокса "Заявка выполнена".\r\r\n\r\r\n<b>Модуль: информирование о поступающих товарах в Литву и в Минск.</b>\r\r\nПринцип отображения информации:\r\r\n- менеджер - по своим заказам;\r\r\n- начотдела - по своим заказам и своего отдела.
166	CommercialProposal.facsimile_flag	Если чекбокс отмечен, то при нажатии на "Печать" в формируемый документ pdf подставляется факсимиле подписи менеджера.\r\r\n\r\r\nФаксимиле подписи будет подставлено в документ при условии:\r\r\n"Текущий (залогиненный)пользователь" = пользователь, указанный в поле "Подпись"\r\r\nи\r\r\nчекбокс "Впечатать исполнителя" не отмечен. \r\r\n\r\r\n(Файлы с подписями менеджеров размещает в справочнике "Пользователи" Администратор)
167	Order.OrderProduceNameHeader	Наименование кликабельно.\r\r\nПри нажатии сформируется отчёт "Движение" по конкретной позиции.
168	Nomenclature.category_name	Поле предназначено для добавления/удаления папок.\r\r\nПравила:\r\r\n1. Нельзя удалить папку, в которой есть номенклатурные позиции.\r\r\n2. Для изменения наименования папки её надо выделить, в этом поле отредакстировать и нажать на "изменить"\r\r\n3. Для добавления подпапки следует выделить папку, в которую добавляется подпапка, указать наименование подпапки и нажать "Добавить".
169	Margin.title	1.\r\r\n(касается экономистов) Строка подсвечивается розовым, если у отгрузки в её табличной части есть позиции, которые в свою очередь тянутся из НЕЗАБЛОКИРОВАННЫХ документов "Товар-себестоимость".\r\r\n2.\r\r\nЗелёным цветом подсвечены строки по частично исполненным спецификациям (т.е. по спецификациям, которые закрывались частично). 
171	Shipping.shp_montage_checkbox	Если чекбокс "Оригинал" = [ ], то:\r\r\nв документе "Закрытие договоров"\r\r\n1.\r\r\nВ окне редактирования строки в колонке "Отгрузки - № Документа" после номера документа пишется красным жирным "Копия"\r\r\n2.\r\r\nСтрока табличной части документа подсвечивается розовым, если в ней есть номера отгрузок, после которых указано "Копия", а в журнале "Закрытие договоров" доки с такими "проблемными" строками отмечаются красным знаком "!". 
172	NomenclatureProduce.produce.type	Заполняется латинницей.
173	NomenclatureProduce.produce.params	Заполняется латинницей.
174	NomenclatureProduce.produce.addParams	Заполняется латинницей.
175	Shipping.shp_sum_update_formatted	Данные этого поля участвуют в расчёте маржи (отчёт "Маржа", колонка "Корректировка").\r\r\nЕсли со знаком "+", то сумма будет вычтена из маржи.
176	Margin.view_update_sum	В этой колонке суммируются значания полей "Корректировка" из документов "отгрузка" и "закрытие договоров".
177	CommercialProposal.printInvoiceButton	Кнопка "Печать с-ф" недоступна, если:\r\r\n1. Низкие к-ты наценки\r\r\n(Все значения в колонке "Коэф-т наценки" должны быть >= 1,15)\r\r\n2. Низкий курс пересчёта\r\r\n(Значение поля "Курс пересчёта" должно быть >= k*1,05, где  k - курс НБРБ валюты, указанной в поле "Валюта таблицы", на дату, указанную в поле "дата".\r\r\nЕсли в справочнике "Валюты" отсутствует курс на ту дату, которая указана в поле "Дата", то берётся курс за предыдущую дату.)\r\r\n3. Чекбокс НДС построчно = [ ]
178	CustomCodes.CustomCodesBlock0Header	Таможенные коды можно блокировать и разблокировать в любой момент без ограничений.\r\r\n\r\r\nЗаблокированный таможенный код:\r\r\n- в соответствующем выпадающем списке в справочнике "Номенклатура" помечается в начале жирным шрифтом "Код не действует".\r\r\n- в документе "Спецификации (импорт)" в колонке "Таможенный код" под таким кодом появляется надпись "Код не действует".
179	Nomenclature.title	1. Красным шрифтом обозначаются заблокированные позиции. их невозможно добавить в следующие документы:\r\r\nКП\r\r\nЗаказ\r\r\nЗаявка на доставку (поступление товаров)\r\r\nЗаявка на доставку (выбытие товаров)
180	Payment.PaymentUpdateCourses	При нажатии этой кнопки: \r\r\n1.\r\r\nв справочник "Валюты" загружаются курсы из интернет за все даты, начиная с последней загруженной и до текущей + 1 день (т.к. обычно завтрашние курсы банк вывешивает сегодня после обеда). Т.е. если в справочник курсы последний раз загружали 12/04, текущая дата 16/04, а на сайте НБРБ уже есть курсы за 17/04, то загружаются курсы за: 13/04, 14/04, 15/04, 16/04, 17/04;\r\r\n2.\r\r\nв поле "Курс НБРБ на dd.mm.yyyy" актуализируются дата в названии поля и значение этого поля;\r\r\n3.\r\r\nпосле загрузки курсов выдаётся сообщение, что курсы загружены.
181	ContractorRequest.crq_operating_time	Числовое: 0,00. Длина целой части 5 знаков.
182	NomenclatureProduce.customCode.code	В поле отображается код (из истории кодов для данной позиции), актуальный на текущую дату.
183	DeliveryRequest.dlr_executed	Отметку делают сотрудники отдела Логистики ЛТС по факту исполнения заявки.
184	CalculationState.title	Светло-оранжевым цветом подсвечены оплаты, или части тех оплат, которые не распределены полностью.\r\r\n\r\r\nЗелёным цветом подсвечены закрытые отгрузки и оплаты по частично исполненным спецификациям.
228	Orders.contract.con_number	1. Если поле "Клиент" пустое, то это поле просто текстовое.\r\r\n2. Если поле "Клиент" заполнено, то это поле становится выпадающим списком с автофильтром по набору символов. В списке отображаются договора привязанные к выбранному "Клиенту"\r\r\n
229	Units.UnitAcceptedForContractHeader	Отмечаются только те единицы измерения, которые по законодательству РБ допустимы для использования в офиц. документах.\r\r\n\r\r\n(пп 2059, 2060)
185	Specification.Specification.spc_additional_days_count	I.\r\r\nЗначение этого поля автоматически прибавится к дате, когда условие по предоплате будет выполнено, т.е. "Срок (дата) поставки" будет рассчитан автоматически и указан в поле "дата".\r\r\n\r\r\nПример:\r\r\nСрок поставки 14 (четырнадцать) календарных дней с момента внесения предоплаты 100%.\r\r\nПредоплата 100% внесена (Условие выполнено) 23.07.2012.\r\r\nСрок (дата) поставки = 23.07.2012 + 14 календарных дней = 06.08.2012\r\r\n\r\r\nII.\r\r\nПоле автоматически заполняется при импорте из КП, у которого "КП составляется по товару, который лежит на складе в Минске = ДА". Значение тянется из Администрирование - настройки - defaultSpcAdditionalDaysCount.
188	Contract.contractor.name	Невозможно редактирование при наличии хотя бы одной спецификации, на которую есть ссылка в других документах.
189	Contracts.ContractsReminderHeader	В начало журнала по умолчанию помещаются договора с сообщениями "Срок действия договора истёк", " Срок действия договора истекает через n дн.", у которых есть незакрытые спецификации.
190	ConditionForContract.title	Р’РѕРїСЂРѕСЃ-РѕС‚РІРµС‚:\r\r\n1.\r\r\nР’: Р’ С‚Р°Р±Р»РёС‡РЅРѕР№ С‡Р°СЃС‚Рё РїСЂРё РёРјРїРѕСЂС‚Рµ РёР· РљРџ С†РµРЅС‹ Рё СЃСѓРјРјС‹ РІ РµРІСЂРѕ РѕРєСЂСѓРіР»СЏСЋС‚СЃСЏ РґРѕ С†РµР»РѕРіРѕ. РџРѕС‡РµРјСѓ?\r\r\nРћ: Р­С‚Рѕ РїСЂРѕРёСЃС…РѕРґРёС‚, РµСЃР»Рё РЅРµ Р·Р°РїРѕР»РЅРµРЅРѕ РїРѕР»Рµ "Р’Р°Р»СЋС‚Р°".  
191	CommercialProposal.cpr_guaranty_in_month	числовое, целое, положительное, по умолчанию = 0
192	GoodsCirculation.by_quarter	Если "дата с" не равно: 1 янв, 1 апр, 1 июл, 1 окт, И/ИЛИ "дата по" не равно: 31 мар, 30 июн, 30 сен, 31 дек, то чекбокс "по кварталам"=НЕТ И не доступен и чекбокс "по месяцам"=ДА
193	GoodsCirculation.title	1. Если "дата с" не равно: 1 янв, 1 апр, 1 июл, 1 окт, И/ИЛИ "дата по" не равно: 31 мар, 30 июн, 30 сен, 31 дек, то чекбокс "по кварталам"=НЕТ И не доступен и чекбокс "по месяцам"=ДА\r\r\n2. Если "по месяцам"=ДА И "по кварталам"=ДА, то перед каждой колонкой за квартал, выводятся три колонки с данными за соответствующие месяцы.\r\r\n3. Если "по кварталам"=НЕТ И "по месяцам"=НЕТ, то кнопка "сформировать" недоступна.
194	GoodsCirculation.stuffCategory.name	Автофильтр по набору символов
195	GoodsCirculation.contractorGoodsCirculation.name	Автофильтр по набору символов.\r\r\nПо умолчанию все. Если выбран конкретный, то в отчёт попадают позиции из отгрузок, в которых указан данный конрагент.
196	GoodsCirculation.produceName	Текстовый фильтр по набору символов без учёта регистра. Если заполнено, то в отчёт попадают все товары, удовлетворяющие этому полю, с учётом остальных настроек отчёта. Если не заполнено, то выводить по всем товарам с учётом остальных настроек отчёта.
197	GoodsCirculation.by_contractor	Неактивно и =[ ], если выбран конкретный контрагент.
198	GoodsCirculation.seller.name	Если отмечено, то в отчёт попадают позиции из отгрузок, которые в свою очередь привязаны к договорам, а в договорах уже указано, кто продавец.
199	Shipping.shp_original	Отмечается наличие оригинала отгрузочного документа (ТТН, акта выполенных работ и т.п.)\r\r\nПо умолчанию отмечен.\r\r\nЕсли не отмечен, то появляются сигнальные пометки в:\r\r\nДокумент "Закрытие договоров"\r\r\nОтчёт "Маржа"\r\r\n
200	CalculationState.view_pay_cond	Текст тянется из документа "Договор"
201	CalculationState.view_delivery_cond	Текст тянется из документа "Договор"
202	Specification.spc_percent_or_sum_percent	При проверке выполнения условия округление производится до целых. \r\r\nНапример: клиент оплатил 49,99%, в этом случае считаем, что оплачено 50%.
203	Payment.pay_course_formatted	Курс (коэффициент) для пересчёта "Суммы" оплаты в евро.
204	Shipping.shp_date_expiration	Если договором предусмотрена предоплата, но её нет, то при отгрузке без предоплаты оплата должна быть произведена не позднее следующего дня с момента получекния товара
205	ContractorRequest.contractForWorkNumberWithDate	* Появляется справа от поля "Вид работ:" (если Вид работ = Платные (сервисные) работы). \r\r\n* Вып. список договоров с контрагентом,  указанным в поле "Контрагент", у которых:\r\r\n- значение поля "Срок действия" после даты в поле "Дата получения заявки"\r\r\n- Многоразовый = [V] \r\r\n* Обязательное.
206	CommercialProposal.consignee.name	Данное поле следует заполнять в случаях:\r\r\n1. Договор заключается с юридическим лицом, а товар получает его филиал (филиалы не являются юридическими лицами и не могут выступать в роли контрагента по договору).
230	CommercialProposal.contactPersonSeller.cps_name	Список настраивает Администратор.\r\r\nАдминистрирование - Настройки - contractorLTS
207	DeliveryRequestPositions.title	<b>Р’РѕРїСЂРѕСЃ:</b>\r\r\nРќРµ РЅР°С…РѕР¶Сѓ РІ Р»РµРІРѕРј РѕРєРЅРµ РЅСѓР¶РЅС‹Р№ Р·Р°РєР°Р· / РїРѕР·РёС†РёРё.\r\r\n<b>OС‚РІРµС‚:</b>\r\r\nР’РѕР·РјРѕР¶РЅС‹Рµ РїСЂРёС‡РёРЅС‹:\r\r\n<del>1. Р’ Р·Р°РєР°Р·Рµ РЅРµ РѕС‚РјРµС‡РµРЅ С‡РµРєР±РѕРєСЃ "РџСЂРѕРґСѓРєС†РёСЏ Р·Р°РєР°Р·С‹РІР°РµС‚СЃСЏ (РєРµРј?)" = "Р›РёРЅС‚РµСЂР°РўРµС…РЎРµСЂРІРёСЃ"</del>\r\r\n2. Р—Р°РєР°Р· РЅРµ РёСЃРїРѕР»РЅРµРЅ (Р»РёР±Рѕ РёСЃРїРѕР»РЅРµРЅ С‡Р°СЃС‚РёС‡РЅРѕ)\r\r\n3. Р’ Р·Р°РєР°Р·Рµ РѕС‚РјРµС‡РµРЅ С‡РµРєР±РѕРєСЃ "РљРѕРіРґР° Р·Р°РєР°Р· Р±СѓРґРµС‚ РёСЃРїРѕР»РЅРµРЅ, РІРµСЃСЊ С‚РѕРІР°СЂ СЃСЂР°Р·Сѓ РІРєР»СЋС‡РёС‚СЊ РІ СЃРїРµС†РёС„РёРєР°С†РёСЋ (РёРјРїРѕСЂС‚)" = Р”Рђ\r\r\n4. РќР°СЃС‚СЂРѕР№РєРё С„РёР»СЊС‚СЂР°.
208	DeliveryRequests.DeliveryRequestsDeleteHeader	Значок "Х" (удалить) отображается, если в табличной части документа пусто. У аннулированных заявок, у которых пустая табличная часть, тоже отображается.
209	Nomenclature.downloadDoubleValuesButton	Если в фильтре заполнить поле "Производитель (продукт)", то поиск двойников будет происводиться только среди позиций выбранного производителя.
210	Orders.contractor_for.name	Контрагент - конечный покупатель.
211	ContractorRequest.seller.name	Выпадающий список редактируется здесь:\r\r\nАдминистрирование - Справочники - Продавцы\r\r\n\r\r\nПоле заполняется автоматически. Значение зависит от значения поля "Продавец" у договора, указанного в поле "Договор покупки оборудования"
212	Sellers.title	Справочник используется:\r\r\n- в документе "Заявка от контрагента" (Вид работ: ПНР; поле "Ответственный продавец")\r\r\n- в печатной форме Акта ПНР\r\r\n- отчёт "Состояние расчетов"
213	Seller.sln_name	Длина поля 100
214	Contract.seller.name	Выпадающий список редактируется здесь:\r\r\nАдминистрирование - Справочники - Продавцы
215	NomenclatureProduce.number1C	1. В самом поле отображается код, актуальный на текущую дату (тянется из истории).\r\r\n2. Права доступа к кнопке "история": админ, экономист.\r\r\n3. Данные в историю вносятся двумя вариантами:\r\r\n3.1. Вручную через "Добавить"\r\r\n3.2. Автоматически при сохранении документа "Товар - Себестоимость". Данные для соотв. позиций берутся из колонки "инв. номер в 1С", а дата = значению поля "Дата"
216	ProduceCost.title	1.\r\r\nПри добавлении позиций в табличную часть автоматически заполняется колонка "инв. № в 1С". Данные тянутся из подсправочника "история инв. № в 1С", актуальные на дату документа "Товар - Себестоимость". С возможностью редактировать значения в колонке, т.е. поле автоматом заполняется только при добавлении позиции.\r\r\n
217	ConditionForContract.ConditionForContractProducesNumber1CHeader	1.\r\r\nКолонка появляется если Продавец = ЛТС.\r\r\n2.\r\r\nДанные в колонку автоматически тянутся из подсправочника "история инв. № в 1С" актуальные на дату размещения заявки (значение поля "Заявку разместил").
218	DeliveryRequest.dlr_annul	Права доступа:\r\r\n1. админ, декларант\r\r\n2. (если заявка ПОЛНОСТЬЮ неисполнена) админ, декларант, менеджер, экономист\r\r\n
219	CommercialProposal.cpr_all_transport	Если отмечено, то сумма будет распределена пропорционально между ВСЕМИ строками, независимо от Производителя.
220	Contract.con_final_date_formatted	Обязательное
221	ProduceMovement.ProduceMovementOrdProduceCountExecutedHeader	Данные в строках отображаются в виде: N / K\r\r\nгде:\r\r\nN - это количество исполнено\r\r\nК = N-a-b-c-d\r\r\na - количество, которое напрямую из заказа ушло в документ Товар - Себестоимость (кнопка "импорт из заказа")\r\r\nb - количество, которое напрямую из заказа ушло в документ Спецификация (импорт) (кнопка "импорт из заказа")\r\r\nc - количество, которое напрямую из заказа ушло в документ Заявка на доставку (поступление товаров) (кнопка "импорт из заказа")\r\r\nd - количество, которое напрямую из заказа ушло в документ Сборка-разборка  (кнопка "импорт из заказа")
222	Order.ord_num_conf	Длина 200 знаков
223	ContractorRequest.contractorOther.name	Здесь следует указывать ПРОДАВЦА (юрлицо по контракту, указанному в поле "Договор покупки оборудования")
224	ProduceCostProduce.purpose.name	1.\r\r\nинфо тянется из: "Спецификации (импорт)" (там можно редактировать) - "Заявки на доставку (поступление товаров)" (там можно редактировать)\r\r\n2.\r\r\nПоле доступно для редактирования, если табличная часть заполняется через "Добавить".
225	CommercialProposal.cpr_date_accept	здесь Акцепт - согласие контрагента заключить договор на условиях, указанных в коммерческом предложении.
226	CommercialProposals.CommercialProposalsCurrentStatus	зелёный квадрат - если чекбокс "акцептовано" = да\r\r\nкрасный квадрат - если чекбокс "отклонено" = да
233	Orders.ord_show_movement	Если чекбокс отмечен, то в колонке "Текущее состояние" после всех сообщений указываются документы, в которые попали позиции из заказа (каждая группа документов с новой строки, внутри группы доки через запятую, наименования групп указываются):\r\r\n- номера и даты сборок/разборок\r\r\n- номера и даты спецификаций(импорт)\r\r\n- номера и даты документов "товар-себестоимость"
234	Contract.currency.name	Невозможно редактирование при наличии хотя бы одной спецификации, на которую есть ссылка в других документах (надо проверить документы: заказы, опалты и отгрузки).
235	ConditionsForContract.ConditionsForContract.date	Данный фильтр влияет только на отображение "исполенных" заявок. Данный фильтр не влияет на отображение "не размещенных" и "не исполненных" заявок, они отображаются в любом случае.
\.


--
-- Data for Name: dcl_files_path; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_files_path (flp_id, flp_table_name, flp_path, flp_description) FROM stdin;
1	DCL_USER	D:\\\\dcl\\\\attachments\\\\DCL_USER\\\\	Путь к файлам: "Факсимиле пользователя"
2	DCL_CON_LIST_SPEC	D:\\\\dcl\\\\attachments\\\\DCL_CON_LIST_SPEC\\\\	Путь к файлам документа "Спецификация"
3	DCL_COND_FOR_CONTRACT	D:\\\\dcl\\\\attachments\\\\DCL_COND_FOR_CONTRACT\\\\	Путь к файлам документа "Условия для составления договора (контракта)"
4	DCL_CONTRACT	D:\\\\dcl\\\\attachments\\\\DCL_CONTRACT\\\\	Путь к файлам документа "Договор"
5	DCL_CONTRACTOR_REQUEST	D:\\\\dcl\\\\attachments\\\\DCL_CONTRACTOR_REQUEST\\\\	Путь к файлам документа "Заявка от контрагента"
6	DCL_GOODS_IN_LITHUANIA	D:\\\\dcl\\\\attachments\\\\DCL_GOODS_IN_LITHUANIA\\\\	Путь к файлам отчета "Остатки товаров в Литве"
7	DCL_INSTRUCTION	D:\\\\dcl\\\\attachments\\\\DCL_INSTRUCTION\\\\	Путь к файлам документа "Приказы, распоряжения, инструкции"
8	DCL_ORDER	D:\\\\dcl\\\\attachments\\\\DCL_ORDER\\\\	Путь к файлам документа "Заказ"
9	DCL_OUTGOING_LETTER	D:\\\\dcl\\\\attachments\\\\DCL_OUTGOING_LETTER\\\\	Путь к файлам документа "исходящие письма"
10	DCL_PRODUCE	D:\\\\dcl\\\\attachments\\\\DCL_PRODUCE\\\\	Путь к файлам справочника "Номенклатура"
11	DCL_TEMPLATE	D:\\\\dcl\\\\attachments\\\\DCL_TEMPLATE\\\\	Путь к шаблонам документов
12	DCL_WOODWORK_WORK_FILES	D:\\\\dcl\\\\attachments\\\\DCL_TEMPLATE\\\\	Путь к рабочим файлам для "Сервис (деревообработка)"
\.


--
-- Data for Name: dcl_inf_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_inf_message (inm_id, usr_id, inm_create_date, inm_message) FROM stdin;
10	1	2026-02-15 08:46:28.487075	Суффиксы -ок, -ек.<br>После шипящих под ударением пишется -ок: волч<b>ок</b>, петуш<b>ок</b>, сапож<b>ок</b>. <br>Суффикс -ек после шипящих пишется в том случае, если на него не падает ударение: ножич<b>ек</b>, ореш<b>ек</b>.<br><br>Проверь себя! КОЛПАЧ_К
11	1	2026-02-15 08:47:48.654498	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br>После отправки в Литву оригиналы заказа и сопроводительного письма следует сдать минскому логисту.</td></tr></table></div>
12	1	2026-02-15 09:03:53.082895	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br>После отправки в Литву оригиналы заказа и сопроводительного письма следует сдать минскому логисту.</td></tr></table></div>
13	1	2026-02-15 09:35:31.145986	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br><b>В справочнике &quot;Номенклатура&quot; есть Болт на 18, который производит фирма А. Точно такой же болт надо заказать у фирмы Б, которая его тоже производит. Что делать? Добавлять новую позицию с новым производителем?</b><br><br>В этом и подобных случаях, чтобы не плодить &quot;двойников&quot; в справочнике и чтобы связать уже имеющуюся позицию с новым производителем, надо:<br>&nbsp;&nbsp; &nbsp; 1. найти позицию в справочнике &quot;Номенклатура&quot;<br>&nbsp;&nbsp; &nbsp; 2. нажать кнопку &quot;...&quot; (Редактировать товар);<br>&nbsp; &nbsp;&nbsp; 3. в окне редактирования нажать кнопку &quot;Добавить производителя&quot;<br>&nbsp; &nbsp;&nbsp; 4. в появившихся полях указать наименование производителя и № по каталогу.<br><br>Количество производителей, которое может быть привязано к одной позиции, не ограничено.</td></tr></table></div>
14	1	2026-02-15 10:09:58.631938	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br><b>Хочу отредактировать позицию в справочнике &quot;Номенклатура&quot;, но она заблокирована. Почему? Что делать?</b><br><br>Поля &quot;Наименование товара&quot;, &quot;Тип&quot;, &quot;Основные параметры&quot;, &quot;Доп. параметры&quot;, &quot;Ед. изм.&quot;, &quot;Производитель&quot;, &quot;№ по каталогу&quot; автоматически становятся read-only, если позиция попала хотя бы в один электронный документ.<br><br>Варианты действий:<ul><li>Если позиция создана буквально только что и пользователь заметил ошибку, добавив её, например, в Заказ, то позицию надо удалить из Заказа, и она станет доступной для редактирования.</li><li>В остальных случаях - обратиться к администратору DCL.</li></ul></td></tr></table></div>
15	1	2026-02-15 12:12:48.930468	<b>Менеджер!!! Нашёл нового заказчика – вышли данные в отдел маркетинга для включения в электронную рассылку новостей!!!</b>
16	1	2026-02-15 12:37:35.929502	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br>Если Вам надо узнать текущее состояние дел по какому-нибудь контрагенту (что отгружено, что оплачено, есть ли просрочки по отгрузкам и/или оплатам, какие меры приняты по взысканию долгов и т.п.), то используйте <font color="#0000FF"><b>отчёт &quot;Состояние расчётов&quot;</b></font>.</p></td></tr></table></div>
17	1	2026-02-15 12:50:13.957438	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br>Поступившая оплата. При необходимости менеджер может самостоятельно распределить (указать/поменять контрагента, прикрепить к договору и спецификации) поступившую оплату. (Это можно сделать только с незаблокированным документом.)<br><br><i>Журналы - Оплаты - Найти нужную оплату - Нажать &quot;...&quot; - Нажать &quot;Добавить&quot; - Выбрать договор и спецификацию, указать сумму - Сохранить</i></td></tr></table></div>
18	1	2026-02-15 12:53:13.602549	<div align="center"><table border="0" width="50%"><tr><td><b>FAQ &amp; tips</b><br><br>Поступившая оплата. При необходимости менеджер может самостоятельно распределить (указать/поменять контрагента, прикрепить к договору и спецификации) поступившую оплату. (Это можно сделать только с незаблокированным документом.)<br><br><i>Журналы - Оплаты - Найти нужную оплату - Нажать &quot;...&quot; - Нажать &quot;Добавить&quot; - Выбрать договор и спецификацию, указать сумму - Сохранить</i></td></tr></table></div>
\.


--
-- Data for Name: dcl_instruction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_instruction (ins_id, ins_create_date, usr_id_create, ins_edit_date, usr_id_edit, ist_id, ins_number, ins_date_sign, ins_date_from, ins_date_to, ins_concerning) FROM stdin;
\.


--
-- Data for Name: dcl_instruction_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_instruction_type (ist_id, ist_name) FROM stdin;
1	Приказ
2	Распоряжение
3	инструкция
4	Шаблоны и образцы
5	Бланки
\.


--
-- Data for Name: dcl_language; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_language (lng_id, lng_name, lng_letter_id) FROM stdin;
1	Русский	RU
2	English	EN
3	Lietuvių	LT
\.


--
-- Data for Name: dcl_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_log (log_id, act_id, usr_id, log_time, log_ip) FROM stdin;
26	1	1	2026-02-15 14:52:00.503752	172.31.121.226
27	1	1	2026-02-15 18:11:18.834062	172.31.83.226
28	1	1	2026-02-15 18:32:49.689149	172.31.83.226
29	1	1	2026-02-15 18:35:08.733067	172.31.83.226
30	1	1	2026-02-16 10:16:17.268711	[0:0:0:0:0:0:0:1]
31	1	1	2026-02-16 10:23:53.985256	172.31.98.2
32	1	1	2026-02-16 10:28:50.400231	[0:0:0:0:0:0:0:1]
33	1	1	2026-02-16 10:29:00.844171	[0:0:0:0:0:0:0:1]
34	1	1	2026-02-16 10:31:09.612426	[0:0:0:0:0:0:0:1]
35	1	1	2026-02-16 10:34:17.779776	172.31.98.2
36	1	1	2026-02-16 10:37:36.661885	[0:0:0:0:0:0:0:1]
37	1	1	2026-02-16 10:54:26.319031	172.31.98.2
38	1	1	2026-02-16 10:59:25.18062	[0:0:0:0:0:0:0:1]
39	1	1	2026-02-16 11:01:17.004728	172.31.98.2
40	1	1	2026-02-16 11:04:04.533273	[0:0:0:0:0:0:0:1]
41	1	1	2026-02-16 11:06:02.706114	172.31.98.2
42	1	1	2026-02-16 11:19:49.956634	172.31.98.2
43	1	1	2026-02-16 11:32:47.543087	127.0.0.1
44	1	1	2026-02-16 11:34:25.514678	172.31.98.2
45	1	1	2026-02-16 11:35:17.072082	172.31.98.2
46	1	1	2026-02-16 11:36:27.976268	127.0.0.1
47	1	1	2026-02-16 11:37:17.368241	172.31.98.2
48	1	1	2026-02-16 11:39:57.211178	127.0.0.1
49	1	1	2026-02-16 11:41:12.71075	127.0.0.1
50	1	1	2026-02-16 11:41:22.344677	172.31.98.2
51	1	1	2026-02-16 12:05:46.222229	172.31.98.2
52	1	1	2026-02-16 12:11:01.960214	[0:0:0:0:0:0:0:1]
53	1	1	2026-02-16 12:12:06.648943	172.31.98.2
54	1	1	2026-02-16 12:16:30.551277	172.31.98.2
55	1	1	2026-02-16 12:26:48.957499	[0:0:0:0:0:0:0:1]
56	1	1	2026-02-16 19:40:09.35005	172.31.98.2
57	1	1	2026-02-16 19:40:30.186174	127.0.0.1
58	1	1	2026-02-17 10:36:56.345783	127.0.0.1
59	1	1	2026-02-17 10:37:18.147062	127.0.0.1
60	1	1	2026-02-17 10:38:36.447204	127.0.0.1
61	1	1	2026-02-17 10:40:19.695016	127.0.0.1
62	1	1	2026-02-17 10:45:58.017185	127.0.0.1
63	1	1	2026-02-17 10:46:14.01692	127.0.0.1
64	1	1	2026-02-17 10:56:49.110993	[0:0:0:0:0:0:0:1]
65	1	1	2026-02-17 10:57:00.119336	[0:0:0:0:0:0:0:1]
66	1	1	2026-02-17 10:57:18.631941	127.0.0.1
67	1	1	2026-02-17 10:58:41.906323	127.0.0.1
68	1	1	2026-02-17 10:59:03.618335	127.0.0.1
69	1	1	2026-02-17 11:01:57.979065	172.31.68.2
70	1	1	2026-02-17 11:13:43.671605	127.0.0.1
71	1	1	2026-02-17 11:14:00.614643	172.31.68.2
72	1	1	2026-02-17 11:25:01.222735	127.0.0.1
73	1	1	2026-02-17 11:29:44.282861	127.0.0.1
74	1	1	2026-02-17 11:33:36.545038	127.0.0.1
75	1	1	2026-02-17 11:46:40.988822	172.31.68.2
76	1	1	2026-02-17 11:47:48.498088	127.0.0.1
77	1	1	2026-02-17 11:52:56.330715	127.0.0.1
78	1	1	2026-02-17 12:15:44.796529	172.31.68.2
\.


--
-- Data for Name: dcl_lps_list_manager; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_lps_list_manager (lmn_id, lps_id, usr_id, lmn_percent) FROM stdin;
\.


--
-- Data for Name: dcl_montage_adjustment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_montage_adjustment (mad_id, stf_id, mad_machine_type, mad_complexity, mad_annul) FROM stdin;
\.


--
-- Data for Name: dcl_montage_adjustment_h; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_montage_adjustment_h (madh_id, mad_id, mad_date_from, mad_mech_work_tariff, mad_mech_work_rule_montage, mad_mech_work_rule_adjustment, mad_mech_road_tariff, mad_mech_road_rule, mad_el_work_tariff, mad_el_work_rule_montage, mad_el_work_rule_adjustment, mad_el_road_tariff, mad_el_road_rule, mad_mech_total, mad_el_total) FROM stdin;
\.


--
-- Data for Name: dcl_opr_list_executed; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_opr_list_executed (opr_id, opr_count_executed, opr_date_executed, opr_fictive_executed) FROM stdin;
\.


--
-- Data for Name: dcl_ord_list_pay_sum; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ord_list_pay_sum (ops_id, ord_id, ops_sum, ops_date) FROM stdin;
\.


--
-- Data for Name: dcl_ord_list_payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ord_list_payment (orp_id, ord_id, orp_percent, orp_sum, orp_date) FROM stdin;
\.


--
-- Data for Name: dcl_ord_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ord_list_produce (opr_id, ord_id, opr_produce_name, opr_catalog_num, opr_count, opr_price_brutto, opr_discount, opr_price_netto, opr_summ, opr_use_prev_number, prd_id, opr_comment, drp_price, ctr_id, spc_id, opr_parent_id, opr_have_depend, drp_max_extra) FROM stdin;
\.


--
-- Data for Name: dcl_ord_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ord_message (orm_id, ord_id, usr_id, orm_create_date, orm_message, prc_id) FROM stdin;
\.


--
-- Data for Name: dcl_order; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_order (ord_id, ord_create_date, usr_id_create, ord_edit_date, usr_id_edit, ord_number, ord_date, ctr_id, cps_id, ord_concerning, ord_preamble, trm_id, ord_addr, ord_pay_condition, ord_delivery_term, ord_add_info, usr_id_director, usr_id_logist, usr_id_director_rb, usr_id_chief_dep, usr_id_manager, ctr_id_for, spc_id, stf_id, ord_sent_to_prod_date, ord_received_conf_date, ord_num_conf, ord_date_conf, ord_conf_sent_date, ord_executed_date, ord_summ, ord_block, ord_delivery_cost_by, ord_delivery_cost, ord_donot_calculate_netto, cur_id, ord_include_nds, ord_nds_rate, ord_discount_all, ord_discount, ord_count_itog_flag, ord_add_reduction_flag, ord_add_reduction, ord_add_red_pre_pay_flag, ord_add_red_pre_pay, ord_all_include_in_spec, ord_annul, ord_ready_for_deliv_date, ord_in_one_spec, ord_comment, ord_date_conf_all, ord_ready_for_deliv_date_all, sdt_id, ord_shp_doc_number, ord_by_guaranty, bln_id, ord_arrive_in_lithuania, ord_ship_from_stock, ord_print_scale, ord_letter_scale, ord_comment_covering_letter, sln_id, sln_id_for_who, ord_logist_signature, ord_director_rb_signature, ord_chief_dep_signature, ord_manager_signature) FROM stdin;
\.


--
-- Data for Name: dcl_outgoing_letter; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_outgoing_letter (otl_id, otl_create_date, usr_id_create, otl_edit_date, usr_id_edit, otl_number, otl_date, ctr_id, cps_id, otl_comment, sln_id) FROM stdin;
\.


--
-- Data for Name: dcl_pay_list_summ; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_pay_list_summ (lps_id, pay_id, spc_id, lps_summ, lps_summ_eur, lps_summ_out_nds) FROM stdin;
\.


--
-- Data for Name: dcl_pay_message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_pay_message (pms_id, pay_id, usr_id, pms_create_date, pms_message, pms_sum, ctr_id, pms_percent, pms_check_for_delete, pms_updated, cur_id, pms_no_curator) FROM stdin;
\.


--
-- Data for Name: dcl_payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_payment (pay_id, pay_create_date, usr_id_create, pay_edit_date, usr_id_edit, pay_date, pay_account, pay_summ, cur_id, pay_course, ctr_id, pay_block, pay_comment, pay_course_nbrb, pay_course_nbrb_date) FROM stdin;
\.


--
-- Data for Name: dcl_prc_ctr_for_calcstate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_prc_ctr_for_calcstate (lpc_id, prc_id, ctr_id, con_id, spc_id) FROM stdin;
\.


--
-- Data for Name: dcl_prc_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_prc_list_produce (lpc_id, prc_id, lpc_produce_name, stf_id, usr_id, lpc_count, lpc_cost_one, lpc_weight, lpc_summ, lpc_sum_transport, lpc_custom, prs_id, prd_id, lpc_cost_one_ltl, opr_id, drp_id, sip_id, lpc_1c_number, lpc_percent, apr_id, asm_id, lpc_comment, dep_id, lpc_cost_one_by, lpc_price_list_by) FROM stdin;
\.


--
-- Data for Name: dcl_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_produce (prd_id, cat_id, prd_name, prd_type, prd_params, prd_add_params, unt_id, cus_code, prd_block, prd_create_date, usr_id_create, prd_edit_date, usr_id_edit, prd_block_date, usr_id_block, prd_material, prd_purpose, prd_specification, prd_principle, prd_not_check_double) FROM stdin;
17	1	Полумуфта гидравлическая		HP20-2-L2230		1	7307291008	\N	\N	\N	\N	\N	\N	\N					\N
21	1	Гидрозамок		Z2S 6-4-6X/V		1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	1	Гидрозамок		Z2S 10-4-3X/V		1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
53	1	Держатель электронной карты				1	8536901000	\N	\N	\N	\N	\N	\N	\N	Пластик	Приспособление для монтажа электронных плат (карт) в шкафах управления технологическим оборудованием. Общепромышленного применения.	Для монтажа электронных карт в формате Евро-формат 32 pin.\r\r\nКолличество мест: 1;\r\r\n	Держатель электронной карты крепится в шкафу управления. В его специальные пазы вставляется элетронная карта управления.	\N
63	1	Клапан обратный		RHD 16 PS1		1	\N	\N	\N	\N	\N	\N	\N	\N					\N
47	2	Фильтр напорный		ML.240.10VG.HR.E.P.-.G.5.C.S1.AE70.2,5.P.-.-		1	8421290009	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	3	Круг алмазный	Evolution	230*2,4*22,2	Cool Formula	1	6804210000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	3	Круг отрезной	Special	115*2*22,2	AS 30 T/T41	1	6804221800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	3	Круг отрезной по металлу	Special	230*2.2*22	AS 30 INOX	1	6804221800	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	3	Чашка шлифовальная		110/90*55*22,2	АS 16Q	1	6804223000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
25	10	Регулятор потока Z2FS 6-2-4X/2QV	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
51	10	Ролики	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	10	Материалы смазочные антикоррозийные (в 5-ти литровой канистре)	HF 95Y			4	3403991000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	10	Регулятор потока Z2FS 10-5-3X/V	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	10	Передача волновая для SIEMENSMOTOREN 1FK6 060	HFUC-40-100-2UH-SP			1	8483409000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	10	Плата управления электронная		VT-VRPA 1-527-10/V0/QV-RTP		1	8534009000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	10	Плита промежуточная				1	7326909809	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	10	Плита соединительная 1 815 503 013	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	10	Карта-усилитель электронная		VT 3000-3X/		1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	10	Блок клапанов гидравлический по схеме № UAB0-0503-4435-A				1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: dcl_produce_cost; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_produce_cost (prc_id, prc_create_date, usr_id_create, prc_edit_date, usr_id_edit, prc_number, prc_date, rut_id, prc_sum_transport, prc_block, prc_course_ltl_eur, prc_weight) FROM stdin;
\.


--
-- Data for Name: dcl_produce_cost_custom; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_produce_cost_custom (prc_id, lpc_percent, lpc_summ, lpc_summ_allocation) FROM stdin;
\.


--
-- Data for Name: dcl_produce_language; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_produce_language (prd_id, lng_id, prd_lng_name) FROM stdin;
17	3	Kupplungs-Muffe
53	2	Holder
53	3	Holder
\.


--
-- Data for Name: dcl_production_term; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_production_term (ptr_id, opr_id, ptr_count, ptr_date, ptr_comment) FROM stdin;
\.


--
-- Data for Name: dcl_purchase_purpose; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_purchase_purpose (pps_id, pps_name) FROM stdin;
1	для собственного производства
2	для собственного потребления
3	для собственного производства и (или) потребления
4	для оптовой торговли
5	для розничной торговли
6	для переработки на давальческих условиях
7	для поставки для государственных нужд
8	для оптовой и (или) розничной торговли
\.


--
-- Data for Name: dcl_purpose; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_purpose (prs_id, prs_name) FROM stdin;
1	Товар
2	Образец
3	Fair Trade
4	Остатки после монтажа оборудования
5	Fair Trade (Неисправное)
6	Ремонт (гарантийный / платный)
7	Для собственных нужд ЛТС
8	Реклама
9	Служебная позиция
\.


--
-- Data for Name: dcl_rate_nds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_rate_nds (rtn_id, rtn_date_from, rtn_percent) FROM stdin;
1	2005-01-01	18.00
2	2009-09-10	18.00
3	2010-01-01	20.00
\.


--
-- Data for Name: dcl_ready_for_shipping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_ready_for_shipping (rfs_id, opr_id, sdt_id, rfs_number, rfs_count, rfs_date, rfs_weight, rfs_gabarit, rfs_comment, rfs_arrive_in_lithuania, rfs_ship_from_stock) FROM stdin;
\.


--
-- Data for Name: dcl_reputation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_reputation (rpt_id, rpt_level, rpt_description, rpt_default_in_ctc) FROM stdin;
1	0	<b><font color="red">ЛИКВИДИРОВАН / БАНКРОТ</font></b>	\N
2	0	<b><font color="red">ЗЛОСТНЫЙ НЕПЛАТЕЛЬЩИК</font></b>	\N
3	1	<b>Клиент-новичок (предоплата 100%)</b>	1
4	2	<b>Доверительные отношения</b>	\N
5	5	<b>VIP-клиент</b>	\N
6	1	<b><font color="red">Предоплата 100% (т.к. просрочки по оплатам)</font></b>	\N
7	2	<b>Предоплата 100%</b>	\N
\.


--
-- Data for Name: dcl_rests_in_minsk_temporary; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_rests_in_minsk_temporary (id, date_created, quantity, contractor_name, specification_number, contract_number) FROM stdin;
\.


--
-- Data for Name: dcl_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_role (rol_id, rol_name) FROM stdin;
1	Администратор
2	Менеджер
3	Таможенный декларант
4	Экономист
5	Юрист
6	Сотрудники в Литв
7	Прочие сотрудник
8	Работник сервиса
9	Логистик
\.


--
-- Data for Name: dcl_route; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_route (rut_id, rut_name) FROM stdin;
1	РБ-Клиент
2	Литва-Клиент
3	Производитель-Клиент
4	Латвия-Клиент
6	Эстония-Клиент
\.


--
-- Data for Name: dcl_seller; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_seller (sln_id, sln_name, sln_used_in_order, sln_prefix_for_order, sln_is_resident) FROM stdin;
0	ЗАО "Линтера"	1	BYM	\N
1	ООО "Линтера ТехСервис"	1	BYM	1
2	Прочие	\N	\N	\N
4	UAB "SMERKONA"	1	SME	\N
5	ООО "Кропа Техсервис"	\N	\N	1
6	UAB "LinterР° - baldu technologijos"	1	LBT3	\N
7	UAB вЂњLintera, automatika ir technikaвЂњ	1	LAT	\N
\.


--
-- Data for Name: dcl_setting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_setting (stn_id, stn_name, stn_description, stn_value, stn_type, stn_action, stn_value_extended) FROM stdin;
1	ui.letterHeadNoticeForShipping	Бланк для документа Отгрузка для печати извещения	1	1	BlanksListAction	Линтера ТехСервис
2	ui.contractorWhereNoticeForShipping	Контрагент для документа Отгрузка для печати извещения	1	1	ContractorsListAction	Линтера ЗАО
3	ui.commonBlankLight1	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца ЗАО "Линтера"	9	1	BlanksListAction	Линтера
4	ui.commonBlankLight2	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца иП "ЛинтераТехСервис"	8	1	BlanksListAction	Линтера ТехСервис
5	ui.commonBlankLight3	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца Прочие	9	1	BlanksListAction	Линтера
6	ui.letterRequestBlank	Бланк для документа Заявка от контрагента для печати Письма-заявки	10	1	BlanksListAction	Линтера ТехСервис
7	defaultPurposeProduce	Назначение (для поступающих товаров) по умолчанию - Товар	1	1	PurposesListAction	Товар
8	defaultPurposeFairTrade	Назначение (для поступающих товаров) по умолчанию - Fair Trade	3	1	PurposesListAction	Fair Trade
9	defaultNomenclatureBlank	Бланк по умолчанию для печати Технического описания из справочника Номенклатура	7	1	BlanksListAction	Линтера ТехСервис
10	defaultNomenclatureUnit	Ед. изм. по умолчанию для справочника Номенклатура	1	1	UnitsListAction	шт
11	lengthNumber1C	Длинна строки для инвентарного номера в 1С	12	0	\N	\N
12	maxReputationLevel	Максимальное значене уровня для Репутации	5	0	\N	\N
13	attachmentsDir	Каталог, куда складываются файлы. Каталог должен существовать!	%HOME%/../attachments	0	\N	\N
14	importResultsDir	Каталог, куда складываются файлы с результатами импортов из Excel. Каталог должен существовать!	%HOME%/import-results	0	\N	\N
15	nomenclatureProduceMainLang	Основной язык справочника Номенклатура. Двухбуквенное обозначение.	RU	0	\N	\N
16	defaultGuarantyServiceActBlank	Бланк для печати Акта для Гарантийные работы / Платные (сервисные) работы	7	1	BlanksListAction	ЛТС (Общий бланк с реквизитами)
17	defaultCPInvoiceBlank	Бланк для печати с-ф из документа "Коммерческое предложение"	7	1	BlanksListAction	ЛТС (Общий бланк с реквизитами)
18	defaultCPCurrency	Валюта "по умолчанию" документа "Коммерческое предложение"	EUR	0	\N	\N
19	defaultCPTableCurrency	Валюта таблицы "по умолчанию" документа "Коммерческое предложение"	EUR	0	\N	\N
20	defaultPurposeGuaranteeRepair	Назначение при отмеченном флаге "Запчасти для гарантийного ремонта" - Гарантийный ремонт	6	1	PurposesListAction	Гарантийный ремонт
21	contractorLinteraRequestPrint	Контрагент, откуда берутся данные при печати "Заявки от Линтеры" в документе "Заявка от контрагента"	5	1	ContractorsListAction	Линтера ТехСервис
22	blankLinteraRequestPrint	Бланк, используемый при печати "Заявки от Линтеры" в документе "Заявка от контрагента"	6	1	BlanksListAction	Русский
23	dayCountDeductShippingPositions	Документ "Отгрузка" -> Редактировать таблицу.\r\r\n\r\r\nНастройка поля "Не отображать партии старше:" в фильтре. Количество дней, которые нужно отнять	1825	0	\N	\N
24	routeProducesForAssembleMinsk	Маршрут по умолчанию при выборе позиций в КП для варианта "КП составляется по товару, который лежит на складе в Минске"=ДА	1	1	RoutesListAction	РБ-Клиент
26	contractorLTS	Контрагент. Его контактные лица будут отображаться в поле "От ЛТС договор подпишет:" в КП (КП составляется по товару, который лежит на складе 	5	1	ContractorsListAction	Линтера ТехСервис
27	dayCountWaitReservedForShipping	Количество дней ожидания отгрузки для зарезервировнных позиций в КП, которое акцептовано. (Если КП акцептовано, то к сроку его действия доб�	30	0	\N	\N
28	runEveryDayTaskCronScheduler	Строка задает расписание запуска служебной ежедневной задачи. 0 0 3 * * ? - 3 часа ночи ежедневно. Примеры как нужно задавать расписание можно см	0 0 3 * * ?	0	\N	\N
29	retailTradePurpose	Цель - розничная торговля. Для специфической обработки в КП:\r\r\nЕсли в КП "Цель приобретения товара:" = для розничной торговли, то:\r\r\n"Прод. цена, BYR"	5	1	PurchasePurposesListAction	для розничной торговли
30	drpPriceCoefficient	Защита от "дураков". Коэффициент для контроля поля "Продажная цена за единицу без НДС, бел.руб."\r\r\nДля документов "Заказ", "Заявка на доставку".	1.5	0	\N	\N
31	cpToContractImportAsmMinskSeller	Продавец. Заполняется при импорте Договора из Коммерческого предложения для случая когда "КП составляется по товару, который лежит на скла�	1	1	SellersListAction	ООО "Линтера ТехСервис"
32	minCourseCoefficient	Коэффициент для расчета рекомендуемого min курса в КП (Курс НБРБ*коэф-т)	1.1	0	\N	\N
33	dayCountDeductShippings	Количество дней, которые нужно отнять от текущей даты в фильтре журнала отгрузок	10	0	\N	\N
34	dayCountDeductPayments	Количество дней, которые нужно отнять от текущей даты в фильтре журнала оплат	10	0	\N	\N
35	dayCountDeductCommercialProposals	Количество дней, которые нужно отнять от текущей даты в фильтре журнала коммерческих предложений	60	0	\N	\N
36	dayCountDeductConditionsForContract	Количество дней, которые нужно отнять от текущей даты в фильтре журнала условий для соствления договора	10	0	\N	\N
37	defaultSpcAdditionalDaysCount	Значение по-умолчанию поля "+ (плюс) календарных дней" при ипорте данных из Коммерческого предложения в Контракт	30	0	\N	\N
38	dayCountDeductDeliveryRequests	Количество дней, которые нужно отнять от текущей даты в фильтре журнала заявки на доставку.	10	0	\N	\N
39	deleteUserMessagesPeriod	Срок хранения сообщений в Кабинете менеджера, дни	90	0	\N	\N
40	timeOutForNoForProduceError	В справочн. Номенклатура.\r\r\n<br>Время ожидания до активации кнопки:\r\r\n<br>"Нет" в сообщ о том, что\r\r\n<br>- в наим-и 1м словом должно быть существительное,	15	0	\N	\N
41	blankSmerkonaRequestPrint	Бланк, используемый при печати "Заявки от UAB "SMERKONA" в документе "Заявка от контрагента"	6	1	BlanksListAction	Русский
42	blankKropaRequestPrint	Бланк, используемый при печати "Заявки от ООО "Кропа Техсервис" в документе "Заявка от контрагента"	6	1	BlanksListAction	Русский
43	blankLBTRequestPrint	Бланк, используемый при печати "Заявки от UAB "Linterа - baldu technologijos" в документе "Заявка от контрагента"	6	1	BlanksListAction	Русский
44	blankLATRequestPrint	Бланк, используемый при печати UAB “Lintera, automatika ir technika“ в документе "Заявка от контрагента"	6	1	BlanksListAction	Русский
45	blankSmerkonaActPrint	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца UAB "SMERKONA"	6	1	BlanksListAction	Русский
46	blankKropaActPrint	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца ООО "Кропа Техсервис"	6	1	BlanksListAction	Русский
47	blankLBTActPrint	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца UAB "Linterа - baldu technologijos"	6	1	BlanksListAction	Русский
48	blankLATActPrint	Бланк для документа Заявка от контрагента для печати Акта для ответсвенного продавца UAB “Lintera, automatika ir technika“	6	1	BlanksListAction	Русский
49	global.dev-mode	Development mode flag	true	1	\N	\N
\.


--
-- Data for Name: dcl_shipping; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_shipping (shp_id, shp_create_date, usr_id_create, shp_edit_date, usr_id_edit, shp_number, shp_date, spc_id, shp_summ_plus_nds, cur_id, shp_block, ctr_id, shp_date_expiration, shp_letter1_date, shp_letter2_date, shp_letter3_date, shp_complaint_in_court_date, shp_comment, shp_montage, ctr_id_where, con_id_where, shp_notice_date, shp_serial_num_year_out, shp_summ_transport, shp_original, shp_sum_update) FROM stdin;
\.


--
-- Data for Name: dcl_shp_doc_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_shp_doc_type (sdt_id, sdt_name) FROM stdin;
1	Delivery note
2	Versandauftrag
3	Invoice
4	Rechnung/Invoice
5	Lieferschein
6	Termin-/Gewichtsavis в„–LS
7	Tracking-number
8	Versand-/AbholbestГ¤tigung
9	Packing list
10	Shipping instruction
11	PROFORMA INVOICE
12	Shipment Receipt
13	SPEDITIONSAUFTRAG
14	shipping/collection confirmation
15	TRANSPORTAUFTRAGS-LISTE
16	MISE A DISPOSITION URGENT
17	BALT
18	E-Mail/Telefonat
19	Transportauftrag
20	Order Confirmation/Auftragsbestaetigung
21	Durchschrift der Ausfuhranmeldung
22	PackstГјckliste
23	Pick up of machine
24	TNT
25	Documento di trasporto
26	Ladeliste
27	EMS
28	Lieferung-Kommissionierbeleg
29	DOCUMENTO DI TRANSPORTO
30	Versandauftrag/Ladeliste
31	SKYPE
32	CMR/Internationaler Frachtbrief
33	Dispatch advice
34	Waybill
35	Versandavis
36	Verladeliste_Transportauftrag
\.


--
-- Data for Name: dcl_shp_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_shp_list_produce (lps_id, shp_id, lpc_id, stf_id, lps_count, lps_summ_plus_nds, lps_enter_in_use_date, lps_montage_time, lps_montage_off, shp_date, lps_serial_num, lps_year_out, lpr_id) FROM stdin;
\.


--
-- Data for Name: dcl_spc_list_payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_spc_list_payment (spp_id, spc_id, spp_percent, spp_sum, spp_date) FROM stdin;
\.


--
-- Data for Name: dcl_specification_import; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_specification_import (spi_id, spi_create_date, usr_id_create, spi_edit_date, usr_id_edit, spi_number, spi_date, spi_comment, spi_course, spi_koeff, spi_arrive, spi_cost, spi_send_date) FROM stdin;
\.


--
-- Data for Name: dcl_spi_list_produce; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_spi_list_produce (sip_id, spi_id, drp_id, sip_price, sip_count, sip_cost, sip_weight, prd_id, opr_id, prs_id, sip_percent) FROM stdin;
\.


--
-- Data for Name: dcl_stuff_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_stuff_category (stf_id, stf_name, stf_show_in_montage) FROM stdin;
1	BRL (с 01.09.07 не использовать!!!)	\N
2	White Hydraulics	\N
3	Stabilus	\N
4	Voswinkel	\N
6	BRL-MT	\N
7	Vitap	\N
8	Maggi	1
9	Stehle	\N
10	Al-Ko	1
11	Dronco	\N
12	CP	\N
13	Fein	\N
14	Karnasch	\N
15	Rothermundt	\N
16	GF	\N
17	Enerpac	\N
18	Moeller	\N
19	Buerkle	1
20	Simrit	\N
21	Brinkmann Pumps	\N
22	BRM	\N
23	BRP	\N
24	BRS	\N
25	Chapel	\N
26	Dietzel	\N
27	FAG	\N
28	Harmonic Drive	\N
29	INA	\N
30	Internormen	\N
31	Kabelschlepp	\N
32	Kullen	\N
33	Stauff	\N
34	Suco	\N
35	Tidlo	\N
36	Torwegge	1
37	Walterscheid	\N
38	Weeke	1
39	WIKA	\N
40	BRC	\N
41	BRI	1
42	Trumpf	\N
43	Norbar	1
44	Rojek	1
45	Schmalz	\N
46	SKF	\N
47	Kuper	1
48	Hidrobalt	\N
49	Brandt	1
50	R+W	\N
51	Stark	\N
52	Сервис (с 01.01.2010 не использовать)	\N
53	Прочее (!!! не использовать !!!)	\N
54	Ringspann	\N
55	Cein	\N
56	Siemens	\N
57	Martin	1
58	Pfluger	\N
59	Vogel Mob.	\N
60	Weima	1
61	Vogel Ind.	\N
62	Becker	\N
63	Holzma	1
64	Momento	\N
65	LEUCO Ledermann GmbH & Co. KG	\N
66	Airfil	\N
67	Homag	1
68	Kohnle	\N
69	Ebro	\N
70	Paul	1
71	Leitz	\N
72	Unigrind	\N
73	Pister	\N
74	Jola	\N
75	Heesemann	1
76	Beta	\N
77	Formula Air Baltic (PNTS)	1
78	Holtec	\N
80	Lenze	\N
81	Andritz	\N
82	Avit	\N
83	Havit	\N
84	Houfek	1
85	BaltAir	\N
86	HyPneu	\N
87	Danfoss	1
89	S+S	1
90	Vollmer	1
91	BRL-LT	\N
92	Pilz	\N
93	Weinmann	\N
95	Equipos Ecologicos	\N
96	Katres	\N
97	Langzauner	1
98	RWT	1
99	Buetfering (поглощено Weeke, не использовать)	\N
100	Trasmital	\N
101	Centa	\N
102	NKT	1
103	INF	\N
104	N/A (с 19.02.2008 не использовать!!!)	\N
106	AKG	\N
107	Rietchle	\N
108	Fisch	\N
109	Alsante	\N
110	Kraus Naimer	\N
111	Schneider	\N
112	Reich	\N
113	Hundegger	\N
114	SEW	\N
115	Friz	1
116	Riepe	\N
117	CMB	1
118	JOOS	\N
119	Velco	\N
121	Omron	\N
122	IMA	\N
123	Facom	\N
124	EATON Fluid Connectors GmbH	\N
125	Aditec	\N
126	Lind Maskiner	\N
127	Tecfast	\N
128	Adamik	\N
129	Marzorati 	\N
130	Fachini	\N
131	So.Co.Ge.	\N
132	Atlas Copco	\N
133	Gecko Drive	\N
134	Griggio	1
136	Lippmann	\N
137	Karat	\N
138	OMC	1
139	Parker Hanifin	\N
140	JSO	\N
142	Grossi	\N
143	Graule	1
144	Sun Hydraulik	\N
145	Bonfiglioli	\N
146	Aigner	\N
147	SUMITOMO	\N
149	Delem	\N
150	Tool-Temp AG	\N
152	Kaindl	1
153	Orsta	\N
154	Sperl	\N
155	FIP	\N
156	Glynwed uab	\N
157	Vecoplan	\N
158	DUSS	\N
159	SMB	1
160	Angst+Pfister	\N
162	SSI Schaefer AG	\N
163	Wittenstein alpha	\N
164	Hundt & Weber GmbH	\N
166	Mafell	\N
167	VTS	\N
168	LAPPMILTRONIC	\N
169	Holmatro	\N
170	Isel	1
171	TorcUP	\N
172	Bargstedt	1
173	Dr. Schneider	\N
174	Schunk	\N
175	TELESIS	\N
176	Bega	1
177	Megatron	\N
178	Wigo	\N
179	HYDAC	\N
180	HYTORC	\N
181	Prewi	\N
182	SMW-AUTOBLOK	\N
183	DUPLOMATIC	\N
184	Lamello	\N
185	Hymmen	\N
187	REED	\N
188	Binos	\N
189	Brevini	\N
190	BDS Machinen	\N
191	Hermes Schleifmittel	\N
192	Big on Dry	\N
193	Equalizer	\N
194	Gesipa	\N
195	HAUBOLD	\N
196	Milwaukee	\N
197	Metal Work	\N
198	Watt Drive	\N
199	TEMAR	\N
200	Сервис (заточка Пилы)	\N
201	Сервис (заточка Алмазный инструмент)	\N
202	Druckflex	\N
204	DГјbro Werkzeug	\N
205	ASCO Joucomatic	\N
206	Heller	\N
207	Kress	\N
208	Bucher 	\N
209	DEUBLIN	\N
210	Kannenberg	\N
211	Ligmatech	1
213	Fasco	\N
214	BRFS	\N
215	HoniCel	1
217	Tawi	1
218	Laser	\N
219	Inter-Diament	\N
220	Crydom	\N
221	OSAMA Tech	1
222	Infragas	\N
223	LAMPE	\N
224	Sumake	\N
225	PROGALVANO	\N
226	Pneutrend	\N
227	URYU	\N
228	GISON	\N
229	Linak	\N
230	T-Tool	\N
231	VERTEK Group	1
232	BSP	\N
233	Mathey	\N
234	Rapha	\N
235	Schmersal	\N
236	PowerRam	\N
237	Testo	\N
238	Walter	1
239	Cooper	\N
240	Hasenfratz	\N
241	Dosatron	\N
242	Kilews	1
243	E H Wachs	\N
244	Cofim	\N
245	Taiwai Precision Tools	\N
246	Krautzberger	\N
247	Сервис ДО (Гарантийный ремонт)	\N
248	Intorex	1
249	Larzep	\N
251	Gates Fluid Power 	\N
252	BENZ Metal	\N
253	NetterVibration	\N
254	Badoni	\N
255	Сервис ДО (Платный ремонт)	\N
256	Сервис инструмент (Гарантийный ремонт)	\N
257	Сервис инструмент (Платный ремонт)	\N
258	Сервис Гидравлика (Гарантийный ремонт)	\N
259	Сервис Гидравлика (Платный ремонт)	\N
260	Shtalwille	\N
261	ATB-motors	\N
262	HS-Befestigungssysteme	\N
263	Merlin Technology	1
264	COLUMBUS McKINNON (ex Pfaff)	\N
265	GD-Thomas	\N
266	Lintera	\N
267	Balluf	\N
268	Renishaw	\N
269	Mirage	1
270	MSC Tuttlingen 	\N
271	Banner	\N
273	Aotai	\N
274	Pramet	\N
276	Piovan	\N
277	Andreoni Luigi	1
278	Fimet	\N
279	Heigl Antriebe-Konzeptionen	\N
280	RГ¶hm GmbH Sontheim	\N
281	Asiagearbox	\N
282	Schneeberger	\N
283	RadviliЕЎkio maЕЎinЕі gamykla	1
284	Rollex Forderelemente	\N
285	Zopf	\N
286	Cooperpowertools	\N
287	MMF	\N
288	DRAABE	1
289	GROB	\N
290	POLAT GROUP REDUKTOR	\N
291	KASTO	\N
292	ERD	\N
293	MBR ELECTRONICS	\N
294	Darex	\N
295	Grit	\N
296	geo-FENNEL	\N
297	Pegas	\N
298	Jahns Regulatoren GmbH	\N
299	Peter Pflueger	\N
300	WEG	\N
301	Panotec	1
302	Madejski	\N
303	WERA	\N
304	Schenker	\N
305	AAGAARD	1
307	Intercable	\N
308	Duplex	\N
309	HESPER	1
310	Nord Getriebebau	\N
311	Krone Filter	\N
312	Ringfeder	\N
313	Renold	\N
314	Andeco	\N
315	Rudnick & Enners	1
316	Pandmeta	1
317	Igus	\N
318	PEAK-System	\N
319	WINTERSTEIGER	1
320	Reinhardt	\N
321	Rudolf von Scheven	1
322	Asa hydraulik	\N
324	Iwaki	\N
326	STROINA TRANSMISSIONS	\N
327	VOLZ	\N
328	Formeco	1
329	Ardesia	\N
330	Dansk Centrifugalpumpefabrik 	\N
331	Wandres	1
332	DAN FUGT	1
333	Dynma	1
334	TriboTec	\N
335	HOFFMANN	1
336	Strack	\N
337	PTS Josef Solnar, s.r.o.	\N
338	CARL WALTER	\N
339	Brano	\N
340	Mirka	\N
343	Elfa	\N
344	Makita	\N
345	MEGAKONE	1
346	Ott-Jakob Spanntechnik	\N
347	Spray ver	1
348	Hoerbiger	\N
349	Compotec	\N
350	Ecoronder 2500	1
351	Hecht Electronic AG	1
352	Columbus	\N
353	Bezares	\N
354	Thomson	\N
355	MABA	\N
356	Koch Technology	1
358	KarlKing Standart	\N
359	Stahl CraneSystems	\N
360	Amazon	\N
361	Venjakob	\N
362	Perske	\N
363	Singlis	1
364	UMP	1
365	Getriebebau NOSSEN	\N
366	Alfa Laval	\N
367	MESUTRONIC	1
368	KWD Kupplungswerk Dresden	\N
369	STUWE	\N
370	Muesen	\N
371	Envites	\N
372	ZUCKERMANN	\N
373	SORBINI	\N
374	CEFLA	\N
375	COSTA	\N
376	SAWAMURA	\N
377	Boschert	\N
378	KAWEHA	\N
379	Vulcascot	\N
381	KTR	\N
382	Titan-intertractor	\N
384	SMC	\N
385	Uniflex	\N
386	MAWER	\N
387	BZT	1
388	FIREFLY	1
389	Cohimar	\N
390	MANN Filter	\N
391	Roquet	\N
392	Kobold	\N
393	WIKOV	\N
394	Johnson Fluiten	\N
395	Laser Level	\N
396	Kawasaki Robotics GmbH	\N
399	IMB Industrielle Messtechnik GmbH	\N
400	CONDTROL	\N
401	Autogard	\N
402	Moog GmbH	\N
403	ROSSI S.p.a.	\N
404	VARVEL Spa	\N
405	DOPAG Dosiertechnik	\N
406	AHP Merkle	\N
407	Brovind vibratori	\N
408	Varisco	\N
409	ОАО "Манометр"	\N
410	J&P machines	\N
411	Westdale Filters Ltd 	\N
412	Modus	\N
413	VEM motors GmbH	\N
414	Hawe	\N
415	ISGEV S.p.A.	\N
416	Busse	\N
417	Nordic Air Filtration A/S	\N
418	FPZ SpA	\N
419	Radicon Transmission UK Ltd.	\N
420	Euroboor	\N
421	RENK AG	\N
422	Kvarcas	\N
423	Hansa Flex	\N
424	Minco	\N
425	ASCO	\N
426	FLOWSERVE	\N
427	Pinter	\N
428	Labom	\N
430	Arviele	\N
432	Flury Systems Deutschland	\N
434	Iwiss	\N
435	Rosemaunt (Emerson Process Management)	\N
436	Rollon	\N
437	MP Filtri	\N
438	VICKERS	\N
439	MD DARIO	1
440	FLUXA FILTRI s.p.a.	\N
441	P.P.U. UNION SpГіЕ‚ka z o.o.	\N
442	Denison	\N
443	Schneider Electric	\N
444	Demag	\N
445	Continental Hydraulics	\N
446	Sami instruments srl	\N
447	HiFi Filter	\N
448	COGIF	\N
449	Emme G.	\N
450	Rollix 	\N
452	PILZ	\N
453	Baumer HГјbner GmbH	\N
454	KГјbler Group	\N
455	BETA BV	\N
456	Beckhoff	\N
457	Nikuni	\N
458	WJ projektai, UAB	\N
459	Hydrotechnik	\N
460	Schischek	\N
461	Ignera, UAB	\N
462	Autojuta	\N
463	ZF	\N
464	Fiessler	\N
465	Expo Technologies Ltd	\N
466	ITT Control Technologies	\N
467	SOR Europe Ltd	\N
468	JUNG Hebe- und Transporttechnik GmbH	\N
469	Krumplitas	\N
470	Farger & Joosten Maschinenbau GmbH	\N
472	NBP	\N
473	FUNKE	\N
474	Stober	\N
475	MCR	\N
476	Heidenhain	1
477	Lupeg	\N
478	DUSTERLOH	\N
479	Electro Adda S.p.A.	\N
480	B&B Tools Lietuva	\N
481	Woerner	\N
482	VOITH TURBO	1
483	ROEMHELD GMBH	\N
484	pneumax	\N
485	Berarma	\N
486	Vivoil Oleodinamica	\N
488	ELESA-GANTER	\N
489	InterLit	\N
490	DEBEM	\N
492	Smerkona, UAB	\N
493	Techvitas, UAB	\N
494	AUTOGARD	\N
495	MAAG Pump Systems 	\N
496	WAMGROUP/OLI	\N
497	Hirschmann Automation and Control GmbH	\N
498	Meili	\N
499	Transtecno	\N
500	Maximator	\N
501	KSB	\N
502	Rexnord	\N
503	Interroll	\N
504	BR-ME	\N
506	EMB	\N
507	Bosch Rexroth Interlit GmbH (Koln)	\N
508	Rohrenkontor Heinen & Bontgen GmbH & Co. KG	\N
509	Magtrol	\N
510	Josting Maschinenfabrik GmbH &Co. KG	\N
511	Neumeister	\N
512	FIBRO GmbH	\N
513	IKRON	\N
514	Novotechnik	\N
515	NZWL	\N
516	Ingersoll Rand	\N
517	J D Neuhaus	\N
518	Technogaja, UAB	\N
520	HYDRANAUTICS	\N
521	MARZOCCHI	\N
522	Amalva	\N
523	Aola	\N
524	ОДО "Текона-М"	\N
525	ROSAUTO Srl	1
527	Shanghai Jun Ying Instruments	\N
528	Siti	1
529	Schubert&Salzer	\N
530	C.M.R. GROUP S.p.A	\N
531	Huebner Giessen	\N
533	MAKOR	1
534	Goennheimer Electronic Gmbh	\N
535	COBO	1
537	Bosch Rexroth AS	\N
538	Westcode	\N
539	Johannes HUEBNER giessen	\N
540	Duesterloh	\N
541	Yudo Nordic	\N
542	GMS Hydraulic	\N
543	Eaton Technology GmbH	\N
544	Tyco Electronics	\N
545	Biesse	\N
546	MS Maschinenbau u. Vertriebs GmbH	\N
547	YE International	\N
548	Axis industries	\N
549	Completec, Ltd	\N
550	Sun Control	\N
551	Homag GUS	\N
552	Gates	\N
553	Genoma	\N
554	Meta	\N
555	BC Deutschland	\N
556	Karl E. Brinkmann GmbH	\N
557	ASBO Drives Technology Components GmbH	\N
558	Wurth Lietuva, UAB	\N
559	Franz Schneider GmbH&Co	\N
560	IRMautomatika UAB	\N
561	Reich Kupplungen	\N
562	Remigijaus Navakausko ДЇmonД—	\N
563	FAST FILL	\N
564	Comer Industries	\N
565	Dantherm Filtration	\N
566	Tunkers	\N
567	Misia	\N
568	Misia Paranchi s.r.l.	\N
569	MEDWAY CLOSURES LIMITED	\N
570	PALL	\N
571	Manotherm	1
572	Putsch Meniconi	1
573	HANSA-TMP S.r.l.	\N
574	Frygosystem	\N
576	Kracht	1
577	Ditton	\N
578	SMS Service Montage und Syst.GmbH	\N
579	Plasticband	1
580	GTEN BALL SCREW TECHNOLOGY CO. LTD.	\N
581	Invertek Drives	\N
582	GTK-W.Grundler im Balticum UAB	\N
583	VoorWood Company	\N
584	Gann	\N
585	Cushion pack	\N
587	Norgren	\N
588	GAMBINI MECCANICA S.R.L.	\N
589	Lovejoy	\N
590	Hydraulik Nord	\N
591	Oleo	\N
592	Nikken	\N
593	Sandarinimu pasaulis	\N
594	Schaublin	\N
595	Technolegno, Makor Group	1
596	STABline	\N
597	Morgan Molten Metal Systems GmbH	\N
598	RONZIO	\N
599	GEA Klimatechnik	\N
600	Jahns Regulatoren Gesellschaft	\N
601	TELLARINI POMPE snc	\N
602	Reggiana	\N
603	Hydrastore	\N
604	Maina	\N
605	Draeger	\N
607	Oberts, SIA	\N
609	Baltic Biogran	\N
610	Kleinbongartz & Kaiser oHG	\N
611	Faluteknik AB	\N
612	C.O.B.O. SpA	1
613	Sarmax	1
614	Bolenz & Schafer	\N
616	Elster Kromschroder	\N
617	ACC Distribution, UAB	\N
618	Donati	\N
619	Proton	\N
620	Etermos technikos salonas, UAB	\N
621	Moris Technology, UAB	\N
622	SYSTRAPLAN	1
623	Brickle	\N
625	IBC	\N
627	ОАО "Белкард"	\N
628	Stegherr	\N
629	Ultralight	\N
630	USAG	1
631	KOHLBACH-Gruppe	\N
632	Bikon	\N
633	VAJ	\N
634	MB Maschinenbau	\N
635	Brilex	\N
636	Yaspro	\N
638	HOMAG Automation	1
639	Tecnolegno	\N
640	Caldaro	\N
641	Deutsch	\N
642	ALMA	\N
643	Bacci	\N
644	Lazer Safe Pty. Ltd	\N
645	Valkomas	\N
646	Kadis	\N
647	LignaTool	\N
648	MHF	\N
649	Wammes Machinery GmbH	\N
650	Hydro Italia Srl	1
651	GIVI MISURE	\N
652	Felp	\N
653	CAMAM	\N
654	LoeSi	\N
655	REHNEN	\N
656	LAP-Laser	\N
657	Trimwex	\N
658	Coral	\N
659	KSK	\N
660	MEKRAtronics	\N
661	Elastomeri	\N
662	UNI CHAINS	1
663	APM Automation Solutions Ltd.	1
664	PDS	\N
665	Gruppo Grassi	\N
666	Rotex	\N
667	FLEXOWELL	\N
668	JihoStroj	\N
669	KГјndig	\N
670	Etatron	\N
671	Saacke	\N
672	Teknek	\N
673	Auertech	\N
674	HighTec	\N
675	OMGA	\N
676	Burnside	\N
677	TRAK-MET	\N
678	Wellman	\N
679	EATON GERMANY GMBH 	\N
680	RAMAC	\N
681	WMG Maschinenbau GmbH	\N
682	Tsubaki	\N
683	Berlitech	\N
684	Pepperl+Fuchs	\N
685	Rickmeier	\N
687	ABM	1
688	HYDRO	1
689	Elesa-ganter	\N
691	Trutzschler	1
692	Bauer	\N
693	Спецмашсоюз	\N
694	SuS Schteiftechnik und Maschinunhandel GmBH	\N
695	JKF Poland	\N
697	Emotron	\N
698	Humboldt	\N
699	S.T.M. S.p.a.	\N
700	Klaschka Industrieelektronik GmbH	\N
701	Robert Bosch	\N
702	NEWLAST	\N
703	Walter Prazision	\N
704	ARMAT spol. s r.o.	\N
706	LIFTER	\N
707	O.M.I.	\N
708	Robert Bosch GmbH 	\N
709	Hexium hydraulika	\N
710	EMG Automation GmbH IndustriestraГџe 	\N
711	RINGFEDER POWER TRANSMISSION GMBH	\N
712	THK	\N
714	MDM Mega Drive Magdeburg GmbH	\N
715	Brusa & Garboli	1
716	Blue Vent	1
717	Bosch Rexroth Electric Drives and Controls	\N
718	Wiebrock	\N
719	Brevetti Motta	\N
720	CSS Electronics	\N
721	Robert Bosch Automotive Steering GmbH	\N
722	MESKOTEX GmbH & Co. KG	\N
723	KEB	\N
724	Verarbeitungstechnik	\N
725	Kolbach	\N
726	GREDA	\N
727	HOMAG Bohrsysteme	1
728	HOMAG Kantentechnik	1
729	HOMAG Plattenaufteiltechnik	1
730	Festo	\N
731	AZ pneumatica	\N
732	Marzahl Vetrieb GmbH	\N
733	Barbaric	1
734	Bevi	\N
735	Dinstock	\N
736	BERMA s.r.l.	\N
737	Oleodinamica Gambini	1
738	Karl Heinz Verarbeitungstechnik	1
739	LANDEFELD	\N
740	Sumetzberger	\N
741	Kropa	\N
742	Iew Induktive ErwГ¤rmungsanlagen GmbH	1
743	AIRTAC	\N
744	SIBRE Siegerland Bremsen GmbH	\N
745	rilesa	\N
746	REEL-Antriebstechnik GmbH	\N
747	LUGA abrasive plant	\N
748	WALVOIL	\N
749	ACE	\N
750	Haumea S.r.l.	\N
751	Vecoplan	\N
752	Busak+Shamban	\N
753	Samoa	\N
754	PЕЃOSZAJ ZBIGNIEW	\N
755	MP Filtri	\N
756	Vigano Mario	1
757	Gerling	\N
758	Lerum pac maskin AB	\N
759	WГ„CHTER SERVICE	\N
760	Steiner	\N
761	Oilgear	\N
762	ATB TAMEL Spolka Akcyjna	\N
763	ILC	\N
764	Airtec	\N
765	IFM	\N
766	Phoenix Contact	\N
767	Armano	\N
768	Autol	\N
769	Webtec	\N
770	Data M Engineering Gmbh	\N
771	LAKFAM	\N
772	LUIS Technology GmbH	\N
773	APEX DYNAMICS CZECH s.r.o.	\N
774	HONSBERG	\N
775	Oleoweb	\N
776	EKOFILTRAS	\N
777	Centauro	1
778	REM-B HYDRAULICS	\N
779	ООО "ДЭМС-Энерго"	\N
780	Guibe (Goizper Group)	\N
781	Flender	\N
782	Gebr. Steimel GmbH & Co	\N
783	Walter Systemtechnik GmbH	\N
784	Perkute	\N
786	Wabko	\N
787	TE	\N
788	Bosch Engineering GmbH	\N
789	Toptul	\N
790	Imos	\N
791	Carlisle	\N
792	Weber	\N
793	Sumal	\N
794	Forsage	\N
795	BAHCO	\N
796	FUBAG	\N
797	REFFITEL,Italija	\N
798	OMG, Italia	\N
799	Italgroup	\N
800	Robland	1
801	Sunfab	\N
802	HIWIN	\N
803	Novacom	\N
804	STW	\N
805	GENERAL FITTINGS	\N
806	ECO	\N
807	TIVOLY	\N
808	STARMIX	\N
809	Kostyrka GmbH	\N
810	Emmegi	\N
811	Embalitec	\N
812	ANDRE ABRASIVE ARTICLES	\N
813	KAWASAKI	\N
814	HTL group	\N
815	AK Regeltechnik	\N
816	BeA	\N
817	Schaaff & Meurer GmbH	\N
818	Bojin	\N
819	ОАО "Кобринагромаш"	\N
820	GYSIN AG	\N
821	Линтера Техсервис	\N
822	ZVL	\N
823	Ognibene	\N
824	TECHMIK Krzysztof MikuЕ‚a	1
825	ОАО "САЛЕО-Гомель"	\N
826	NBI Bearings Europe, S.A	\N
827	SPITZNAS	\N
828	KROHNE	\N
829	Hansen Industrial Transmissions NV	\N
830	Christ AG	\N
831	YATO	\N
832	Hengst	\N
833	Mehner	\N
834	Kromschroder	\N
835	FIAM	\N
836	BBC-R	\N
837	DOETSCH	\N
838	Brown Europe LTD	\N
839	Hengli (Jiangsu Hengli Hydraulic Co., Ltd.)	1
840	Alkitronic	\N
841	WhiteDriveProducts	\N
842	Cematic-Electric B.V.	\N
843	Perma	\N
844	Металлургспецмаш	\N
845	CNBY	\N
846	Mapei	\N
847	SPRING	\N
848	Platzmann federn gmbh & co. kg	\N
849	DISTRELEC	\N
850	B&R	\N
851	Oleomec	1
852	MH Hydraulics	\N
853	SOV Hydraulic Technology (Shanghai) Co., Ltd	\N
854	QIBR	\N
855	Xiangjun (Shanghai Xiangjun Pneumatic Engineering Co., Ltd.)	\N
856	GRH (Shanghai Guorui Hydraulic Technology)	\N
857	Yongling (Zhejiang Yongling Hydraulic Machine Co., Ltd.)	\N
858	Fushan	1
859	SKS Hydraulics (SKS (Saikesi) Hydraulic Technology Co. Ltd.)	\N
860	Daixin	1
861	Ikin	\N
862	NER GROUP	\N
863	Viking (Jiangsu Viking Hydraulic & Purification Technology Co., Ltd.)	\N
864	FengHe	\N
865	YLcaster (Guangzhou YLcaster Metal Co., Ltd.)	\N
866	GUANGYUAN (Wuhu Guangyuan Hydraulic Technology Co.,Ltd.)	\N
867	Green (Changzhou Green Hydraulic Equipment Manufacturing Co., Ltd.)	\N
868	TRANSCYKO	\N
869	KINGEAR	\N
870	Beinei	1
871	XZWD XUZHOU WANDA 	\N
872	Hanjiu (Shijiazhuang Hanjiu Technology Co.,Ltd)	\N
873	HCHC (Hefei Changyuan Hydraulic Co., Ltd.)	\N
874	PAL-FIN	\N
875	Veichi	\N
876	Taifeng	\N
877	Hytek (HYTEK POWER CO ., LTD)	\N
878	Chike Hydraulic Pump (Shanghai) Co., Ltd.	\N
879	АБРАЗИВ	\N
880	Iglan (Dongguan IGLAN Machinery Co., Ltd.)	\N
881	ADVANCE	\N
882	Green	\N
884	FUJIAN VIKING INDUSTRY	\N
885	Densen Group	\N
886	Kunlong	\N
887	Maiyuesen (Shandong Maiyuesen trading company, Weifang Haimao radiator Co. Ltd.))	\N
888	KBK Antriebstechnik GmbH	\N
889	Innovator	\N
890	AOKMAN	\N
891	ИНСТРУМ-РЭНД	\N
892	HXLC	\N
893	LeeMin (China LeeMin Hydraulic Company Ltd.)	\N
894	iWave	\N
895	SmartControl	\N
896	Makersan	\N
897	Gemco (Ningbo Gemco Fluid Co., Ltd.)	\N
898	Taishan Castor Co.,Ltd	\N
899	Keta Hydraulics (Ningbo Ketai Hydraulic Co., Ltd)	\N
900	JCB	\N
901	Yuhang Aerospace Equipment Co., Ltd	\N
902	 UFI FILTERS HYDRAULICS S.p.A.	\N
903	Meric (Wenzhou Meric Hydraulic Technology Co., Ltd.)	\N
904	Suzhou Rico Machinery	\N
905	Hefei Shinny Hydraulic Technology CO., LTD.	\N
906	HIKA	\N
907	WTsensor (Nanjing Wotian Technology Co. Ltd.)	\N
908	Samach	1
909	CisoLube	\N
910	Jinhua Steel Casting & Engineering Parts Co., Ltd.	\N
911	BAFFERO	\N
913	BALA	1
914	Wuxi Fagor Technology Co,. Ltd	\N
915	Zhejiang Hongfei Machinery Manufacturing Co., Ltd.	\N
916	ZG VALVE INDUSTRY (ZHANGGUO INDUSTRY CO.,LTD)	\N
917	PMC	\N
918	Gau Jing	\N
919	Oemak Machine	\N
920	Hefei Synergy Hydraulic Technology Co. LTD.	\N
921	Henan Shunying New Energy Co., Ltd.	\N
922	HOREX	\N
923	PARTNER	\N
924	H-D	\N
925	Spryvine Hydraulics Inc	\N
926	XCPC (Ningbo Xinchao Automatization Component Co., Ltd.)	\N
927	Yateks (Shenzhen Yateks Co., Ltd.) 	\N
929	Kudosworld	\N
930	HELM TOWER	\N
931	HENAN XINNUODA MACHINARY EQUIPMENT CO.,LTD	\N
932	MYTORQ	\N
933	SHPI	\N
934	UT-TOOLS	\N
935	Linde	1
936	Propellent (Shandong Propellent Energy Technology Co., Ltd.)	\N
937	FORCE	\N
938	Elettrotec	\N
939	 LANDPACK	1
940	WMC TOOLS	\N
941	Lexmua (Guangdong Lexmua Hydraulic Technology Co., Ltd.)	\N
942	REKITH	\N
943	FE-MA-TECH	\N
944	ZHENJIANG	\N
945	HARSCO	\N
946	Jingtai	1
947	DONGHUA CHAIN GROUP	\N
948	3F FAMED	\N
949	Vibo (Jiangsu Vibo Hydraulics Joint Stock Co., Ltd.)	\N
950	Normeco	\N
951	Wany (Hefei Wanye Hydraulic Component Co., Ltd.)	\N
952	Amphenol	\N
953	Yoye (Ningbo Yoye Hydraulics Co., Ltd.)	\N
954	Rongxing Drive	\N
955	BRITERENCODER	\N
956	Chaori (Ningbo Chaori Hydraulic Co .,Ltd.)	\N
957	HYDLC	\N
958	Kunshan	1
959	Embedded Box Computer	\N
960	Beijing CP Device Technology	\N
961	DJFM	\N
962	UTEK	\N
963	Reijay (Shanghai Reijay Hydraulic & Transmission Tech Co.,Ltd.)	\N
964	Caterpillar	\N
965	SITEMA	\N
966	Fer-ro	\N
967	Siboma (SKS)	\N
968	KING TONY	\N
969	WEITAI	\N
970	GATX	\N
971	AOLAIER	\N
972	Emax (Ningbo Emax Motion Control Technology Co., Ltd.)	\N
973	KINTOWE	\N
974	THOTH	\N
975	STF (Ningbo STF Hydraulic Transmissions Co., Ltd.)	\N
976	HFD	\N
977	FOX	\N
978	HuaYu	\N
979	Ридан	\N
980	Zhaosheng Hydraulic	1
981	NINVA	1
982	DTMACH	1
983	Ningbo Target Hydraulics Co., Ltd.	\N
984	HanShang Hydraulic  Co.,Ltd.	\N
985	SAIRUI	\N
986	LEEV	1
987	SJ Technology	\N
988	инструм-Рэнд	\N
989	YUNYU	\N
990	XIANDAI 	\N
991	THT	\N
992	THT	1
993	JW Hydraulic Limited	\N
994	Dekema (Dekema Hydraulic Manufacturing Co., Ltd.)	\N
995	Jiangxi Aike Industrial Co., Ltd	\N
996	Haimooo	\N
997	Sudiao	1
998	FORCEKRAFT	\N
999	Hessan	1
1000	DUROFIX	\N
1001	NIDEC MOTORS & ACTUATORS (GERMANY) GmbH	\N
1002	WABCO	\N
1003	SACHS	\N
1004	Shako (SHAKO Co., Ltd.)	\N
1005	SANDAR	1
1006	TAIAN LIOU	\N
1007	INI	\N
1008	Hydvic	\N
1009	BENCH	\N
1010	RUICHI	\N
1011	Zhanpeng Hydraulic 	\N
1012	Prance Hydraulic equipment Co.Ltd	1
1013	Плашки резьбонакатные	\N
1014	WAFIOS Umformtechnik GmbH	\N
1015	MTS	\N
1016	Akshay	\N
1017	Flair	\N
1018	Balluff GmbH	\N
1019	Moflon	\N
1020	Ningbo Zhenhai	\N
1021	Guanghong Hydraulic	\N
1022	XINJUN	1
1023	MOTECK ELECTRIC CORP.	\N
1024	Richfulcat	\N
1025	WAYFONG	\N
1026	SHPI	\N
1027	KING RIGHT MOTOR CO., LTD.	\N
1028	Feiyu Machinery	1
1029	LYUAN HYDRAULIC	\N
1030	Leiliy Hydraulics	\N
1031	HiP	\N
1032	Shenzhen Yaojienterprise co.,ltd	\N
1033	Wuxi Hongba Mechanical & Electrical Equipment Co., Ltd.	\N
1034	TRANSPOWER	\N
1035	LANDAI	\N
1036	MWS Schneidwerkzeuge GmbH & Co. KG	\N
1037	ZF Friedrichshafen AG	\N
1038	Агродорсервис	\N
1039	ASN	\N
1040	LITE HYDRAULIC	\N
1041	TONK	\N
1042	Elobau	\N
1043	HOLD	1
1044	Youwin-tech Technology Co., Ltd.	\N
1045	QIULIN MACHINERY	1
1046	SKIPER	\N
1047	Chengdu Zhijin Machinery Equipment Co., Ltd.	\N
1048	GELAN	\N
1049	ICW	1
1050	Hezo Technology	\N
1051	Protecfire (Beijing) Fire Systems Technology Co. Ltd.	\N
1053	Liecang	\N
1054	Jiecang	\N
1055	DLSEALS	\N
1056	Ultrafiltration (Huanjie New Energy Technology (Jiangsu) Co., Ltd.)	\N
1057	UNICORN VALVES PRIVATE LIMITED	\N
1058	BOHOS	\N
1059	Torcstark	\N
1060	Shanghai Liansheng Pump-making Co.,Ltd	\N
1061	Daitto (Shanghai Daitto Fluid Technology Co., Ltd.)	\N
1062	Bole (Quanzhou Bole Automation Engineering Co., Ltd.)	\N
1063	Qichen	\N
1064	Hakes	\N
1065	Сибома-Транзит	\N
1066	FRIULMAC	\N
1067	LIPU	\N
1068	PRTA (Ningbo PRTA Hydraulic Technology Co., Ltd.)	\N
1069	Daikin	\N
1070	Yikaide	\N
1071	SAFIM	\N
1072	Grundfos	\N
1073	DEUTZ	\N
1074	AEROSPACE POWER	\N
1075	NAVIX	\N
1076	HUADE	\N
1077	Dana SPICER	\N
1078	Mollificio Bordignon	\N
1079	YIDIAN	\N
1080	Wandfluh	\N
\.


--
-- Data for Name: dcl_term_inco; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_term_inco (trm_id, trm_name, trm_name_extended, trm_order_id) FROM stdin;
1	EXW	EXW (Инкотермс 2000)	7
2	FCA	FCA (Инкотермс 2000)	8
3	CIP	CIP (Инкотермс 2000)	9
4	CPT	CPT (Инкотермс 2000)	10
5	DDU	DDU (Инкотермс 2000)	11
6	DDP	DDP (Инкотермс 2000)	12
7	EXW_2010	EXW (Инкотермс 2010)	0
8	FCA_2010	FCA (Инкотермс 2010)	1
9	CIP_2010	CIP (Инкотермс 2010)	2
10	CPT_2010	CPT (Инкотермс 2010)	3
11	DAT_2010	DAT (Инкотермс 2010)	4
12	DAP_2010	DAP (Инкотермс 2010)	5
13	DDP_2010	DDP (Инкотермс 2010)	6
\.


--
-- Data for Name: dcl_test; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_test (tst_id, tst_name, tst_decimal) FROM stdin;
\.


--
-- Data for Name: dcl_timeboard; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_timeboard (tmb_id, usr_id, tmb_date, tmb_checked, tmb_create_date, usr_id_create, tmb_edit_date, usr_id_edit, tmb_checked_date, usr_id_checked) FROM stdin;
\.


--
-- Data for Name: dcl_tmb_list_work; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_tmb_list_work (tbw_id, tmb_id, tbw_date, tbw_from, tbw_to, tbw_hours_update, crq_id, tbw_comment) FROM stdin;
\.


--
-- Data for Name: dcl_unit; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_unit (unt_id, is_acceptable_for_cpr) FROM stdin;
1	1
2	1
3	0
4	0
8	1
12	0
18	1
22	1
30	0
34	0
42	0
48	1
49	0
50	1
\.


--
-- Data for Name: dcl_unit_language; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_unit_language (unt_id, lng_id, unt_name) FROM stdin;
1	1	шт
1	2	pcs.
1	3	Stk
2	1	кг
2	2	kg
2	3	kg
3	1	партия
3	2	\N
3	3	\N
4	1	канистра
4	2	\N
4	3	\N
8	1	м
8	2	m
8	3	m
12	1	пачка
12	2	\N
12	3	\N
18	1	н.час
22	1	Р»
22	2	l
22	3	l
30	1	уп
30	2	\N
30	3	\N
34	1	катушка
34	2	\N
34	3	\N
42	1	комплект
42	2	\N
42	3	\N
48	1	мм
48	2	mm
48	3	mm
49	1	зуб (у пил)
49	2	\N
49	3	\N
50	1	1000 шт.
50	2	1000 pcs.
50	3	1000 Stk
\.


--
-- Data for Name: dcl_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_user (usr_id, usr_code, usr_login, usr_passwd, dep_id, usr_phone, usr_block, usr_respons_person, usr_no_login, usr_chief_dep, usr_fax, usr_email, usr_local_entry, usr_internet_entry) FROM stdin;
1	000	admin	vip2u1ig	\N	\N	\N	\N	\N	\N	\N	\N	1	1
2	MIK	mik	salomumia	9	(+375 29) 6430034	1	\N	1	\N	\N	\N	1	\N
3	VAR	var	qiloz	2	(+375 29) 3416465	1	\N	1	\N	(+375 17) 3286041	\N	\N	\N
4	VIP	vip	2u1ig	3	(+375 17) 3870240	\N	1	\N	\N	(+375 17) 3870250	minsk@lintera.info	1	1
5	OLB	olb	3elez	5	(+375 29) 6181227	1	\N	1	\N	(+375 17) 3286041	oleg.brilevsky@lintera.info	1	\N
6	SEK	sek	vi5i9	4	(+375 29) 1267335	1	\N	1	\N	\N	sergey.kiyashko@lintera.info	1	\N
7	SES	ses	12345	15	(+375 29) 7093535	1	\N	1	1	(+375 17) 3870250	sergey.shiryaev@lintera.info	\N	\N
8	GRK	grk	yxixu	4	(+375 29) 7542856	1	\N	1	\N	(+375 17) 3286041	grigoriy.korzun@lintera.info	1	\N
9	OLG	olg	sikos	5	(+375 29) 6206641	\N	1	\N	\N	(+375 17) 3870251	oleg.gursky@lintera.info	1	1
10	ANT	ant	4obaw	5	\N	\N	1	\N	\N	\N	andrei.tumel@lintera.info	1	1
11	VIS	vis	uhbv	5	(+375 29) 6206663	1	1	1	1	(+375 17) 3870251	viktor.sobol@lintera.info	\N	\N
12	JUL	jul	fudyv	6	(+375 29) 6206662	1	\N	1	\N	(+375 17) 3286041	yuri.lavrov@lintera.info	1	\N
13	VIC	vic	joqpk	6	(+375 29) 6066620	1	\N	1	\N	(+375 17) 3286041	viktor.zegelnik@lintera.info	1	\N
14	VLR	vlr	rifyh	9	(+375 29) 6206667	1	\N	1	\N	(+375 17) 3286041	\N	1	\N
15	SEZ	sez	qilir	9	(+375 29) 6206661	1	\N	1	\N	(+375 17) 3286041	sergey.zhuk@lintera.info	1	\N
16	SED	sed	o1umy	9	(+375 29) 7515535	1	\N	1	\N	\N	\N	1	\N
18	IRS	irs	6uwah	2	(+375 29) 6141064	1	\N	1	\N	(+375 17) 3286041	\N	\N	\N
19	VLA	vla	2upil	8	(+375 17) 3870261, Mob. (+375 29) 6206665	\N	1	\N	1	(+375 17) 3870259	vladimir.azarov@lintera.info	1	\N
20	VAV	vav	zipq4a7+	12	(+375 29) 6955911	1	\N	1	\N	(+375 17) 3286041	vasili.vasileuski@lintera.info	1	\N
21	EGZ	egz	haqet	5	(+375 29) 7751993	\N	1	\N	\N	(+375 17) 3870251	egor.zabolotsky@lintera.info	1	1
22	EKK	ekk	8i9eg	4	(+375 29) 7708670	1	\N	1	\N	\N	\N	1	\N
23	ROF	rof	xe9ic	6	(+375 29) 6075926	1	\N	1	\N	(+375 17) 3286041	roman.frizen@lintera.info	1	\N
24	SEM	sem	ujos0	6	(+375 29) 6180477	1	\N	1	1	(+375 17) 3286041	sergey.malofeev@lintera.info	1	\N
25	SEL	sel	m2zsk	5	(+375 29) 7024188	1	\N	1	\N	(+375 17) 3286041	\N	1	\N
28	YUK	yuk	frwbb72	10	(+375 2334) 27854, Mob: (+375 29) 6206680	1	\N	1	1	(+375 2334) 26567	yuri.kozlov@lintera.info	\N	\N
29	SEG	seg	sNaD	10	\N	1	\N	\N	\N	\N	\N	1	1
31	IRF	irf	gi1o7	12	(+375 17) 3286043	1	\N	1	\N	(+375 17) 3286041	irina.fedosik@lintera.info	1	\N
33	EVL	evl	cualy	6	(+375 17) 3286043	1	\N	1	\N	(+375 17) 3286041	evgenij.luzanov@lintera.info	1	\N
34	VAL	val	dLvS8	13	(+370 349) 61161	\N	1	\N	\N	(+370 349) 61297	sales@lintera.info	1	1
36	VIT	vit	vaP274	\N	\N	\N	1	\N	\N	\N	\N	1	1
38	ALP	alp	Ecat2002	1	(+375 17) 3870255, (+375 29) 6285943	\N	\N	\N	\N	\N	alexandr.petnitsky@lintera.info	1	1
40	VIK	vik	fdmzy8	12	\N	1	\N	1	\N	\N	\N	1	\N
42	VIL	vil	8f8zf	2	(+375 29) 5667024	1	\N	1	\N	(+375 17) 3286041	vitali.loban@lintera.info	\N	\N
44	MIZ	miz	sa9ame0y	10	\N	1	\N	1	\N	\N	\N	\N	\N
46	MAR	mar	3y2ux	3	\N	1	\N	\N	\N	\N	\N	1	1
48	OLY	oly	ju2y732t	7	\N	\N	\N	\N	\N	\N	olga.yukho@lintera.info	1	1
50	SEA	sea	9skn7	6	(+375 29) 6327919	1	\N	\N	\N	(+375 17) 3286041	sergei.alenichev@lintera.info	1	\N
52	ALB	alb	\N	12	\N	1	\N	1	\N	\N	\N	1	\N
54	ELS	els	u2#pm	3	(+375 29) 6339020	\N	\N	\N	\N	(+375 17) 3870250	alena.skosireva@lintera.info	1	1
56	VIG	vig	@6cex	2	(+375 29) 6793316	1	\N	1	\N	(+375 17) 3286041	victoria.gavrilova@lintera.info	\N	\N
58	SRG	srg	+x6%4	9	(+375 29) 6064512	1	\N	1	\N	(+375 17) 3286041	sergei.gubarevich@lintera.info	1	\N
60	SEU	seu	hq+r9	5	(+375 29) 3495258	1	\N	1	\N	(+375 17) 3870251	sergey.kubarev@lintera.info	\N	\N
64	ROB	rob	\N	13	\N	1	\N	1	\N	\N	\N	1	1
66	ALK	alk	e45e6ouk	12	(+375 17) 3870240, Mob. (+375 29) 6206922	\N	1	\N	1	(+375 17) 3870259	alk@lintera.info	1	1
72	LAS	las	69pa=	12	(+375 29) 1840049	1	\N	1	\N	(+375 17) 3286041	lauras.stucinskas@lintera.info	1	\N
74	NAA	naa	-z70+	3	\N	1	\N	1	\N	\N	natalia.ahramenka@lintera.info	\N	\N
76	EKL	ekl	v19ta	2	\N	1	\N	1	\N	\N	\N	\N	\N
78	VAK	vak	-6c5y	9	(+375 29) 6206661	1	\N	1	\N	(+375 17) 3286041	valentin.kalasha@lintera.info	1	\N
82	ALR	alr	5vgzr+1z	8	(+375 17) 3870261	1	\N	1	\N	(+375 17) 3870259	aleksandr.karanin@lintera.info	\N	\N
84	ROV	rov	%edoka7o	12	(+375 44) 7248409	1	\N	1	\N	(+375 17) 3286041	\N	1	\N
86	VAY	vay	3idebex	9	(+375 29) 3425319, 7630206	1	\N	1	\N	(+375 17) 3286041	vadim.yansupov@lintera.info	1	1
88	SEO	seo	uxy3izo	12	(+375 17) 3286043, Mob. (+375 29) 1565704, 5774636	1	\N	1	\N	(+375 17) 3286041	sergey.kotliarchuk@lintera.info	1	\N
90	YUV	yuv	5a7usi1	12	(+375 17) 3286043, Mob. (+375 29) 5687515	1	\N	1	\N	(+375 17) 3286041	yulia.kharchenko@lintera.info	1	\N
92	SEI	sei	cu4eba6	6	(+375 17) 3870240, Mob. (+375 29) 7788739	1	\N	1	\N	(+375 17) 3870250	sergei.sinitski@lintera.info	1	\N
94	VII	vii	4xzdp6	12	\N	\N	1	\N	\N	(+375 17) 3870259	\N	1	1
96	EVS	evs	2e3unux	12	(+375 17) 3286043, Mob. (+375 29) 6719926	1	\N	1	\N	(+375 17) 3286041	\N	1	\N
98	LIS	lis	3y8ofu4	2	(+375 17) 3870240	\N	\N	\N	\N	(+375 17) 3870250	\N	1	\N
100	IGK	igk	7iru8a9	9	(+375 17) 3286043, Mob. (+375 29) 3437187	1	\N	1	\N	(+375 17) 3286041	igor.krasovsky@lintera.info	1	\N
104	VAM	vam	6y8o+y6	9	(+375 17) 3870240, Mob. (+375 29) 6616591	1	\N	1	1	(+375 17) 3870250	vasily.malashonok@lintera.info	1	\N
106	IRE	ire	a8avu7y	2	(+375 17) 3286043	\N	1	\N	\N	(+375 17) 3870250	irina.jelissejenko@lintera.info	1	\N
108	VAZ	vaz	6afove9	6	(+375 17) 3286043, Mob. (+375 29) 6266904	1	\N	1	\N	(+375 17) 3286041	vadzim.zealiony@lintera.info	1	\N
110	ANA	ana	5o8u1a=	9	(+375 17) 3870240, Mob. (+375 44) 7903895	\N	1	\N	1	(+375 17) 3870250	andrey.karpovich@lintera.info	1	1
112	IGH	igh	sd7ser1	12	(+375 17) 3286043, Mob. (+375 29) 4024181; 6206922	1	\N	1	\N	(+375 17) 3286041	ihar.khodan@lintera.info	1	\N
114	ALM	alm	9n1236	12	\N	\N	1	\N	\N	(+375 17) 3870259	\N	1	\N
116	NAK	nak	iz4u9	11	\N	\N	\N	\N	\N	\N	nataliy.kaptur@lintera.info	1	1
118	PAB	pab	eb8h6d	6	(+375 17) 3286043, Mob. (+375 29) 6197849	1	\N	1	\N	(+375 17) 3286041	pavel.bury@lintera.info	1	\N
119	OLB	olb	bueh5q	9	(+375 17) 3870240, Mob. (+375 29) 6181227	1	\N	1	1	(+375 17) 3870250	oleg.brilevsky@lintera.info	1	\N
122	\N	\N	ua5m1g	9	(+375 17) 3870240, Mob. (+375 29) 3944593	1	\N	1	\N	(+375 17) 3870250	anton.siniauski@lintera.info	\N	\N
123	ANV	anv	b4sp2p	5	(+375 17) 3870240, Mob. (+375 29) 7377933	\N	1	\N	\N	(+375 17) 3870251	andrey.vdovuhin@lintera.info	1	1
125	DMS	dms	upoo08	12	\N	1	\N	1	\N	\N	\N	\N	\N
126	ROV	rov	w5et9c	6	(+375 44) 7248409	1	\N	1	\N	(+375 17) 3286041	roman.vasilevich@lintera.info	1	\N
127	LAO	lao	clat1w	3	\N	1	\N	1	\N	\N	\N	1	\N
128	TAK	tak	8bYkH	2	(+375 29) 3525925	\N	1	\N	\N	\N	tatjana.kazakova@lintera.info	1	\N
129	AAL	aal	m6gsf7	3	\N	1	\N	1	\N	\N	\N	\N	\N
130	PAF	paf	ok8xcm	9	(+375 17) 3870252, Mob. (+375 29) 6618202	1	\N	1	\N	(+375 17) 3870252	pavel.filippovich@lintera.info	\N	\N
131	PAS	pas	z8e2xa	9	(+375 17) 3286043, Mob. (+375 29) 2773655	1	\N	1	\N	(+375 17) 3286041	pavel.serbun@lintera.info	1	\N
132	TAM	tam	z55glx	13	\N	\N	\N	\N	\N	\N	\N	1	1
133	KEB	keb	rga3x6	13	\N	1	\N	1	\N	\N	\N	\N	\N
134	INT	int	7zdudv	13	\N	\N	\N	\N	\N	\N	\N	1	1
135	RAG	rag	v6kn4w	13	\N	1	\N	\N	\N	\N	\N	1	1
136	DAR	dar	vh13pm	13	\N	\N	\N	\N	\N	\N	\N	1	1
138	DMZ	dmz	d8xx90	9	(+375 17) 3870249, Mob. (+375 29) 6582348	1	\N	1	\N	(+375 17) 3870249	dima.zhigalko@lintera.info	\N	\N
139	NAS	nas	123987	2	\N	1	\N	1	\N	\N	\N	\N	\N
140	IGV	igv	2ehe3egu	6	(+375 17) 3870240, Mob. (+375 29) 7517850	1	\N	1	\N	(+375 17) 3870250	igor.venslavovich@lintera.info	1	\N
141	VIH	vih	pubo9yna	6	(+375 17) 3870240, Mob. (+375 29) 6569111	1	\N	1	\N	(+375 17) 3870250	vitali.chaikouski@lintera.info	1	1
142	SEV	sev	niso5ami	5	(+375 17) 3870240, Mob. (+375 25) 9496349	\N	1	\N	\N	(+375 17) 3870251	sergey.ivanov@lintera.info	1	1
143	SEC	sec	panu4amo	6	(+375 17) 3870240, Mob. (+375 29) 5744742	\N	1	\N	1	(+375 17) 3870250	sergey.chikunov@lintera.info	1	1
144	GIM	gim	usabymi3	13	\N	1	\N	\N	\N	\N	giedre.mikelioniene@lintera.info	1	1
147	PAN	pan	7aloxy4e	9	(+375 17) 3286043, Mob. (+375 29) 1292909	1	\N	1	\N	(+375 17) 3286041	\N	1	\N
148	DMP	dmp	4y7esaferX308im2	6	(+375 29) 3625484	\N	\N	\N	\N	(+375 17) 3870250	dmitry.prokopov@lintera.info	1	1
149	MAM	mam	6uvadati	3	(+375 17) 3870240, Mob. (+375 29) 6662361	1	\N	1	\N	(+375 17) 3870250	maria.mironovich@lintera.info	\N	\N
150	DMK	dmk	oxu7o5a3	9	(+375 17) 3870252, Mob. (+375 29) 7928923	1	\N	1	\N	(+375 17) 3870252	dmitry.zakordonetz@lintera.info	1	\N
151	ALL	all	opy4ukiw	12	(+375 17) 3870240, Mob.(+375 29) 7784325	1	\N	1	\N	(+375 17) 3870259	alexandr.baleiko@lintera.info	\N	\N
152	TAN	tan	fb5gckkp	2	(+375 17) 3870240, Mob. (+375 29) 8651567	1	\N	1	\N	(+375 17) 3870250	\N	\N	\N
153	NAV	nav	edjktyf	12	(+375 17) 3870260, Mob. (+375 29) 7753909	1	1	\N	\N	(+375 17) 3870259	natallia.khvashchynskaya@lintera.info	\N	\N
154	VAC	vac	0egaky6o	12	(+375 17) 3870240, Mob. (+375 29) 8522199	\N	1	\N	\N	(+375 17) 3870259	\N	1	\N
155	ALT	alt	y6ezevih	12	(+375 17) 3870240, Mob. (+375 29) 5053502	1	\N	1	\N	(+375 17) 3870259	\N	1	\N
156	PAG	pag	udihyju4	6	(+375 17) 3870240, Mob. (+375 29) 6748373, 5247749	1	1	1	\N	(+375 17) 3870254	pavel.hrynevich@lintera.info	\N	\N
157	MAL	\N	\N	\N	\N	1	\N	1	\N	\N	\N	\N	\N
158	SEK	sek	cu4a9aho	12	(+375 17) 3870260, Mob. (+375 29) 1267335	\N	1	\N	\N	(+375 17) 3870259	\N	1	\N
159	OLP	olp	syho3ogo	12	(+375 17) 3870260	1	\N	1	\N	(+375 17) 3870259	oleg.petrazhytsky@lintera.info	1	\N
160	VIO	vio	tody9aga	3	(+375 17) 3870240	1	\N	1	\N	(+375 17) 3870250	\N	\N	\N
161	PAK	pak	w6hjwan9	5	(+375 17) 3870240, Mob. (+375 44) 5849766	1	\N	1	\N	(+375 17) 3870251	pavel.kovalewsky@lintera.info	1	\N
162	DMD	dmd	89ynvv9e	12	(+375 17) 3870240, Mob. (+375 29) 1389190	\N	1	\N	1	(+375 17) 3870259	dmitriy.baidalov@by.lintera.info	1	1
164	ANE	ane	uxy6umi3	8	(+375 17) 3870261, Mob. (+375 29) 5095768	\N	1	\N	\N	(+375 17) 3870259	andrey.apanasevich@lintera.info	1	\N
168	EDC	\N	\N	13	\N	1	\N	1	\N	\N	\N	1	\N
169	ALV	alv	4e8itebo	9	(+375 17) 3870257, Mob. (+375 29) 6324043	1	\N	1	\N	(+375 17) 3870257	\N	\N	\N
170	PAT	pat	sf2ty4hg	3	\N	1	\N	1	\N	\N	pavel.tsihanovich@lintera.info	\N	\N
171	INM	inm	7uzispyf	13	\N	\N	\N	\N	\N	\N	\N	1	1
172	JUB	jub	leruybl8	11	(+375 44) 7230256	1	\N	1	\N	\N	\N	\N	\N
173	RIC	ric_1	ric1	5	(+370 349) 61161	\N	1	\N	1	(+370 349) 61297	\N	1	1
175	IRG	irg	Ss19rJX7	3	(+375 44) 7148474	1	\N	1	\N	\N	irina.hanetskaya@lintera.info	\N	\N
176	ELK	elk	946g7d5d	3	(+375 17) 3870240, Mob. (+375 44) 7635508	\N	\N	\N	\N	(+375 17) 3870250	elena.krutikova@lintera.info	1	\N
178	NIL	nil	ldkjyht6	8	(+375 17) 3870261	1	\N	1	\N	(+375 17) 3870259	nikita.lukyanchik@lintera.info	\N	\N
179	EDK	\N	\N	13	\N	\N	\N	1	\N	\N	\N	\N	\N
180	ALZ	alz	edjkty	12	(+375 17) 3870240, Mob. (+375 29) 7639133	1	\N	1	\N	(+375 17) 3870259, Skype:alexey.zhdanovich_lintera	alexey.zhdanovich@lintera.info	\N	\N
181	\N	\N	\N	13	\N	1	\N	1	\N	\N	\N	\N	\N
182	VAS	vas	wfp8596g	13	\N	1	\N	\N	\N	\N	\N	\N	\N
185	VVV	vvv	39567daz	4	\N	1	\N	\N	1	\N	\N	1	1
186	DMC	dmc	c4ks76gw	8	(+375 17) 3870261, MTS (+375 33) 3552526	1	\N	1	\N	(+375 17) 3870259	dmitriy.chernyavskiy@by.lintera.info	\N	\N
187	LEL	lel	esr674e5	8	(+375 17) 3870261	1	\N	1	\N	(+375 17) 3870259	leonid.lis@lintera.info	1	\N
188	IGD	igd	93456oie	6	(+375 17) 3870240, Mob. (29) 6363143, (33) 3478881	1	\N	1	\N	(+375 17) 3870250	igor.dron@lintera.info	1	\N
189	RIZ	\N	\N	13	\N	\N	1	1	\N	\N	\N	\N	\N
190	VLS	vls	sekg8476	2	(+375 17) 3870240, Mob. (+375 29) 6624100	1	\N	1	\N	(+375 17) 3870250	\N	\N	\N
191	EKI	eki	swop67d5	9	(+375 17) 3870240, Mob. (+375 29) 7937419	1	\N	1	1	(+375 17) 3870250	katerina.litvinchuk@lintera.info	1	\N
193	EVF	evf	31323330Kol	5	(+375 17) 3870240, Mob. (+375 25) 5097336	\N	1	\N	\N	(+375 17) 3870251	evgeny.filonchyk@lintera.info	1	1
195	GIA	gia	3t68df2m	13	\N	\N	\N	\N	\N	\N	\N	1	1
196	RUG	rug	ksire6fy	5	(+375 17) 3870240, Mob. (+375 29) 6467811	1	\N	1	\N	(+375 17) 3870251	ruslan.grebnev@lintera.info	\N	\N
197	EC2	ec2	fb5gckkp	2	\N	1	\N	1	\N	\N	\N	\N	\N
198	EC3	ec3	a8avu7y123456	2	\N	1	\N	1	\N	\N	\N	\N	\N
199	EC4	ec4	9yme3ale123456	2	\N	1	\N	1	\N	\N	\N	\N	\N
200	LAK	lak	eryt4357	7	\N	1	\N	1	\N	\N	\N	\N	\N
201	NAG	nag	edjktyf	7	\N	1	\N	\N	\N	\N	natali.glushkova@lintera.info	\N	\N
202	EC5	ec5	a893675t	2	\N	\N	\N	\N	\N	\N	\N	1	\N
206	ALD	ald	tsui546g	5	(+375 17) 3870240, Mob. (+375 29) 1081698	\N	1	\N	\N	(+375 17) 3870251	aleksey.lasitski@lintera.info	1	1
207	TAP	tap	kreui673	7	\N	1	\N	1	\N	\N	tamara.puseva@lintera.info	\N	\N
210	NIB	nib	LinA1601	9	(+375 17) 3870257	1	\N	1	\N	(+375 17) 3870257	nikita.bukin@lintera.info	\N	\N
211	ANH	anh	6p5M872C	9	(+375 17) 3870257, (+375 29) 7142211	\N	\N	\N	\N	(+375 17) 3870257	anton.mahov@lintera.info	1	1
212	dmk	dmk	1AT1RiPG	12	+375297638273	1	\N	1	\N	\N	dmitriy.kichaev@lintera.info	\N	\N
213	VLM	vlm	XufkmGS1	12	\N	\N	\N	\N	\N	\N	vladislav.maksimenko@lintera.info	1	1
214	RIC	ric_2	ric2	5	(+370 349) 61161	\N	1	\N	1	(+370 349) 61297	\N	1	1
215	ALO	alo	6p5M872C	8	(+375 17) 3870261, (+375 29) 8775993	1	\N	1	\N	(+375 17) 3870259	alexander.ermakovich2@lintera.info	\N	\N
216	olp	olp	FpsfwR51	13	\N	\N	\N	\N	\N	\N	olga.dimaityte@lintera.info	1	1
217	olp	olp	FpsfwR51	13	\N	1	\N	\N	\N	\N	\N	1	1
218	olp	olp	FpsfwR51	13	\N	\N	\N	\N	\N	\N	olga.dimaityte@lintera.info	1	1
219	OAK	oak	8wsDKIZx	7	\N	\N	\N	\N	\N	\N	olga.akunetz@lintera.info	1	1
220	IGB	igb	33oZnk	12	(+375 29) 7013864	1	\N	1	\N	\N	ignat.budnikov@by.lintera.info	\N	\N
221	ANB	anb	Ixouou6B	12	Mob. (+375 29) 5540191	\N	\N	\N	\N	\N	anton.bykau@lintera.info	1	1
222	EKK	ekk	8FqN	7	\N	\N	\N	\N	\N	\N	\N	1	\N
223	ALI	ali	Hp5cu	7	\N	\N	\N	\N	\N	\N	\N	1	\N
224	AAM	aam	KvT1s	5	(+375 17) 3870240, (+375 44) 4699341	\N	\N	\N	\N	(+375 17) 3870251	andrei.mozheiko@lintera.info	1	1
\.


--
-- Data for Name: dcl_user_language; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_user_language (usr_id, lng_id, usr_surname, usr_name, usr_position) FROM stdin;
1	1	admin	admin	\N
1	2	\N	\N	\N
1	3	\N	\N	\N
2	1	Козел	Михаил	инженер
2	2	\N	\N	\N
2	3	\N	\N	\N
3	1	Р Р°Р»Р»Рµ	Валерия	Специалист по логистике
3	2	\N	\N	\N
3	3	\N	\N	\N
4	1	Пранович	Виталий	Директор
4	2	Pranovich	Vitaly	Director of "Lintera Techservice"
4	3	Pranovich	Vitaly	Director
5	1	Брилевский	Олег *	инженер
5	2	Brilevsky	Oleg	Manager
5	3	Brilevsky	Oleg	Manager
6	1	Кияшко	Сергей *	инженер
6	2	Kiyashko	Sergey	Manager
6	3	Kiyashko	Sergey	Manager
7	1	Ширяев	Сергей	Начальник отдела
7	2	Shiryaev	Sergey	Department Head
7	3	Shiryaev	Sergey	Leiter der Abteilung
8	1	Корзун	Григорий	инженер
8	2	Korzun	Grigoriy	Manager
8	3	Korzun	Grigoriy	Manager
9	1	Гурский	Олег	Начальник сектора индустриально
9	2	Gursky	Oleg	Manager
9	3	Gursky	Oleg	Manager
10	1	Тумель	Андрей	инженер
10	2	Tumel	Andrei	Manager
10	3	Tumel	Andrei	Manager
11	1	Соболь	Виктор	Зам. директора по техническим во�
11	2	Sobol	Victor	Deputy Director for engineering
11	3	Sobol	Viktor	Stellvertretender Direktor fuer technische Fragen
12	1	Лавров	Юрий	инженер
12	2	Lavrov	Yuri	Manager
12	3	Lavrov	Yuri	Manager
13	1	Цегельник	Виктор	инженер
13	2	Tsegelnik	Viktor	Manager
13	3	Zegelnik	Viktor	Manager
14	1	Роговой	Владислав	инженер
14	2	\N	\N	\N
14	3	\N	\N	\N
15	1	Жук	Сергей	Начальник отдела инструмента
15	2	Zhuk	Sergey	Department Head
15	3	Zhuk	Sergey	Leiter der Abteilung
16	1	Дудко	Сергей	инженер
16	2	\N	\N	\N
16	3	\N	\N	\N
18	1	Селезнёва	ирина	Начальник отдела логистики
18	2	\N	\N	\N
18	3	\N	\N	\N
19	1	Азаров	Владимир	Главный инженер
19	2	Azarov	Vladimir	Chief engineer
19	3	Azarov	Vladimir	Hauptingenieur
20	1	Василевски	Василий	инженер
20	2	Vasileuski	Vasili	Electrical engineer
20	3	Vasileuski	Vasili	Manager
21	1	Заболоцкий	Егор	Начальник сектора мобильного пр�
21	2	Zabolotsky	Egor	Head of Mobile application sector
21	3	Zabolotsky	Egor	Leiter der Mobilanwendungsabteilung
22	1	Куртин	Екатерина	инженер
22	2	\N	\N	\N
22	3	\N	\N	\N
23	1	Фризен	Роман	инженер
23	2	Frizen	Roman	Manager
23	3	Frizen	Roman	Manager
24	1	Малофеев	Сергей	Начальник отдела деревообработк
24	2	Malofeev	Sergey	Department Head
24	3	Malofeev	Sergey	Leiter der Abteilung
25	1	Лаптев	Сергей	инженер-конструктор
25	2	\N	\N	\N
25	3	\N	\N	\N
28	1	Козлов	Юрий	Менеджер
28	2	Kozlov	Yuri	Manager Area
28	3	Kozlov	Yuri	Manager
29	1	Гурский	Жлобин	Менеджер
29	2	\N	\N	\N
29	3	\N	\N	\N
31	1	Федосик	ирина	инженер-гидравлик
31	2	Fedosik	Irina	Fluid power engineer
31	3	Fedosik	Irina	Ingenieur
33	1	Лузанов	Евгений	инженер
33	2	Luzanov	Evgeniy	Manager
33	3	Lusanov	Evgeniy	Manager
34	1	Луковсков	Валерий	Директор
34	2	Lukovskov	Valerij	Director
34	3	Lukovskov	Valerij	GeschГ¤ftsfГјhrer
36	1	Чинчене	Вита	Товаровед
36	2	Cinciene	Vita	Commodity Expert
36	3	Cinciene	Vita	Warenempfangkontrolleur
38	1	Петницкий	Александр	Администратор сетей (Администра�
38	2	Petnitsky	Alexandr	IT Service
38	3	\N	\N	\N
40	1	Кармаз	Виктор	инженер-электроник
40	2	\N	\N	\N
40	3	\N	\N	\N
42	1	Лобан	Виталий	Декларант (таможенный агент)
42	2	\N	\N	\N
42	3	\N	\N	\N
44	1	Жолнерович	Михаил	инженер
44	2	\N	\N	\N
44	3	\N	\N	\N
46	1	Рабко	Марина	Юрист
46	2	\N	\N	\N
46	3	\N	\N	\N
48	1	Юхо	Ольга	Бухгалтер
48	2	\N	\N	\N
48	3	\N	\N	\N
50	1	Аленичев	Сергей	инженер
50	2	Alenichev	Sergei	Manager
50	3	Alenitschev	Sergej	Manager
52	1	Базыма	Алексей	инженер-механик
52	2	\N	\N	\N
52	3	\N	\N	\N
54	1	Скосырева	Елена	Юрист
54	2	\N	\N	\N
54	3	\N	\N	\N
56	1	Гаврилова	Виктория	Специалист по логистике
56	2	Gavrilova	Victoria	\N
56	3	Gavrilova	Victoria	\N
58	1	Губаревич	Сергей	инженер
58	2	Gubarevich	Sergei	Manager
58	3	Gubarewitch	Sergej	Manager
60	1	Кубарев	Сергей	Начальник сектора автоматизации
60	2	Kubarev	Sergey	Automation department head
60	3	Kubarev	Sergey	Leiter der Automatisationsabteilung
64	1	Будревичус	Роландас	инженер-менеджер
64	2	\N	\N	\N
64	3	\N	\N	\N
66	1	Косаревски	Александр	Начальник отдела по техническом�
66	2	Kosarevskyy	Oleksandr	Head of woodworking equipment service department
66	3	Kosarevskyy	Oleksandr	Leiter des Wartungsdienstes fГјr Holzbearbeitungsmaschinen
72	1	Стучинскас	Лаурас	Начальник отдела по техническом�
72	2	Stucinskas	Lauras	Head of woodworking equipment service department
72	3	Stucinskas	Lauras	Leiter des Wartungsdienstes fГјr Holzbearbeitungsmaschinen
74	1	Ахраменка	Наталья	Юрист
74	2	\N	\N	\N
74	3	\N	\N	\N
76	1	Леонович	Екатерина	Логист-переводчик
76	2	\N	\N	\N
76	3	\N	\N	\N
78	1	Калаша	Валентин	Начальник отдела инструмента
78	2	Kalasha	Valentin	Department Head
78	3	Kalasha	Valentin	Leiter der Abteilung
82	1	Каранин	Александр	инженер-гидравлик
82	2	Karanin	Aleksandr	Fluid power engineer
82	3	Karanin	Aleksandr	Ingenieur
84	1	Василевич	Роман *	инженер-механик
84	2	Vasilevich	Roman	Mechanical engineer
84	3	Vasilevich	Roman	Maschineningenieur
86	1	Янсупов	Вадим	инженер
86	2	Yansupov	Vadim	Manager
86	3	Yansupov	Vadim	Manager
88	1	Котлярчук	Сергей	инженер-механик
88	2	Kotliarchuk	Sergey	Mechanical engineer
88	3	Kotliartschuk	sergej	Maschineningenieur
90	1	Василевич	Юлия	Специалист по продаже
90	2	Vasilevich	Yulia	Manager
90	3	Vasilevich	Yulia	Manager
92	1	Синицкий	Сергей	Специалист по продаже
92	2	Sinitski	Sergei	Manager
92	3	Sinitski	Sergej	Manager
94	1	Никитенко	Виталий	Механик-Наладчик
94	2	no data	no data	no data
94	3	no data	no data	no data
96	1	Савицкий	Евгений	инженер-механик
96	2	Savitsky	Eugene	Mechanical engineer
96	3	Savitsky	Eugene	Maschineningenieur
98	1	Шабловская	Лилия	Специалист по таможенному оформ�
98	2	\N	\N	\N
98	3	\N	\N	\N
100	1	Красовский	игорь	инженер
100	2	Krasovskiy	Igor	Manager
100	3	Krasowski	Igor	Manager
104	1	Малашонок	Василий	Начальник отдела инструмента
104	2	Malashonok	Vasiliy	Head of tools department
104	3	Malashonok	Vasiliy	Leiter der Werkzeugabteilung
106	1	Елисеенко	ирина	Логистик
106	2	Yeliseyenka	Iryna	Logistics
106	3	Jelissejenko	Irina	Logistik
108	1	Зелёный	Вадим	инженер
108	2	Zealiony	Vadzim	Engineer
108	3	Zealiony	Vadzim	Ingenieur
110	1	Карпович	Андрей	Зам. директора по коммерческим в�
110	2	Karpovich	Andrei	Commercial Deputy Director
110	3	Karpovich	Andrei	Stellvertretender Direktor fГјr Kommerzfragen
112	1	Ходан	игорь	Начальник отдела по техническом�
112	2	Khodan	Ihar	Head of woodworking equipment service department
112	3	Khodan	Ihar	Leiter des Wartungsdienstes fГјr Holzbearbeitungsmaschinen
114	1	Мишулков	Алексей	инженер-электроник
114	2	no data	no data	no data
114	3	no data	no data	no data
116	1	Каптур	Наталья	Экономист
116	2	\N	\N	\N
116	3	\N	\N	\N
118	1	Бурый	Павел	Специалист по продаже
118	2	Bury	Pavel	Manager
118	3	Bury	Pavel	Manager
119	1	Брилевский	Олег	Начальник отдела инструмента
119	2	Brilevsky	Oleg	Department Head
119	3	Brilevsky	Oleg	Leiter der Abteilung
122	1	Синявский	Антон	Специалист по продаже
122	2	Siniauski	Anton	Manager
122	3	Siniauski	Anton	Manager
123	1	Вдовухин	Андрей	инженер
123	2	Vdovuhin	Andrey	Engineer
123	3	Wdowuchin	Andrej	Ingenieur
125	1	Асипёнок	Дмитрий	инженер-электронщик
125	2	\N	\N	\N
125	3	\N	\N	\N
126	1	Василевич	Роман	Специалист по продаже
126	2	Vasilevich	Roman	Manager
126	3	Vasilevich	Roman	Manager
127	1	Осипенко	Лариса	\N
127	2	\N	\N	\N
127	3	\N	\N	\N
128	1	Казакова	Татьяна	Переводчик
128	2	Kazakova	Tatjana	Logistics
128	3	Kazakova	Tatjana	Logistik
129	1	Островская	Алеся	\N
129	2	\N	\N	\N
129	3	\N	\N	\N
130	1	Филиппович	Павел	Специалист по продаже
130	2	Filippovich	Pavel	Manager
130	3	Filippovich	Pavel	Manager
131	1	Сербун	Павел	Специалист по продаже
131	2	Serbun	Pavel	Manager
131	3	Serbun	Pavel	Manager
132	1	Мостенецен	Татьяна	Главный менеджер
132	2	\N	\N	\N
132	3	\N	\N	\N
133	1	Билотас	Кестутис	\N
133	2	\N	\N	\N
133	3	\N	\N	\N
134	1	Толстошеев	инга	\N
134	2	\N	\N	\N
134	3	\N	\N	\N
135	1	Гадейкиене	Рамуне	\N
135	2	\N	\N	\N
135	3	\N	\N	\N
136	1	Ромашкене	Дайва	\N
136	2	\N	\N	\N
136	3	\N	\N	\N
138	1	Жигалко	Дмитрий	Специалист по продаже
138	2	Zhigalko	Dima	Manager
138	3	Zhigalko	Dima	Manager
139	1	Страбыкина	Наталья	Логистик
139	2	Strabykina	Natallia	\N
139	3	Strabykina	Natallia	\N
140	1	Венславови	игорь	Начальник отдела деревообработк
140	2	Venslavovich	Igor	Department Head
140	3	Venslavovich	Igor	Leiter der Abteilung
141	1	Чайковский	Виталий	Специалист по продаже
141	2	Chaikouski	Vitali	Manager
141	3	Tschaikovskij	Vitalij	Manager
142	1	иванов	Сергей	инженер
142	2	Ivanov	Sergey	Engineer
142	3	Ivanov	Sergey	Ingenieur
143	1	Чикунов	Сергей	Начальник отдела
143	2	Chikunov	Sergey	Department Head
143	3	Chikunov	Sergey	Leiter der Abteilung
144	1	Микелионен	Гедре	Ассистент отдела логистики
144	2	\N	\N	\N
144	3	\N	\N	\N
147	1	Никитин	Павел	Специалист по продаже
147	2	Nikitin	Pavel	Manager
147	3	Nikitin	Pavel	Manager
148	1	Прокопов	Дмитрий	Специалист по продаже
148	2	Prokopov	Dmitry	Manager
148	3	Prokopov	Dmitry	Manager
149	1	Миронович	Мария	Маркетолог
149	2	Mironovich	Maria	Marketingmanager
149	3	Mironovich	Maria	Marketingmanager
150	1	Закордонец	Дмитрий	Специалист по продаже
150	2	Zakordonetz	Dmitry	Manager
150	3	Zakordonetz	Dmitry	Manager
151	1	Балейко	Александр	Специалист по продаже
151	2	Baleiko	Alexandr	Manager
151	3	Baleiko	Alexandr	Manager
152	1	Наумчик	Татьяна	Специалист по таможенному оформ�
152	2	Naumchyk	Tatsiana	\N
152	3	\N	\N	\N
153	1	Хващинская	Наталья	Специалист по продаже
153	2	Kvatschynskaya	Natallia	Manager
195	2	Artiuch	Gitana	\N
153	3	Khvashchynskaya	Natallia	Manager
154	1	Яцкевич	Вадим	инженер-электроник
154	2	Yatskevich	Vadim	Electronic Engineer
154	3	Yatskevich	Vadim	Ingenieur-Elektroniker
155	1	Пташник	Алексей	инженер-электроник
155	2	Ptashnik	Aleksey	Electronic Engineer
155	3	Ptashnik	Aleksey	Ingenieur-Elektroniker
156	1	Гриневич	Павел	Специалист по продаже
156	2	Hrynevich	Pavel	Manager
156	3	Hrinevitsch	Pavel	Manager
157	1	Лиетинс	Марис	\N
157	2	\N	\N	\N
157	3	\N	\N	\N
158	1	Кияшко	Сергей	инженер-электроник
158	2	Kiyashko	Sergey	no data
158	3	Kiyashko	Sergey	no data
159	1	Петрожицки	Олег	инженер-электроник
159	2	Petrazhytsky	Oleg	\N
159	3	\N	\N	\N
160	1	Носко	Виктория	Секретарь-референт
160	2	\N	\N	\N
160	3	\N	\N	\N
161	1	Ковалевски	Павел	инженер
161	2	Kovalewsky	Pavel	Manager
161	3	Kovalewsky	Pavel	Manager
162	1	Байдалов	Дмитрий	Заместитель начальника отдела с�
162	2	Baidalov	Dmitriy	Manager
162	3	Baidalov	Dmitriy	Manager
164	1	Апанасевич	Андрей	инженер
164	2	Apanasevich	Andrey	Engineer
164	3	Apanasevich	Andrey	Ingenieur
168	1	Чернецкий	Эдвард	\N
168	2	\N	\N	\N
168	3	\N	\N	\N
169	1	Коваль	Александр	Специалист по продаже
169	2	Koval	Aliaksandr	Manager
169	3	Koval	Aliaksandr	Manager
170	1	Тиханович	Павел	Завхоз
170	2	\N	\N	\N
170	3	\N	\N	\N
171	1	Милиауские	индре	Ассистент отдела логистики
171	2	\N	\N	\N
171	3	\N	\N	\N
172	1	Бусел	Юлия	Экономист
172	2	\N	\N	\N
172	3	\N	\N	\N
173	1	Римантас	Чинчис _	Технический директор
173	2	Rimantas	Cincys	Technical director
173	3	Rimantas	Cincys	Technischer Direktor
175	1	Ганецкая	ирина	Переводчик
175	2	Hanetskaya	Irina	Logistics
175	3	Hanetskaya	Iryna	Logistik
176	1	Крутикова	Елена	Секретарь-референт
176	2	Krutikova	Lena	\N
176	3	Krutikova	Lena	\N
178	1	Лукьянчик	Никита	Техник-электрик
178	2	Lukyanchik	Nikita	Electrical technician
178	3	Lukyanchik	Nikita	Electrotechniker
179	1	Кулешас	Эдуардас	\N
179	2	\N	\N	\N
179	3	\N	\N	\N
180	1	Жданович	Алексей	Специалист по продаже
180	2	Zhdanovich	Alexey	Manager
180	3	Zhdanovich	Alexey	Manager
181	1	Р Р°Р·РјР°	Арунас	\N
181	2	\N	\N	\N
181	3	\N	\N	\N
182	1	Сургайлите	Валда	Бухгалтер
182	2	\N	\N	\N
182	3	\N	\N	\N
185	1	Соболь	Виктор (А)	Зам. директора по техническим во�
185	2	\N	\N	\N
185	3	\N	\N	\N
186	1	Чернявский	Дмитрий	Техник-электрик
186	2	Chernyavsky	Dmitry	Electrical technician
186	3	Tscherniavskij	Dmitrij	Electrotechniker
187	1	Лис	Леонид	инженер-энергетик
187	2	\N	\N	\N
187	3	\N	\N	\N
188	1	Дронь	игорь	Специалист по продаже
188	2	Dron	Igor	Manager
188	3	Dron	Igor	Manager
189	1	Журавлиови	Рита	Бухгалтер
189	2	Zuravlioviene	Rita	Accountant
189	3	Zuravlioviene	Rita	Buchhalter
190	1	Сосим	Владимир	Специалист по таможенному оформ�
190	2	Sosim	Uladzimir	\N
190	3	Sosim	Uladzimir	\N
191	1	Литвинчук	Екатерина	Специалист по продаже
191	2	Litvinchuk	Katerina	Manager
191	3	Litwintschuk	Katerina	Manager
193	1	Филончик	Евгений	инженер
193	2	Filonchyk	Evgeny	Engineer
193	3	Filonchyk	Evgeny	Ingenieur
195	1	Artiuch	Gitana	\N
195	3	Artiuch	Gitana	\N
196	1	Гребнев	Руслан	инженер сектора индустриального
196	2	Grebnev	Ruslan	Engineer
196	3	Grebnev	Ruslan	Engineer
197	1	Наумчик	Татьяна	Специалист по таможенному оформ�
197	2	\N	\N	\N
197	3	\N	\N	\N
198	1	Елисеенко	ирина (-)	Логистик
198	2	\N	\N	\N
198	3	\N	\N	\N
199	1	Страбыкина	Наталья (-)	Логистик
199	2	\N	\N	\N
199	3	\N	\N	\N
200	1	Курсевич	Лариса	Главный бухгалтер
200	2	\N	\N	\N
200	3	\N	\N	\N
201	1	Глушкова	Наталья	Главный бухгалтер
201	2	\N	\N	\N
201	3	\N	\N	\N
202	1	Шабловская	Лилия	Специалист по таможенному оформ�
202	2	\N	\N	\N
202	3	\N	\N	\N
206	1	Ласицкий	Алексей	инженер
206	2	Lasitski	Aleksey	Engineer
206	3	Lasitski	Aleksey	Ingenieur
207	1	Пусева	Тамара	Кладовщик
207	2	\N	\N	\N
207	3	\N	\N	\N
210	1	Букин	Никита	Специалист по продаже
210	2	Bukin	Nikita	manager
210	3	Bukin	Nikita	manager
211	1	Махов	Антон	Специалист по продаже
211	2	Mahov	Anton	manager
211	3	Mahov	Anton	manager
212	1	Кичаев	Дмитрий	Владимирович
212	2	Kichaev	Dmitriy	\N
212	3	Kichaev	Dmitriy	\N
213	1	Максименко	Владислав	\N
213	2	\N	\N	\N
213	3	\N	\N	\N
214	1	Римантас	Чинчис	Директор
214	2	Rimantas	Cincys	Director
214	3	Rimantas	Cincys	GeschГ¤ftsfГјhrer
215	1	Ермакович	Александр (	инженер по наладке и испытаниям
215	2	Ermakovich	Alexander	Engineer for adjustment and testing
215	3	Ermakovich	Alexander	Ingenieur fГјr Einricht- und PrГјfarbeiten
216	1	Петровиене	Ольга	Юрист
216	2	\N	\N	\N
216	3	\N	\N	\N
218	1	Петровиене	Ольга	Юрист
218	2	Petroviene	Olga	Lawyer
218	3	\N	\N	\N
219	1	Акунец	Ольга	Бухгалтер
219	2	\N	\N	\N
219	3	\N	\N	\N
220	1	Будников	игнат	инженер-электроник
220	2	\N	\N	\N
220	3	\N	\N	\N
221	1	Быков	Антон	инженер-Электроник
221	2	Bykau	Anton	\N
221	3	Bykau	Anton	\N
222	1	Косаревска	Екатерина	Бухгалтер
222	2	\N	\N	\N
222	3	\N	\N	\N
223	1	иванин	Алексей	Экономист
223	2	\N	\N	\N
223	3	\N	\N	\N
224	1	Можейко	Андрей	инженер
224	2	Mozheiko	Andrei	Engineer
224	3	Mozheiko	Andrei	Ingenieur
\.


--
-- Data for Name: dcl_user_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_user_link (uln_id, usr_id, uln_create_date, uln_url, uln_parameters, uln_text, uln_menu_id) FROM stdin;
\.


--
-- Data for Name: dcl_user_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_user_role (usr_id, rol_id) FROM stdin;
1	1
4	4
9	2
10	2
19	2
19	8
21	2
34	6
36	6
38	1
48	4
54	5
66	2
66	8
94	7
94	8
98	3
106	3
106	9
110	2
110	4
110	5
114	2
114	8
116	3
123	2
128	9
132	6
134	6
136	6
142	2
143	2
148	2
154	8
158	8
162	2
162	8
164	2
171	6
176	4
176	5
176	7
193	1
193	2
195	6
202	4
206	2
211	2
216	6
218	5
218	6
219	4
221	8
222	3
222	4
223	4
224	2
\.


--
-- Data for Name: dcl_user_setting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_user_setting (ust_id, ust_name, ust_description, ust_value, ust_type, ust_action, ust_value_extended, usr_id) FROM stdin;
\.


--
-- Data for Name: dcl_year_num; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dcl_year_num (dcl_year, dcl_num, dcl_table) FROM stdin;
\.


--
-- Name: dcl_1c_number_history_generator; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dcl_1c_number_history_generator', 1, false);


--
-- Name: dcl_cus_code_history_generator; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dcl_cus_code_history_generator', 1, false);


--
-- Name: gen_dcl_account_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_account_id', 1, false);


--
-- Name: gen_dcl_action_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_action_id', 139, true);


--
-- Name: gen_dcl_asm_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_asm_list_produce_id', 1, false);


--
-- Name: gen_dcl_assemble_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_assemble_id', 14, true);


--
-- Name: gen_dcl_attachment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_attachment_id', 1, false);


--
-- Name: gen_dcl_blank_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_blank_id', 3, true);


--
-- Name: gen_dcl_blank_image_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_blank_image_id', 1, false);


--
-- Name: gen_dcl_catalog_number_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_catalog_number_id', 1, false);


--
-- Name: gen_dcl_category_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_category_id', 13, true);


--
-- Name: gen_dcl_cfc_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_cfc_list_produce_id', 1, false);


--
-- Name: gen_dcl_cfc_message_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_cfc_message_id', 1, false);


--
-- Name: gen_dcl_commercial_proposal_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_commercial_proposal_id', 1, false);


--
-- Name: gen_dcl_common_blank_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_common_blank_id', 1, false);


--
-- Name: gen_dcl_common_blank_light_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_common_blank_light_id', 1, false);


--
-- Name: gen_dcl_con_list_spec_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_con_list_spec_id', 1, false);


--
-- Name: gen_dcl_con_message_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_con_message_id', 1, false);


--
-- Name: gen_dcl_cond_for_contract_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_cond_for_contract_id', 10, true);


--
-- Name: gen_dcl_contact_person_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_contact_person_id', 1, false);


--
-- Name: gen_dcl_contract_closed_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_contract_closed_id', 1, false);


--
-- Name: gen_dcl_contract_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_contract_id', 12, true);


--
-- Name: gen_dcl_contractor_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_contractor_id', 20, true);


--
-- Name: gen_dcl_contractor_request_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_contractor_request_id', 5, true);


--
-- Name: gen_dcl_country_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_country_id', 8, true);


--
-- Name: gen_dcl_cpr_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_cpr_list_produce_id', 1, false);


--
-- Name: gen_dcl_cpr_transport_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_cpr_transport_id', 1, false);


--
-- Name: gen_dcl_crq_print_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_crq_print_id', 1, false);


--
-- Name: gen_dcl_crq_stage_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_crq_stage_id', 1, false);


--
-- Name: gen_dcl_ctc_list_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ctc_list_id', 1, false);


--
-- Name: gen_dcl_currency_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_currency_id', 6, true);


--
-- Name: gen_dcl_currency_rate_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_currency_rate_id', 6, true);


--
-- Name: gen_dcl_custome_code_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_custome_code_id', 6, true);


--
-- Name: gen_dcl_delivery_request_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_delivery_request_id', 1, false);


--
-- Name: gen_dcl_department_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_department_id', 5, true);


--
-- Name: gen_dcl_dlr_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_dlr_list_produce_id', 1, false);


--
-- Name: gen_dcl_field_comment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_field_comment_id', 235, true);


--
-- Name: gen_dcl_files_path_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_files_path_id', 17, true);


--
-- Name: gen_dcl_inf_message_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_inf_message_id', 18, true);


--
-- Name: gen_dcl_instruction_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_instruction_id', 5, true);


--
-- Name: gen_dcl_instruction_type_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_instruction_type_id', 9, true);


--
-- Name: gen_dcl_language_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_language_id', 3, true);


--
-- Name: gen_dcl_letterhead_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_letterhead_id', 1, false);


--
-- Name: gen_dcl_log_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_log_id', 78, true);


--
-- Name: gen_dcl_lps_list_manager_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_lps_list_manager_id', 1, false);


--
-- Name: gen_dcl_montage_adjustment_h_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_montage_adjustment_h_id', 1, false);


--
-- Name: gen_dcl_montage_adjustment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_montage_adjustment_id', 1, false);


--
-- Name: gen_dcl_ord_list_pay_sum_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ord_list_pay_sum_id', 1, false);


--
-- Name: gen_dcl_ord_list_payment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ord_list_payment_id', 1, false);


--
-- Name: gen_dcl_ord_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ord_list_produce_id', 1, false);


--
-- Name: gen_dcl_ord_message_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ord_message_id', 1, false);


--
-- Name: gen_dcl_order_blank_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_order_blank_id', 1, false);


--
-- Name: gen_dcl_order_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_order_id', 10, true);


--
-- Name: gen_dcl_outgoing_letter_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_outgoing_letter_id', 5, true);


--
-- Name: gen_dcl_pay_list_summ_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_pay_list_summ_id', 1, false);


--
-- Name: gen_dcl_pay_message_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_pay_message_id', 1, false);


--
-- Name: gen_dcl_payment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_payment_id', 5, true);


--
-- Name: gen_dcl_prc_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_prc_list_produce_id', 1, false);


--
-- Name: gen_dcl_produce_cost_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_produce_cost_id', 5, true);


--
-- Name: gen_dcl_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_produce_id', 15, true);


--
-- Name: gen_dcl_production_term_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_production_term_id', 1, false);


--
-- Name: gen_dcl_purchase_purpose_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_purchase_purpose_id', 8, true);


--
-- Name: gen_dcl_purpose_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_purpose_id', 13, true);


--
-- Name: gen_dcl_rate_nds_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_rate_nds_id', 6, true);


--
-- Name: gen_dcl_ready_for_shipping_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_ready_for_shipping_id', 1, false);


--
-- Name: gen_dcl_reputation_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_reputation_id', 1, true);


--
-- Name: gen_dcl_role_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_role_id', 7, true);


--
-- Name: gen_dcl_route_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_route_id', 9, true);


--
-- Name: gen_dcl_seller_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_seller_id', 5, true);


--
-- Name: gen_dcl_setting_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_setting_id', 9, true);


--
-- Name: gen_dcl_shipping_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_shipping_id', 3, true);


--
-- Name: gen_dcl_shp_doc_type_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_shp_doc_type_id', 40, true);


--
-- Name: gen_dcl_shp_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_shp_list_produce_id', 1, false);


--
-- Name: gen_dcl_spc_list_payment_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_spc_list_payment_id', 1, false);


--
-- Name: gen_dcl_specification_import_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_specification_import_id', 5, true);


--
-- Name: gen_dcl_spi_list_produce_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_spi_list_produce_id', 1, false);


--
-- Name: gen_dcl_stuff_category_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_stuff_category_id', 1080, true);


--
-- Name: gen_dcl_term_inco_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_term_inco_id', 13, true);


--
-- Name: gen_dcl_test_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_test_id', 1, false);


--
-- Name: gen_dcl_timeboard_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_timeboard_id', 5, true);


--
-- Name: gen_dcl_tmb_list_work_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_tmb_list_work_id', 1, false);


--
-- Name: gen_dcl_unit_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_unit_id', 6, true);


--
-- Name: gen_dcl_user_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_user_id', 6, true);


--
-- Name: gen_dcl_user_link_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_user_link_id', 1, false);


--
-- Name: gen_dcl_user_setting_id; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gen_dcl_user_setting_id', 1, false);


--
-- Name: dcl_1c_number_history dcl_1c_number_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_1c_number_history
    ADD CONSTRAINT dcl_1c_number_history_pkey PRIMARY KEY (id);


--
-- Name: dcl_account pk_dcl_account; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_account
    ADD CONSTRAINT pk_dcl_account PRIMARY KEY (acc_id);


--
-- Name: dcl_action pk_dcl_action; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_action
    ADD CONSTRAINT pk_dcl_action PRIMARY KEY (act_id);


--
-- Name: dcl_action_role pk_dcl_action_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_action_role
    ADD CONSTRAINT pk_dcl_action_role PRIMARY KEY (act_id, rol_id);


--
-- Name: dcl_asm_list_produce pk_dcl_asm_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_asm_list_produce
    ADD CONSTRAINT pk_dcl_asm_list_produce PRIMARY KEY (apr_id);


--
-- Name: dcl_assemble pk_dcl_assemble; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_assemble
    ADD CONSTRAINT pk_dcl_assemble PRIMARY KEY (asm_id);


--
-- Name: dcl_attachment pk_dcl_attachment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_attachment
    ADD CONSTRAINT pk_dcl_attachment PRIMARY KEY (att_id);


--
-- Name: dcl_blank pk_dcl_blank; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_blank
    ADD CONSTRAINT pk_dcl_blank PRIMARY KEY (bln_id);


--
-- Name: dcl_blank_image pk_dcl_blank_image; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_blank_image
    ADD CONSTRAINT pk_dcl_blank_image PRIMARY KEY (bim_id);


--
-- Name: dcl_catalog_number pk_dcl_catalog_number; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_catalog_number
    ADD CONSTRAINT pk_dcl_catalog_number PRIMARY KEY (ctn_id);


--
-- Name: dcl_category pk_dcl_category; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_category
    ADD CONSTRAINT pk_dcl_category PRIMARY KEY (cat_id);


--
-- Name: dcl_cfc_list_produce pk_dcl_cfc_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cfc_list_produce
    ADD CONSTRAINT pk_dcl_cfc_list_produce PRIMARY KEY (ccp_id);


--
-- Name: dcl_cfc_message pk_dcl_cfc_message; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cfc_message
    ADD CONSTRAINT pk_dcl_cfc_message PRIMARY KEY (ccm_id);


--
-- Name: dcl_commercial_proposal pk_dcl_commercial_proposal; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_commercial_proposal
    ADD CONSTRAINT pk_dcl_commercial_proposal PRIMARY KEY (cpr_id);


--
-- Name: dcl_con_list_spec pk_dcl_con_list_spec; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_con_list_spec
    ADD CONSTRAINT pk_dcl_con_list_spec PRIMARY KEY (spc_id);


--
-- Name: dcl_con_message pk_dcl_con_message; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_con_message
    ADD CONSTRAINT pk_dcl_con_message PRIMARY KEY (cms_id);


--
-- Name: dcl_cond_for_contract pk_dcl_cond_for_contract; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cond_for_contract
    ADD CONSTRAINT pk_dcl_cond_for_contract PRIMARY KEY (cfc_id);


--
-- Name: dcl_contact_person pk_dcl_contact_person; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contact_person
    ADD CONSTRAINT pk_dcl_contact_person PRIMARY KEY (cps_id);


--
-- Name: dcl_contract pk_dcl_contract; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contract
    ADD CONSTRAINT pk_dcl_contract PRIMARY KEY (con_id);


--
-- Name: dcl_contract_closed pk_dcl_contract_closed; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contract_closed
    ADD CONSTRAINT pk_dcl_contract_closed PRIMARY KEY (ctc_id);


--
-- Name: dcl_contractor pk_dcl_contractor; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contractor
    ADD CONSTRAINT pk_dcl_contractor PRIMARY KEY (ctr_id);


--
-- Name: dcl_contractor_request pk_dcl_contractor_request; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contractor_request
    ADD CONSTRAINT pk_dcl_contractor_request PRIMARY KEY (crq_id);


--
-- Name: dcl_country pk_dcl_country; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_country
    ADD CONSTRAINT pk_dcl_country PRIMARY KEY (cut_id);


--
-- Name: dcl_cpr_list_produce pk_dcl_cpr_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cpr_list_produce
    ADD CONSTRAINT pk_dcl_cpr_list_produce PRIMARY KEY (lpr_id);


--
-- Name: dcl_cpr_transport pk_dcl_cpr_transport; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cpr_transport
    ADD CONSTRAINT pk_dcl_cpr_transport PRIMARY KEY (trn_id);


--
-- Name: dcl_crq_print pk_dcl_crq_print; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_crq_print
    ADD CONSTRAINT pk_dcl_crq_print PRIMARY KEY (crp_id);


--
-- Name: dcl_crq_stage pk_dcl_crq_stage; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_crq_stage
    ADD CONSTRAINT pk_dcl_crq_stage PRIMARY KEY (crs_id);


--
-- Name: dcl_ctc_list pk_dcl_ctc_list; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ctc_list
    ADD CONSTRAINT pk_dcl_ctc_list PRIMARY KEY (lcc_id);


--
-- Name: dcl_ctc_pay pk_dcl_ctc_pay_lcc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ctc_pay
    ADD CONSTRAINT pk_dcl_ctc_pay_lcc PRIMARY KEY (lps_id, lcc_id);


--
-- Name: dcl_currency pk_dcl_currency; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_currency
    ADD CONSTRAINT pk_dcl_currency PRIMARY KEY (cur_id);


--
-- Name: dcl_currency_rate pk_dcl_currency_rate; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_currency_rate
    ADD CONSTRAINT pk_dcl_currency_rate PRIMARY KEY (crt_id);


--
-- Name: dcl_cus_code_history pk_dcl_cus_code_history; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_cus_code_history
    ADD CONSTRAINT pk_dcl_cus_code_history PRIMARY KEY (id);


--
-- Name: dcl_custom_code pk_dcl_custom_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_custom_code
    ADD CONSTRAINT pk_dcl_custom_code PRIMARY KEY (cus_id);


--
-- Name: dcl_custom_code pk_dcl_custom_code_ci; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_custom_code
    ADD CONSTRAINT pk_dcl_custom_code_ci UNIQUE (cus_code, cus_instant);


--
-- Name: dcl_delivery_request pk_dcl_delivery_request; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_delivery_request
    ADD CONSTRAINT pk_dcl_delivery_request PRIMARY KEY (dlr_id);


--
-- Name: dcl_department pk_dcl_department; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_department
    ADD CONSTRAINT pk_dcl_department PRIMARY KEY (dep_id);


--
-- Name: dcl_dlr_list_produce pk_dcl_dlr_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_dlr_list_produce
    ADD CONSTRAINT pk_dcl_dlr_list_produce PRIMARY KEY (drp_id);


--
-- Name: dcl_field_comment pk_dcl_field_comment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_field_comment
    ADD CONSTRAINT pk_dcl_field_comment PRIMARY KEY (fcm_id);


--
-- Name: dcl_files_path pk_dcl_files_path; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_files_path
    ADD CONSTRAINT pk_dcl_files_path PRIMARY KEY (flp_id);


--
-- Name: dcl_inf_message pk_dcl_inf_message; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_inf_message
    ADD CONSTRAINT pk_dcl_inf_message PRIMARY KEY (inm_id);


--
-- Name: dcl_instruction pk_dcl_instruction; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_instruction
    ADD CONSTRAINT pk_dcl_instruction PRIMARY KEY (ins_id);


--
-- Name: dcl_instruction_type pk_dcl_instruction_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_instruction_type
    ADD CONSTRAINT pk_dcl_instruction_type PRIMARY KEY (ist_id);


--
-- Name: dcl_language pk_dcl_language; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_language
    ADD CONSTRAINT pk_dcl_language PRIMARY KEY (lng_id);


--
-- Name: dcl_ctc_shp pk_dcl_lcc_shp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ctc_shp
    ADD CONSTRAINT pk_dcl_lcc_shp PRIMARY KEY (shp_id, lcc_id);


--
-- Name: dcl_log pk_dcl_log; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_log
    ADD CONSTRAINT pk_dcl_log PRIMARY KEY (log_id);


--
-- Name: dcl_lps_list_manager pk_dcl_lps_list_manager; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_lps_list_manager
    ADD CONSTRAINT pk_dcl_lps_list_manager PRIMARY KEY (lmn_id);


--
-- Name: dcl_montage_adjustment pk_dcl_montage_adjustment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_montage_adjustment
    ADD CONSTRAINT pk_dcl_montage_adjustment PRIMARY KEY (mad_id);


--
-- Name: dcl_montage_adjustment_h pk_dcl_montage_adjustment_h; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_montage_adjustment_h
    ADD CONSTRAINT pk_dcl_montage_adjustment_h PRIMARY KEY (madh_id);


--
-- Name: dcl_ord_list_pay_sum pk_dcl_ord_list_pay_sum; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ord_list_pay_sum
    ADD CONSTRAINT pk_dcl_ord_list_pay_sum PRIMARY KEY (ops_id);


--
-- Name: dcl_ord_list_payment pk_dcl_ord_list_payment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ord_list_payment
    ADD CONSTRAINT pk_dcl_ord_list_payment PRIMARY KEY (orp_id);


--
-- Name: dcl_ord_list_produce pk_dcl_ord_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ord_list_produce
    ADD CONSTRAINT pk_dcl_ord_list_produce PRIMARY KEY (opr_id);


--
-- Name: dcl_ord_message pk_dcl_ord_message; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ord_message
    ADD CONSTRAINT pk_dcl_ord_message PRIMARY KEY (orm_id);


--
-- Name: dcl_order pk_dcl_order; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_order
    ADD CONSTRAINT pk_dcl_order PRIMARY KEY (ord_id);


--
-- Name: dcl_outgoing_letter pk_dcl_outgoing_letter; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_outgoing_letter
    ADD CONSTRAINT pk_dcl_outgoing_letter PRIMARY KEY (otl_id);


--
-- Name: dcl_pay_list_summ pk_dcl_pay_list_summ; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_pay_list_summ
    ADD CONSTRAINT pk_dcl_pay_list_summ PRIMARY KEY (lps_id);


--
-- Name: dcl_pay_message pk_dcl_pay_message; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_pay_message
    ADD CONSTRAINT pk_dcl_pay_message PRIMARY KEY (pms_id);


--
-- Name: dcl_payment pk_dcl_payment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_payment
    ADD CONSTRAINT pk_dcl_payment PRIMARY KEY (pay_id);


--
-- Name: dcl_prc_ctr_for_calcstate pk_dcl_prc_ctr_for_calcstate; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_prc_ctr_for_calcstate
    ADD CONSTRAINT pk_dcl_prc_ctr_for_calcstate PRIMARY KEY (lpc_id);


--
-- Name: dcl_prc_list_produce pk_dcl_prc_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_prc_list_produce
    ADD CONSTRAINT pk_dcl_prc_list_produce PRIMARY KEY (lpc_id);


--
-- Name: dcl_produce pk_dcl_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_produce
    ADD CONSTRAINT pk_dcl_produce PRIMARY KEY (prd_id);


--
-- Name: dcl_produce_cost pk_dcl_produce_cost; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_produce_cost
    ADD CONSTRAINT pk_dcl_produce_cost PRIMARY KEY (prc_id);


--
-- Name: dcl_produce_language pk_dcl_produce_language; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_produce_language
    ADD CONSTRAINT pk_dcl_produce_language PRIMARY KEY (prd_id, lng_id);


--
-- Name: dcl_production_term pk_dcl_production_term; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_production_term
    ADD CONSTRAINT pk_dcl_production_term PRIMARY KEY (ptr_id);


--
-- Name: dcl_purchase_purpose pk_dcl_purchase_purpose; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_purchase_purpose
    ADD CONSTRAINT pk_dcl_purchase_purpose PRIMARY KEY (pps_id);


--
-- Name: dcl_purpose pk_dcl_purpose; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_purpose
    ADD CONSTRAINT pk_dcl_purpose PRIMARY KEY (prs_id);


--
-- Name: dcl_rate_nds pk_dcl_rate_nds; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_rate_nds
    ADD CONSTRAINT pk_dcl_rate_nds PRIMARY KEY (rtn_id);


--
-- Name: dcl_ready_for_shipping pk_dcl_ready_for_shipping; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_ready_for_shipping
    ADD CONSTRAINT pk_dcl_ready_for_shipping PRIMARY KEY (rfs_id);


--
-- Name: dcl_reputation pk_dcl_reputation; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_reputation
    ADD CONSTRAINT pk_dcl_reputation PRIMARY KEY (rpt_id);


--
-- Name: dcl_role pk_dcl_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_role
    ADD CONSTRAINT pk_dcl_role PRIMARY KEY (rol_id);


--
-- Name: dcl_route pk_dcl_route; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_route
    ADD CONSTRAINT pk_dcl_route PRIMARY KEY (rut_id);


--
-- Name: dcl_seller pk_dcl_seller; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_seller
    ADD CONSTRAINT pk_dcl_seller PRIMARY KEY (sln_id);


--
-- Name: dcl_setting pk_dcl_setting; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_setting
    ADD CONSTRAINT pk_dcl_setting PRIMARY KEY (stn_id);


--
-- Name: dcl_shipping pk_dcl_shipping; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_shipping
    ADD CONSTRAINT pk_dcl_shipping PRIMARY KEY (shp_id);


--
-- Name: dcl_shp_doc_type pk_dcl_shp_doc_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_shp_doc_type
    ADD CONSTRAINT pk_dcl_shp_doc_type PRIMARY KEY (sdt_id);


--
-- Name: dcl_shp_list_produce pk_dcl_shp_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_shp_list_produce
    ADD CONSTRAINT pk_dcl_shp_list_produce PRIMARY KEY (lps_id);


--
-- Name: dcl_spi_list_produce pk_dcl_sip_list_produce; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_spi_list_produce
    ADD CONSTRAINT pk_dcl_sip_list_produce PRIMARY KEY (sip_id);


--
-- Name: dcl_spc_list_payment pk_dcl_spc_list_payment; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_spc_list_payment
    ADD CONSTRAINT pk_dcl_spc_list_payment PRIMARY KEY (spp_id);


--
-- Name: dcl_specification_import pk_dcl_specification_import; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_specification_import
    ADD CONSTRAINT pk_dcl_specification_import PRIMARY KEY (spi_id);


--
-- Name: dcl_stuff_category pk_dcl_stuff_category; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_stuff_category
    ADD CONSTRAINT pk_dcl_stuff_category PRIMARY KEY (stf_id);


--
-- Name: dcl_term_inco pk_dcl_term_inco; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_term_inco
    ADD CONSTRAINT pk_dcl_term_inco PRIMARY KEY (trm_id);


--
-- Name: dcl_test pk_dcl_test; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_test
    ADD CONSTRAINT pk_dcl_test PRIMARY KEY (tst_id);


--
-- Name: dcl_timeboard pk_dcl_timeboard; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_timeboard
    ADD CONSTRAINT pk_dcl_timeboard PRIMARY KEY (tmb_id);


--
-- Name: dcl_tmb_list_work pk_dcl_tmb_list_work; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_tmb_list_work
    ADD CONSTRAINT pk_dcl_tmb_list_work PRIMARY KEY (tbw_id);


--
-- Name: dcl_unit pk_dcl_unit; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_unit
    ADD CONSTRAINT pk_dcl_unit PRIMARY KEY (unt_id);


--
-- Name: dcl_unit_language pk_dcl_unit_language; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_unit_language
    ADD CONSTRAINT pk_dcl_unit_language PRIMARY KEY (lng_id, unt_id);


--
-- Name: dcl_user pk_dcl_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_user
    ADD CONSTRAINT pk_dcl_user PRIMARY KEY (usr_id);


--
-- Name: dcl_user_language pk_dcl_user_language; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_user_language
    ADD CONSTRAINT pk_dcl_user_language PRIMARY KEY (usr_id, lng_id);


--
-- Name: dcl_user_link pk_dcl_user_link; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_user_link
    ADD CONSTRAINT pk_dcl_user_link PRIMARY KEY (uln_id);


--
-- Name: dcl_user_role pk_dcl_user_role; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_user_role
    ADD CONSTRAINT pk_dcl_user_role PRIMARY KEY (usr_id, rol_id);


--
-- Name: dcl_user_setting pk_dcl_user_setting; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_user_setting
    ADD CONSTRAINT pk_dcl_user_setting PRIMARY KEY (ust_id);


--
-- Name: dcl_year_num pk_dcl_year_num; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_year_num
    ADD CONSTRAINT pk_dcl_year_num PRIMARY KEY (dcl_year, dcl_table);


--
-- Name: dcl_contact_person_user unq1_dcl_contact_person_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contact_person_user
    ADD CONSTRAINT unq1_dcl_contact_person_user UNIQUE (cps_id, usr_id);


--
-- Name: dcl_contractor_user unq1_dcl_contractor_user; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_contractor_user
    ADD CONSTRAINT unq1_dcl_contractor_user UNIQUE (ctr_id, usr_id);


--
-- Name: dcl_catalog_number unq_dcl_ctn_prd_id_stf_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dcl_catalog_number
    ADD CONSTRAINT unq_dcl_ctn_prd_id_stf_id UNIQUE (stf_id, prd_id);


--
-- Name: dcl_account_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_account_idx ON public.dcl_account USING btree (acc_account);


--
-- Name: dcl_action_act_action; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_action_act_action ON public.dcl_action USING btree (act_system_name);


--
-- Name: dcl_blank_idx_name_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_blank_idx_name_type ON public.dcl_blank USING btree (bln_type, bln_name);


--
-- Name: dcl_category_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_category_idx1 ON public.dcl_category USING btree (cat_id, parent_id);


--
-- Name: dcl_cfc_idx_place_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_cfc_idx_place_date ON public.dcl_cond_for_contract USING btree (cfc_place_date);


--
-- Name: dcl_contract_closed_ctc_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_contract_closed_ctc_date ON public.dcl_contract_closed USING btree (ctc_date);


--
-- Name: dcl_contractor_unp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_contractor_unp_idx ON public.dcl_contractor USING btree (ctr_unp);


--
-- Name: dcl_cpr_idx_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_cpr_idx_date ON public.dcl_commercial_proposal USING btree (cpr_date);


--
-- Name: dcl_crt_cur_id_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_crt_cur_id_date_idx ON public.dcl_currency_rate USING btree (cur_id, crt_date);


--
-- Name: dcl_ctn_index_prd_stf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_ctn_index_prd_stf ON public.dcl_catalog_number USING btree (stf_id, prd_id);


--
-- Name: dcl_delivery_request_idx1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_delivery_request_idx1 ON public.dcl_delivery_request USING btree (dlr_date);


--
-- Name: dcl_field_comment_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_field_comment_key ON public.dcl_field_comment USING btree (fcm_key);


--
-- Name: dcl_flp_table_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_flp_table_name_idx ON public.dcl_files_path USING btree (flp_table_name);


--
-- Name: dcl_idx_att_prn_id_prn_tbl; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_idx_att_prn_id_prn_tbl ON public.dcl_attachment USING btree (att_parent_id, att_parent_table);


--
-- Name: dcl_log_idx_log_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_log_idx_log_ip ON public.dcl_log USING btree (log_ip);


--
-- Name: dcl_log_idx_log_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_log_idx_log_time ON public.dcl_log USING btree (log_time);


--
-- Name: dcl_payment_idx_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_payment_idx_date ON public.dcl_payment USING btree (pay_date);


--
-- Name: dcl_produce_cost_prc_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_produce_cost_prc_date ON public.dcl_produce_cost USING btree (prc_date);


--
-- Name: dcl_rate_rtn_date_from; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_rate_rtn_date_from ON public.dcl_rate_nds USING btree (rtn_date_from);


--
-- Name: dcl_setting_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_setting_name ON public.dcl_setting USING btree (stn_name);


--
-- Name: dcl_shipping_idx_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dcl_shipping_idx_date ON public.dcl_shipping USING btree (shp_date);


--
-- Name: dcl_tmb_usr_id_tmb_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_tmb_usr_id_tmb_date ON public.dcl_timeboard USING btree (usr_id, tmb_date);


--
-- Name: dcl_user_setting_un; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dcl_user_setting_un ON public.dcl_user_setting USING btree (usr_id, ust_name);


--
-- Name: idx_cpr_ctr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cpr_ctr ON public.dcl_commercial_proposal USING btree (ctr_id);


--
-- Name: idx_cpr_list_cpr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cpr_list_cpr ON public.dcl_cpr_list_produce USING btree (cpr_id);


--
-- Name: idx_cpr_list_stf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cpr_list_stf ON public.dcl_cpr_list_produce USING btree (stf_id);


--
-- Name: idx_cpr_usr_create; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cpr_usr_create ON public.dcl_commercial_proposal USING btree (usr_id_create);


--
-- Name: idx_dcl_con_list_spec_con_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_con_list_spec_con_id ON public.dcl_con_list_spec USING btree (con_id);


--
-- Name: idx_dcl_con_list_spec_usr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_con_list_spec_usr_id ON public.dcl_con_list_spec USING btree (usr_id);


--
-- Name: idx_dcl_contract_ctr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_contract_ctr_id ON public.dcl_contract USING btree (ctr_id);


--
-- Name: idx_dcl_contract_cur_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_contract_cur_id ON public.dcl_contract USING btree (cur_id);


--
-- Name: idx_dcl_contract_sln_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_contract_sln_id ON public.dcl_contract USING btree (sln_id);


--
-- Name: idx_dcl_pay_list_summ_pay_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_pay_list_summ_pay_id ON public.dcl_pay_list_summ USING btree (pay_id);


--
-- Name: idx_dcl_pay_list_summ_spc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_pay_list_summ_spc_id ON public.dcl_pay_list_summ USING btree (spc_id);


--
-- Name: idx_dcl_shipping_spc_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dcl_shipping_spc_id ON public.dcl_shipping USING btree (spc_id);


--
-- Name: dcl_1c_number_history dcl_1c_number_history_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_1c_number_history_trigger BEFORE INSERT ON public.dcl_1c_number_history FOR EACH ROW EXECUTE FUNCTION public.dcl_1c_number_history_trigger_fn();


--
-- Name: dcl_account dcl_account_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_account_bd0 BEFORE DELETE ON public.dcl_account FOR EACH ROW EXECUTE FUNCTION public.dcl_account_bd0_fn();


--
-- Name: dcl_account dcl_account_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_account_bi0 BEFORE INSERT ON public.dcl_account FOR EACH ROW EXECUTE FUNCTION public.dcl_account_bi0_fn();


--
-- Name: dcl_account dcl_account_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_account_bu0 BEFORE UPDATE ON public.dcl_account FOR EACH ROW EXECUTE FUNCTION public.dcl_account_bu0_fn();


--
-- Name: dcl_action dcl_action_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_action_bi0 BEFORE INSERT ON public.dcl_action FOR EACH ROW EXECUTE FUNCTION public.dcl_action_bi0_fn();


--
-- Name: dcl_asm_list_produce dcl_asm_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_asm_list_produce_bi0 BEFORE INSERT ON public.dcl_asm_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_asm_list_produce_bi0_fn();


--
-- Name: dcl_assemble dcl_assemble_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_assemble_bi0 BEFORE INSERT ON public.dcl_assemble FOR EACH ROW EXECUTE FUNCTION public.dcl_assemble_bi0_fn();


--
-- Name: dcl_assemble dcl_assemble_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_assemble_bu0 BEFORE UPDATE ON public.dcl_assemble FOR EACH ROW EXECUTE FUNCTION public.dcl_assemble_bu0_fn();


--
-- Name: dcl_attachment dcl_attachment_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_attachment_bio BEFORE INSERT ON public.dcl_attachment FOR EACH ROW EXECUTE FUNCTION public.dcl_attachment_bio_fn();


--
-- Name: dcl_blank dcl_blank_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_blank_bi0 BEFORE INSERT ON public.dcl_blank FOR EACH ROW EXECUTE FUNCTION public.dcl_blank_bi0_fn();


--
-- Name: dcl_blank_image dcl_blank_image_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_blank_image_bi0 BEFORE INSERT ON public.dcl_blank_image FOR EACH ROW EXECUTE FUNCTION public.dcl_blank_image_bi0_fn();


--
-- Name: dcl_catalog_number dcl_catalog_number_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_catalog_number_bio BEFORE INSERT ON public.dcl_catalog_number FOR EACH ROW EXECUTE FUNCTION public.dcl_catalog_number_bio_fn();


--
-- Name: dcl_catalog_number dcl_catalog_number_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_catalog_number_bu0 AFTER UPDATE ON public.dcl_catalog_number FOR EACH ROW EXECUTE FUNCTION public.dcl_catalog_number_bu0_fn();


--
-- Name: dcl_category dcl_category_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_category_bio BEFORE INSERT ON public.dcl_category FOR EACH ROW EXECUTE FUNCTION public.dcl_category_bio_fn();


--
-- Name: dcl_cfc_list_produce dcl_cfc_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cfc_list_produce_bi0 BEFORE INSERT ON public.dcl_cfc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_cfc_list_produce_bi0_fn();


--
-- Name: dcl_cfc_message dcl_cfc_message_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cfc_message_bi0 BEFORE INSERT ON public.dcl_cfc_message FOR EACH ROW EXECUTE FUNCTION public.dcl_cfc_message_bi0_fn();


--
-- Name: dcl_commercial_proposal dcl_commercial_proposal_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_commercial_proposal_ai0 AFTER INSERT ON public.dcl_commercial_proposal FOR EACH ROW EXECUTE FUNCTION public.dcl_commercial_proposal_ai0_fn();


--
-- Name: dcl_commercial_proposal dcl_commercial_proposal_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_commercial_proposal_bi0 BEFORE INSERT ON public.dcl_commercial_proposal FOR EACH ROW EXECUTE FUNCTION public.dcl_commercial_proposal_bi0_fn();


--
-- Name: dcl_commercial_proposal dcl_commercial_proposal_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_commercial_proposal_bu0 BEFORE UPDATE ON public.dcl_commercial_proposal FOR EACH ROW EXECUTE FUNCTION public.dcl_commercial_proposal_bu0_fn();


--
-- Name: dcl_con_list_spec dcl_con_list_spec_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_con_list_spec_bd0 BEFORE DELETE ON public.dcl_con_list_spec FOR EACH ROW EXECUTE FUNCTION public.dcl_con_list_spec_bd0_fn();


--
-- Name: dcl_con_list_spec dcl_con_list_spec_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_con_list_spec_bi0 BEFORE INSERT ON public.dcl_con_list_spec FOR EACH ROW EXECUTE FUNCTION public.dcl_con_list_spec_bi0_fn();


--
-- Name: dcl_con_message dcl_con_message_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_con_message_bi0 BEFORE INSERT ON public.dcl_con_message FOR EACH ROW EXECUTE FUNCTION public.dcl_con_message_bi0_fn();


--
-- Name: dcl_cond_for_contract dcl_cond_for_contract_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cond_for_contract_ai0 AFTER INSERT ON public.dcl_cond_for_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_cond_for_contract_ai0_fn();


--
-- Name: dcl_cond_for_contract dcl_cond_for_contract_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cond_for_contract_bd0 BEFORE DELETE ON public.dcl_cond_for_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_cond_for_contract_bd0_fn();


--
-- Name: dcl_cond_for_contract dcl_cond_for_contract_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cond_for_contract_bi0 BEFORE INSERT ON public.dcl_cond_for_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_cond_for_contract_bi0_fn();


--
-- Name: dcl_cond_for_contract dcl_cond_for_contract_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cond_for_contract_bu0 BEFORE UPDATE ON public.dcl_cond_for_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_cond_for_contract_bu0_fn();


--
-- Name: dcl_contact_person dcl_contact_person_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contact_person_bi0 BEFORE INSERT ON public.dcl_contact_person FOR EACH ROW EXECUTE FUNCTION public.dcl_contact_person_bi0_fn();


--
-- Name: dcl_contract dcl_contract_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contract_bd0 BEFORE DELETE ON public.dcl_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_contract_bd0_fn();


--
-- Name: dcl_contract dcl_contract_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contract_bi0 BEFORE INSERT ON public.dcl_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_contract_bi0_fn();


--
-- Name: dcl_contract dcl_contract_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contract_bu0 BEFORE UPDATE ON public.dcl_contract FOR EACH ROW EXECUTE FUNCTION public.dcl_contract_bu0_fn();


--
-- Name: dcl_contract_closed dcl_contract_closed_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contract_closed_bi0 BEFORE INSERT ON public.dcl_contract_closed FOR EACH ROW EXECUTE FUNCTION public.dcl_contract_closed_bi0_fn();


--
-- Name: dcl_contract_closed dcl_contract_closed_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contract_closed_bu0 BEFORE UPDATE ON public.dcl_contract_closed FOR EACH ROW EXECUTE FUNCTION public.dcl_contract_closed_bu0_fn();


--
-- Name: dcl_contractor dcl_contractor_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contractor_bi0 BEFORE INSERT ON public.dcl_contractor FOR EACH ROW EXECUTE FUNCTION public.dcl_contractor_bi0_fn();


--
-- Name: dcl_contractor dcl_contractor_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contractor_bu0 BEFORE UPDATE ON public.dcl_contractor FOR EACH ROW EXECUTE FUNCTION public.dcl_contractor_bu0_fn();


--
-- Name: dcl_contractor_request dcl_contractor_request_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contractor_request_bd0 BEFORE DELETE ON public.dcl_contractor_request FOR EACH ROW EXECUTE FUNCTION public.dcl_contractor_request_bd0_fn();


--
-- Name: dcl_contractor_request dcl_contractor_request_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contractor_request_bi0 BEFORE INSERT ON public.dcl_contractor_request FOR EACH ROW EXECUTE FUNCTION public.dcl_contractor_request_bi0_fn();


--
-- Name: dcl_contractor_request dcl_contractor_request_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_contractor_request_bu0 BEFORE UPDATE ON public.dcl_contractor_request FOR EACH ROW EXECUTE FUNCTION public.dcl_contractor_request_bu0_fn();


--
-- Name: dcl_country dcl_country_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_country_bi0 BEFORE INSERT ON public.dcl_country FOR EACH ROW EXECUTE FUNCTION public.dcl_country_bi0_fn();


--
-- Name: dcl_country dcl_country_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_country_bu0 BEFORE UPDATE ON public.dcl_country FOR EACH ROW EXECUTE FUNCTION public.dcl_country_bu0_fn();


--
-- Name: dcl_cpr_list_produce dcl_cpr_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cpr_list_produce_bi0 BEFORE INSERT ON public.dcl_cpr_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_cpr_list_produce_bi0_fn();


--
-- Name: dcl_cpr_transport dcl_cpr_transport_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cpr_transport_bi0 BEFORE INSERT ON public.dcl_cpr_transport FOR EACH ROW EXECUTE FUNCTION public.dcl_cpr_transport_bi0_fn();


--
-- Name: dcl_crq_print dcl_crq_print_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_crq_print_bi0 BEFORE INSERT ON public.dcl_crq_print FOR EACH ROW EXECUTE FUNCTION public.dcl_crq_print_bi0_fn();


--
-- Name: dcl_crq_stage dcl_crq_stage_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_crq_stage_bi0 BEFORE INSERT ON public.dcl_crq_stage FOR EACH ROW EXECUTE FUNCTION public.dcl_crq_stage_bi0_fn();


--
-- Name: dcl_ctc_list dcl_ctc_list_ad0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ctc_list_ad0 AFTER DELETE ON public.dcl_ctc_list FOR EACH ROW EXECUTE FUNCTION public.dcl_ctc_list_ad0_fn();


--
-- Name: dcl_ctc_list dcl_ctc_list_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ctc_list_bi0 BEFORE INSERT ON public.dcl_ctc_list FOR EACH ROW EXECUTE FUNCTION public.dcl_ctc_list_bi0_fn();


--
-- Name: dcl_currency dcl_currency_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_currency_bio BEFORE INSERT ON public.dcl_currency FOR EACH ROW EXECUTE FUNCTION public.dcl_currency_bio_fn();


--
-- Name: dcl_currency_rate dcl_currency_rate_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_currency_rate_bi0 BEFORE INSERT ON public.dcl_currency_rate FOR EACH ROW EXECUTE FUNCTION public.dcl_currency_rate_bi0_fn();


--
-- Name: dcl_cus_code_history dcl_cus_code_history_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_cus_code_history_trigger BEFORE INSERT ON public.dcl_cus_code_history FOR EACH ROW EXECUTE FUNCTION public.dcl_cus_code_history_trigger_fn();


--
-- Name: dcl_custom_code dcl_custom_code_au0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_custom_code_au0 AFTER UPDATE ON public.dcl_custom_code FOR EACH ROW EXECUTE FUNCTION public.dcl_custom_code_au0_fn();


--
-- Name: dcl_custom_code dcl_custom_code_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_custom_code_bi0 BEFORE INSERT ON public.dcl_custom_code FOR EACH ROW EXECUTE FUNCTION public.dcl_custom_code_bi0_fn();


--
-- Name: dcl_custom_code dcl_custom_code_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_custom_code_bu0 BEFORE UPDATE ON public.dcl_custom_code FOR EACH ROW EXECUTE FUNCTION public.dcl_custom_code_bu0_fn();


--
-- Name: dcl_delivery_request dcl_delivery_request_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_delivery_request_bi0 BEFORE INSERT ON public.dcl_delivery_request FOR EACH ROW EXECUTE FUNCTION public.dcl_delivery_request_bi0_fn();


--
-- Name: dcl_delivery_request dcl_delivery_request_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_delivery_request_bu0 BEFORE UPDATE ON public.dcl_delivery_request FOR EACH ROW EXECUTE FUNCTION public.dcl_delivery_request_bu0_fn();


--
-- Name: dcl_department dcl_department_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_department_bi0 BEFORE INSERT ON public.dcl_department FOR EACH ROW EXECUTE FUNCTION public.dcl_department_bi0_fn();


--
-- Name: dcl_dlr_list_produce dcl_dlr_list_produce_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_dlr_list_produce_bd0 BEFORE DELETE ON public.dcl_dlr_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_dlr_list_produce_bd0_fn();


--
-- Name: dcl_dlr_list_produce dcl_dlr_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_dlr_list_produce_bi0 BEFORE INSERT ON public.dcl_dlr_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_dlr_list_produce_bi0_fn();


--
-- Name: dcl_dlr_list_produce dcl_dlr_list_produce_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_dlr_list_produce_bu0 BEFORE UPDATE ON public.dcl_dlr_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_dlr_list_produce_bu0_fn();


--
-- Name: dcl_field_comment dcl_field_comment_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_field_comment_bi0 BEFORE INSERT ON public.dcl_field_comment FOR EACH ROW EXECUTE FUNCTION public.dcl_field_comment_bi0_fn();


--
-- Name: dcl_files_path dcl_files_path_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_files_path_bi0 BEFORE INSERT ON public.dcl_files_path FOR EACH ROW EXECUTE FUNCTION public.dcl_files_path_bi0_fn();


--
-- Name: dcl_inf_message dcl_inf_message_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_inf_message_bi0 BEFORE INSERT ON public.dcl_inf_message FOR EACH ROW EXECUTE FUNCTION public.dcl_inf_message_bi0_fn();


--
-- Name: dcl_instruction dcl_instruction_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_instruction_bd0 BEFORE DELETE ON public.dcl_instruction FOR EACH ROW EXECUTE FUNCTION public.dcl_instruction_bd0_fn();


--
-- Name: dcl_instruction dcl_instruction_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_instruction_bi0 BEFORE INSERT ON public.dcl_instruction FOR EACH ROW EXECUTE FUNCTION public.dcl_instruction_bi0_fn();


--
-- Name: dcl_instruction dcl_instruction_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_instruction_bu0 BEFORE UPDATE ON public.dcl_instruction FOR EACH ROW EXECUTE FUNCTION public.dcl_instruction_bu0_fn();


--
-- Name: dcl_instruction_type dcl_instruction_type_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_instruction_type_bi0 BEFORE INSERT ON public.dcl_instruction_type FOR EACH ROW EXECUTE FUNCTION public.dcl_instruction_type_bi0_fn();


--
-- Name: dcl_language dcl_language_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_language_bi0 BEFORE INSERT ON public.dcl_language FOR EACH ROW EXECUTE FUNCTION public.dcl_language_bi0_fn();


--
-- Name: dcl_log dcl_log_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_log_bi0 BEFORE INSERT ON public.dcl_log FOR EACH ROW EXECUTE FUNCTION public.dcl_log_bi0_fn();


--
-- Name: dcl_lps_list_manager dcl_lps_list_manager_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_lps_list_manager_bi0 BEFORE INSERT ON public.dcl_lps_list_manager FOR EACH ROW EXECUTE FUNCTION public.dcl_lps_list_manager_bi0_fn();


--
-- Name: dcl_montage_adjustment dcl_montage_adjustment_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_montage_adjustment_bio BEFORE INSERT ON public.dcl_montage_adjustment FOR EACH ROW EXECUTE FUNCTION public.dcl_montage_adjustment_bio_fn();


--
-- Name: dcl_montage_adjustment_h dcl_montage_adjustment_h_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_montage_adjustment_h_bio BEFORE INSERT ON public.dcl_montage_adjustment_h FOR EACH ROW EXECUTE FUNCTION public.dcl_montage_adjustment_h_bio_fn();


--
-- Name: dcl_montage_adjustment_h dcl_montage_adjustment_h_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_montage_adjustment_h_bu0 BEFORE UPDATE ON public.dcl_montage_adjustment_h FOR EACH ROW EXECUTE FUNCTION public.dcl_montage_adjustment_h_bu0_fn();


--
-- Name: dcl_ord_list_pay_sum dcl_ord_list_pay_sum_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ord_list_pay_sum_bi0 BEFORE INSERT ON public.dcl_ord_list_pay_sum FOR EACH ROW EXECUTE FUNCTION public.dcl_ord_list_pay_sum_bi0_fn();


--
-- Name: dcl_ord_list_payment dcl_ord_list_payment_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ord_list_payment_bi0 BEFORE INSERT ON public.dcl_ord_list_payment FOR EACH ROW EXECUTE FUNCTION public.dcl_ord_list_payment_bi0_fn();


--
-- Name: dcl_ord_list_produce dcl_ord_list_produce_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ord_list_produce_ai0 AFTER INSERT ON public.dcl_ord_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_ord_list_produce_ai0_fn();


--
-- Name: dcl_ord_list_produce dcl_ord_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ord_list_produce_bi0 BEFORE INSERT ON public.dcl_ord_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_ord_list_produce_bi0_fn();


--
-- Name: dcl_ord_message dcl_ord_message_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ord_message_bi0 BEFORE INSERT ON public.dcl_ord_message FOR EACH ROW EXECUTE FUNCTION public.dcl_ord_message_bi0_fn();


--
-- Name: dcl_order dcl_order_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_order_ai0 AFTER INSERT ON public.dcl_order FOR EACH ROW EXECUTE FUNCTION public.dcl_order_ai0_fn();


--
-- Name: dcl_order dcl_order_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_order_bd0 BEFORE DELETE ON public.dcl_order FOR EACH ROW EXECUTE FUNCTION public.dcl_order_bd0_fn();


--
-- Name: dcl_order dcl_order_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_order_bi0 BEFORE INSERT ON public.dcl_order FOR EACH ROW EXECUTE FUNCTION public.dcl_order_bi0_fn();


--
-- Name: dcl_order dcl_order_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_order_bu0 BEFORE UPDATE ON public.dcl_order FOR EACH ROW EXECUTE FUNCTION public.dcl_order_bu0_fn();


--
-- Name: dcl_outgoing_letter dcl_outgoing_letter_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_outgoing_letter_bd0 BEFORE DELETE ON public.dcl_outgoing_letter FOR EACH ROW EXECUTE FUNCTION public.dcl_outgoing_letter_bd0_fn();


--
-- Name: dcl_outgoing_letter dcl_outgoing_letter_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_outgoing_letter_bi0 BEFORE INSERT ON public.dcl_outgoing_letter FOR EACH ROW EXECUTE FUNCTION public.dcl_outgoing_letter_bi0_fn();


--
-- Name: dcl_outgoing_letter dcl_outgoing_letter_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_outgoing_letter_bu0 BEFORE UPDATE ON public.dcl_outgoing_letter FOR EACH ROW EXECUTE FUNCTION public.dcl_outgoing_letter_bu0_fn();


--
-- Name: dcl_pay_list_summ dcl_pay_list_summ_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_pay_list_summ_bi0 BEFORE INSERT ON public.dcl_pay_list_summ FOR EACH ROW EXECUTE FUNCTION public.dcl_pay_list_summ_bi0_fn();


--
-- Name: dcl_pay_message dcl_pay_message_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_pay_message_bi0 BEFORE INSERT ON public.dcl_pay_message FOR EACH ROW EXECUTE FUNCTION public.dcl_pay_message_bi0_fn();


--
-- Name: dcl_payment dcl_payment_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_payment_bi0 BEFORE INSERT ON public.dcl_payment FOR EACH ROW EXECUTE FUNCTION public.dcl_payment_bi0_fn();


--
-- Name: dcl_payment dcl_payment_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_payment_bu0 BEFORE UPDATE ON public.dcl_payment FOR EACH ROW EXECUTE FUNCTION public.dcl_payment_bu0_fn();


--
-- Name: dcl_prc_list_produce dcl_prc_list_produce_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_prc_list_produce_ai0 AFTER INSERT ON public.dcl_prc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_prc_list_produce_ai0_fn();


--
-- Name: dcl_prc_list_produce dcl_prc_list_produce_au0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_prc_list_produce_au0 AFTER UPDATE ON public.dcl_prc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_prc_list_produce_au0_fn();


--
-- Name: dcl_prc_list_produce dcl_prc_list_produce_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_prc_list_produce_bd0 BEFORE DELETE ON public.dcl_prc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_prc_list_produce_bd0_fn();


--
-- Name: dcl_prc_list_produce dcl_prc_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_prc_list_produce_bi0 BEFORE INSERT ON public.dcl_prc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_prc_list_produce_bi0_fn();


--
-- Name: dcl_prc_list_produce dcl_prc_list_produce_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_prc_list_produce_bu0 BEFORE UPDATE ON public.dcl_prc_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_prc_list_produce_bu0_fn();


--
-- Name: dcl_produce dcl_produce_bd0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_produce_bd0 BEFORE DELETE ON public.dcl_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_produce_bd0_fn();


--
-- Name: dcl_produce dcl_produce_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_produce_bio BEFORE INSERT ON public.dcl_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_produce_bio_fn();


--
-- Name: dcl_produce_cost dcl_produce_cost_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_produce_cost_bi0 BEFORE INSERT ON public.dcl_produce_cost FOR EACH ROW EXECUTE FUNCTION public.dcl_produce_cost_bi0_fn();


--
-- Name: dcl_produce_cost dcl_produce_cost_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_produce_cost_bu0 BEFORE UPDATE ON public.dcl_produce_cost FOR EACH ROW EXECUTE FUNCTION public.dcl_produce_cost_bu0_fn();


--
-- Name: dcl_production_term dcl_production_term_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_production_term_bi0 BEFORE INSERT ON public.dcl_production_term FOR EACH ROW EXECUTE FUNCTION public.dcl_production_term_bi0_fn();


--
-- Name: dcl_purchase_purpose dcl_purchase_purpose_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_purchase_purpose_bi0 BEFORE INSERT ON public.dcl_purchase_purpose FOR EACH ROW EXECUTE FUNCTION public.dcl_purchase_purpose_bi0_fn();


--
-- Name: dcl_purpose dcl_purpose_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_purpose_bi0 BEFORE INSERT ON public.dcl_purpose FOR EACH ROW EXECUTE FUNCTION public.dcl_purpose_bi0_fn();


--
-- Name: dcl_rate_nds dcl_rate_nds_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_rate_nds_bi0 BEFORE INSERT ON public.dcl_rate_nds FOR EACH ROW EXECUTE FUNCTION public.dcl_rate_nds_bi0_fn();


--
-- Name: dcl_ready_for_shipping dcl_ready_for_shipping_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_ready_for_shipping_bi0 BEFORE INSERT ON public.dcl_ready_for_shipping FOR EACH ROW EXECUTE FUNCTION public.dcl_ready_for_shipping_bi0_fn();


--
-- Name: dcl_reputation dcl_reputation_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_reputation_bi0 BEFORE INSERT ON public.dcl_reputation FOR EACH ROW EXECUTE FUNCTION public.dcl_reputation_bi0_fn();


--
-- Name: dcl_reputation dcl_reputation_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_reputation_bu0 BEFORE UPDATE ON public.dcl_reputation FOR EACH ROW EXECUTE FUNCTION public.dcl_reputation_bu0_fn();


--
-- Name: dcl_role dcl_role_bio; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_role_bio BEFORE INSERT ON public.dcl_role FOR EACH ROW EXECUTE FUNCTION public.dcl_role_bio_fn();


--
-- Name: dcl_route dcl_route_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_route_bi0 BEFORE INSERT ON public.dcl_route FOR EACH ROW EXECUTE FUNCTION public.dcl_route_bi0_fn();


--
-- Name: dcl_seller dcl_seller_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_seller_bi0 BEFORE INSERT ON public.dcl_seller FOR EACH ROW EXECUTE FUNCTION public.dcl_seller_bi0_fn();


--
-- Name: dcl_setting dcl_setting_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_setting_bi0 BEFORE INSERT ON public.dcl_setting FOR EACH ROW EXECUTE FUNCTION public.dcl_setting_bi0_fn();


--
-- Name: dcl_shipping dcl_shipping_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shipping_bi0 BEFORE INSERT ON public.dcl_shipping FOR EACH ROW EXECUTE FUNCTION public.dcl_shipping_bi0_fn();


--
-- Name: dcl_shipping dcl_shipping_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shipping_bu0 BEFORE UPDATE ON public.dcl_shipping FOR EACH ROW EXECUTE FUNCTION public.dcl_shipping_bu0_fn();


--
-- Name: dcl_shp_doc_type dcl_shp_doc_type_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shp_doc_type_bi0 BEFORE INSERT ON public.dcl_shp_doc_type FOR EACH ROW EXECUTE FUNCTION public.dcl_shp_doc_type_bi0_fn();


--
-- Name: dcl_shp_list_produce dcl_shp_list_produce_ai0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shp_list_produce_ai0 AFTER INSERT ON public.dcl_shp_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_shp_list_produce_ai0_fn();


--
-- Name: dcl_shp_list_produce dcl_shp_list_produce_au0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shp_list_produce_au0 AFTER UPDATE ON public.dcl_shp_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_shp_list_produce_au0_fn();


--
-- Name: dcl_shp_list_produce dcl_shp_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shp_list_produce_bi0 BEFORE INSERT ON public.dcl_shp_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_shp_list_produce_bi0_fn();


--
-- Name: dcl_shp_list_produce dcl_shp_list_produce_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_shp_list_produce_bu0 BEFORE UPDATE ON public.dcl_shp_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_shp_list_produce_bu0_fn();


--
-- Name: dcl_spc_list_payment dcl_spc_list_payment_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_spc_list_payment_bi0 BEFORE INSERT ON public.dcl_spc_list_payment FOR EACH ROW EXECUTE FUNCTION public.dcl_spc_list_payment_bi0_fn();


--
-- Name: dcl_specification_import dcl_specification_import_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_specification_import_bi0 BEFORE INSERT ON public.dcl_specification_import FOR EACH ROW EXECUTE FUNCTION public.dcl_specification_import_bi0_fn();


--
-- Name: dcl_specification_import dcl_specification_import_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_specification_import_bu0 BEFORE UPDATE ON public.dcl_specification_import FOR EACH ROW EXECUTE FUNCTION public.dcl_specification_import_bu0_fn();


--
-- Name: dcl_spi_list_produce dcl_spi_list_produce_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_spi_list_produce_bi0 BEFORE INSERT ON public.dcl_spi_list_produce FOR EACH ROW EXECUTE FUNCTION public.dcl_spi_list_produce_bi0_fn();


--
-- Name: dcl_stuff_category dcl_stuff_category_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_stuff_category_bi0 BEFORE INSERT ON public.dcl_stuff_category FOR EACH ROW EXECUTE FUNCTION public.dcl_stuff_category_bi0_fn();


--
-- Name: dcl_term_inco dcl_term_inco_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_term_inco_bi0 BEFORE INSERT ON public.dcl_term_inco FOR EACH ROW EXECUTE FUNCTION public.dcl_term_inco_bi0_fn();


--
-- Name: dcl_test dcl_test_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_test_bi0 BEFORE INSERT ON public.dcl_test FOR EACH ROW EXECUTE FUNCTION public.dcl_test_bi0_fn();


--
-- Name: dcl_timeboard dcl_timeboard_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_timeboard_bi0 BEFORE INSERT ON public.dcl_timeboard FOR EACH ROW EXECUTE FUNCTION public.dcl_timeboard_bi0_fn();


--
-- Name: dcl_timeboard dcl_timeboard_bu0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_timeboard_bu0 BEFORE UPDATE ON public.dcl_timeboard FOR EACH ROW EXECUTE FUNCTION public.dcl_timeboard_bu0_fn();


--
-- Name: dcl_tmb_list_work dcl_tmb_list_work_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_tmb_list_work_bi0 BEFORE INSERT ON public.dcl_tmb_list_work FOR EACH ROW EXECUTE FUNCTION public.dcl_tmb_list_work_bi0_fn();


--
-- Name: dcl_unit dcl_unit_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_unit_bi0 BEFORE INSERT ON public.dcl_unit FOR EACH ROW EXECUTE FUNCTION public.dcl_unit_bi0_fn();


--
-- Name: dcl_user dcl_user_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_user_bi0 BEFORE INSERT ON public.dcl_user FOR EACH ROW EXECUTE FUNCTION public.dcl_user_bi0_fn();


--
-- Name: dcl_user_link dcl_user_link_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_user_link_bi0 BEFORE INSERT ON public.dcl_user_link FOR EACH ROW EXECUTE FUNCTION public.dcl_user_link_bi0_fn();


--
-- Name: dcl_user_setting dcl_user_setting_bi0; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER dcl_user_setting_bi0 BEFORE INSERT ON public.dcl_user_setting FOR EACH ROW EXECUTE FUNCTION public.dcl_user_setting_bi0_fn();


--
-- PostgreSQL database dump complete
--

\unrestrict ILOHr4Qm7MTSfszFVUQ2GBU4GV1FrpWugN4WwOzUXtHiNuz7UvQMhkQWoEUsL56

