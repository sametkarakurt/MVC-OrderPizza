--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5
-- Dumped by pg_dump version 13.5

-- Started on 2021-12-20 14:08:37 +03

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
-- TOC entry 226 (class 1255 OID 19387)
-- Name: deleteorder(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deleteorder(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
begin 
DELETE FROM siparis WHERE siparis.siparis_id=$1;
return 'Sipariş Silindi';
end;
$_$;


ALTER FUNCTION public.deleteorder(integer) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 19384)
-- Name: getall(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getall() RETURNS TABLE(musteri_id integer, ad_soyad character varying, telefon_no character varying, adres character varying, siparis_id integer, teslimat_turu character varying, sube_adi character varying, ucret integer, personel_adi character varying, odeme_turu character varying)
    LANGUAGE plpgsql
    AS $$
begin 
RETURN QUERY
SELECT musteri.musteri_id,musteri.ad_soyad,musteri.telefon_no,musteri.adres,siparis.siparis_id,teslimat.teslimat_turu,sube.sube_adi,siparis.ucret,personel.personel_adi,odeme.odeme_turu FROM musteri JOIN siparis ON musteri.musteri_id = siparis.musteri_id JOIN odeme on odeme.odeme_id = siparis.odeme_id JOIN teslimat on teslimat.teslimat_id = siparis.teslimat_id JOIN sube on sube.sube_id = siparis.sube_id JOIN personel on personel.personel_id = siparis.personel_id;
end;
$$;


ALTER FUNCTION public.getall() OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 19385)
-- Name: getmusteri(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getmusteri(integer) RETURNS TABLE(musteri_id integer, ad_soyad character varying, telefon_no character varying, adres character varying)
    LANGUAGE plpgsql
    AS $_$
begin 
RETURN QUERY
SELECT musteri.musteri_id,musteri.ad_soyad,musteri.telefon_no,musteri.adres FROM musteri JOIN siparis ON musteri.musteri_id = siparis.musteri_id WHERE siparis.siparis_id = $1;
end;
$_$;


ALTER FUNCTION public.getmusteri(integer) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 19386)
-- Name: getpizza(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getpizza(integer) RETURNS TABLE(pizza_secenegi character varying, hamur_tipi character varying, sos_turu character varying, boyut_turu character varying, peynir_miktari character varying, kenar_turu character varying)
    LANGUAGE plpgsql
    AS $_$
begin 
RETURN QUERY
SELECT pizza_secenekleri.pizza_secenegi,hamur.hamur_tipi,sos.sos_turu,boyut.boyut_turu,peynir.peynir_miktari,kenar.kenar_turu FROM pizza JOIN siparis on siparis.pizza_id = pizza.pizza_id JOIN kenar on kenar.kenar_id = pizza.kenar_id JOIN hamur on hamur.hamur_id = pizza.hamur_id JOIN sos on sos.sos_id = pizza.sos_id JOIN boyut on boyut.boyut_id = pizza.boyut_id JOIN peynir on peynir.peynir_id = pizza.peynir_id JOIN pizza_secenekleri on pizza_secenekleri.pizza_secenek_id = pizza.pizza_secenek_id WHERE siparis.siparis_id = $1;
end;
$_$;


ALTER FUNCTION public.getpizza(integer) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 19376)
-- Name: kazanc_ekleme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kazanc_ekleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
toplam integer;
begin 
toplam:=(select sum(ucret) from siparis);
update toplam_kazanc set kazanc = toplam;
return new;
end;
$$;


ALTER FUNCTION public.kazanc_ekleme() OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 19378)
-- Name: kazanc_silme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kazanc_silme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
toplam integer;
begin 
toplam:=(select sum(ucret) from siparis);
update toplam_kazanc set kazanc = toplam;
return new;
end;
$$;


ALTER FUNCTION public.kazanc_silme() OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 19372)
-- Name: save_customer(integer, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.save_customer(integer, character varying, character varying, character varying)
    LANGUAGE plpgsql
    AS $_$

BEGIN
INSERT INTO musteri (musteri_id, ad_soyad, telefon_no, adres) values ($1,$2,$3,$4);
COMMIT;

END;
$_$;


ALTER PROCEDURE public.save_customer(integer, character varying, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 19373)
-- Name: save_order(integer, integer, integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.save_order(integer, integer, integer, integer, integer, integer, integer, integer)
    LANGUAGE plpgsql
    AS $_$

BEGIN
INSERT INTO siparis (siparis_id, musteri_id, odeme_id, teslimat_id, sube_id, personel_id, ucret,pizza_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);
COMMIT;

END;
$_$;


ALTER PROCEDURE public.save_order(integer, integer, integer, integer, integer, integer, integer, integer) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 19374)
-- Name: save_pizza(integer, integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.save_pizza(integer, integer, integer, integer, integer, integer, integer)
    LANGUAGE plpgsql
    AS $_$

BEGIN
INSERT INTO pizza (pizza_id, pizza_secenek_id, hamur_id, sos_id, boyut_id, peynir_id, kenar_id) VALUES ($1, $2, $3, $4, $5, $6, $7);
COMMIT;

END;
$_$;


ALTER PROCEDURE public.save_pizza(integer, integer, integer, integer, integer, integer, integer) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 19380)
-- Name: siparis_ekleme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.siparis_ekleme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	update toplam_siparis set toplam_siparis = toplam_siparis + 1;
return new;
end;
$$;


ALTER FUNCTION public.siparis_ekleme() OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 19382)
-- Name: siparis_silme(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.siparis_silme() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	update toplam_siparis set toplam_siparis = toplam_siparis - 1;
return new;
end;
$$;


ALTER FUNCTION public.siparis_silme() OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 19375)
-- Name: update(character varying, character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update(character varying, character varying, character varying, integer)
    LANGUAGE plpgsql
    AS $_$

BEGIN
UPDATE musteri SET ad_soyad=$1,telefon_no=$2,adres=$3 WHERE musteri_id=$4;
COMMIT;

END;
$_$;


ALTER PROCEDURE public.update(character varying, character varying, character varying, integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 200 (class 1259 OID 19219)
-- Name: boyut; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boyut (
    boyut_id integer NOT NULL,
    boyut_turu character varying NOT NULL
);


ALTER TABLE public.boyut OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 19227)
-- Name: hamur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hamur (
    hamur_id integer NOT NULL,
    hamur_tipi character varying(40) NOT NULL
);


ALTER TABLE public.hamur OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 19232)
-- Name: kenar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kenar (
    kenar_id integer NOT NULL,
    kenar_turu character varying NOT NULL
);


ALTER TABLE public.kenar OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 19240)
-- Name: musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.musteri (
    musteri_id integer NOT NULL,
    ad_soyad character varying NOT NULL,
    telefon_no character varying NOT NULL,
    adres character varying NOT NULL
);


ALTER TABLE public.musteri OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 19248)
-- Name: odeme; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.odeme (
    odeme_id integer NOT NULL,
    odeme_turu character varying NOT NULL
);


ALTER TABLE public.odeme OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 19256)
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    personel_id integer NOT NULL,
    personel_adi character varying NOT NULL
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 19264)
-- Name: peynir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.peynir (
    peynir_id integer NOT NULL,
    peynir_miktari character varying(40) NOT NULL
);


ALTER TABLE public.peynir OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 19269)
-- Name: pizza; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizza (
    pizza_id integer NOT NULL,
    hamur_id integer NOT NULL,
    sos_id integer NOT NULL,
    boyut_id integer NOT NULL,
    peynir_id integer NOT NULL,
    pizza_secenek_id integer NOT NULL,
    kenar_id integer NOT NULL
);


ALTER TABLE public.pizza OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 19274)
-- Name: pizza_secenekleri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pizza_secenekleri (
    pizza_secenek_id integer NOT NULL,
    pizza_secenegi character varying NOT NULL
);


ALTER TABLE public.pizza_secenekleri OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 19282)
-- Name: siparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siparis (
    siparis_id integer NOT NULL,
    musteri_id integer NOT NULL,
    odeme_id integer NOT NULL,
    teslimat_id integer NOT NULL,
    sube_id integer NOT NULL,
    ucret integer NOT NULL,
    personel_id integer NOT NULL,
    pizza_id integer NOT NULL
);


ALTER TABLE public.siparis OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 19287)
-- Name: sos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sos (
    sos_id integer NOT NULL,
    sos_turu character varying NOT NULL
);


ALTER TABLE public.sos OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 19295)
-- Name: sube; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sube (
    sube_id integer NOT NULL,
    sube_adi character varying NOT NULL,
    sube_telno character varying NOT NULL,
    sube_adres character varying NOT NULL
);


ALTER TABLE public.sube OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 19303)
-- Name: teslimat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teslimat (
    teslimat_id integer NOT NULL,
    teslimat_turu character varying NOT NULL
);


ALTER TABLE public.teslimat OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 19311)
-- Name: toplam_kazanc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplam_kazanc (
    kazanc integer
);


ALTER TABLE public.toplam_kazanc OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 19314)
-- Name: toplam_siparis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toplam_siparis (
    toplam_siparis integer
);


ALTER TABLE public.toplam_siparis OWNER TO postgres;

--
-- TOC entry 3276 (class 0 OID 19219)
-- Dependencies: 200
-- Data for Name: boyut; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.boyut (boyut_id, boyut_turu) VALUES (1, 'Küçük');
INSERT INTO public.boyut (boyut_id, boyut_turu) VALUES (2, 'Orta');
INSERT INTO public.boyut (boyut_id, boyut_turu) VALUES (3, 'Büyük');


--
-- TOC entry 3277 (class 0 OID 19227)
-- Dependencies: 201
-- Data for Name: hamur; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.hamur (hamur_id, hamur_tipi) VALUES (1, 'Orijinal');
INSERT INTO public.hamur (hamur_id, hamur_tipi) VALUES (2, 'İtalyan');
INSERT INTO public.hamur (hamur_id, hamur_tipi) VALUES (3, 'Peynirli');


--
-- TOC entry 3278 (class 0 OID 19232)
-- Dependencies: 202
-- Data for Name: kenar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.kenar (kenar_id, kenar_turu) VALUES (1, 'Sarımsaklı');
INSERT INTO public.kenar (kenar_id, kenar_turu) VALUES (2, 'Barbekülü');
INSERT INTO public.kenar (kenar_id, kenar_turu) VALUES (3, 'Ballı Hardallı');


--
-- TOC entry 3279 (class 0 OID 19240)
-- Dependencies: 203
-- Data for Name: musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3280 (class 0 OID 19248)
-- Dependencies: 204
-- Data for Name: odeme; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.odeme (odeme_id, odeme_turu) VALUES (1, 'Kartla Ödeme');
INSERT INTO public.odeme (odeme_id, odeme_turu) VALUES (2, 'Kapıda Ödeme');


--
-- TOC entry 3281 (class 0 OID 19256)
-- Dependencies: 205
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.personel (personel_id, personel_adi) VALUES (1, 'Ahmet Kapıcı');
INSERT INTO public.personel (personel_id, personel_adi) VALUES (2, 'Elif Aydın');
INSERT INTO public.personel (personel_id, personel_adi) VALUES (3, 'Sercan Polat');
INSERT INTO public.personel (personel_id, personel_adi) VALUES (4, 'Nisa Tunahan');


--
-- TOC entry 3282 (class 0 OID 19264)
-- Dependencies: 206
-- Data for Name: peynir; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.peynir (peynir_id, peynir_miktari) VALUES (1, 'Az');
INSERT INTO public.peynir (peynir_id, peynir_miktari) VALUES (2, 'Orta');
INSERT INTO public.peynir (peynir_id, peynir_miktari) VALUES (3, 'Çok');


--
-- TOC entry 3283 (class 0 OID 19269)
-- Dependencies: 207
-- Data for Name: pizza; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (1224439, 1, 1, 1, 1, 1, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (9765520, 1, 1, 1, 1, 1, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (2885747, 1, 1, 1, 1, 1, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (8338234, 1, 1, 1, 1, 1, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (4846495, 2, 2, 3, 2, 2, 2);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (2471798, 1, 1, 1, 1, 1, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (658864, 2, 3, 2, 2, 2, 2);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (4523451, 1, 3, 2, 2, 3, 2);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (6408299, 2, 1, 1, 1, 2, 1);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (225859, 1, 3, 2, 1, 3, 2);
INSERT INTO public.pizza (pizza_id, hamur_id, sos_id, boyut_id, peynir_id, pizza_secenek_id, kenar_id) VALUES (1626228, 2, 1, 2, 3, 3, 2);


--
-- TOC entry 3284 (class 0 OID 19274)
-- Dependencies: 208
-- Data for Name: pizza_secenekleri; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (1, 'Bol Malzemos');
INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (2, 'Tavuklu');
INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (3, 'Sucuksever');
INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (4, 'Karışık Pizza');
INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (5, 'Margarita');
INSERT INTO public.pizza_secenekleri (pizza_secenek_id, pizza_secenegi) VALUES (6, 'Italiano');


--
-- TOC entry 3285 (class 0 OID 19282)
-- Dependencies: 209
-- Data for Name: siparis; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3286 (class 0 OID 19287)
-- Dependencies: 210
-- Data for Name: sos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sos (sos_id, sos_turu) VALUES (1, 'Sarımsak');
INSERT INTO public.sos (sos_id, sos_turu) VALUES (2, 'Ballı Hardallı');
INSERT INTO public.sos (sos_id, sos_turu) VALUES (3, 'Barbekü');
INSERT INTO public.sos (sos_id, sos_turu) VALUES (4, 'Dominos');


--
-- TOC entry 3287 (class 0 OID 19295)
-- Dependencies: 211
-- Data for Name: sube; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sube (sube_id, sube_adi, sube_telno, sube_adres) VALUES (1, 'Serdivan', '02643332222', 'İstiklal, Bağlar Cd. No: 62/9, 54055 Serdivan/Sakarya');
INSERT INTO public.sube (sube_id, sube_adi, sube_telno, sube_adres) VALUES (2, 'Adapazarı', '02642814747', 'Cumhuriyet, Dr.Nuri Bayar Cd no39/A, 54000 Adapazarı/Sakarya');


--
-- TOC entry 3288 (class 0 OID 19303)
-- Dependencies: 212
-- Data for Name: teslimat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teslimat (teslimat_id, teslimat_turu) VALUES (1, 'Şubeden Teslim');
INSERT INTO public.teslimat (teslimat_id, teslimat_turu) VALUES (2, 'Adrese Teslim');


--
-- TOC entry 3289 (class 0 OID 19311)
-- Dependencies: 213
-- Data for Name: toplam_kazanc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.toplam_kazanc (kazanc) VALUES (NULL);


--
-- TOC entry 3290 (class 0 OID 19314)
-- Dependencies: 214
-- Data for Name: toplam_siparis; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.toplam_siparis (toplam_siparis) VALUES (0);


--
-- TOC entry 3106 (class 2606 OID 19226)
-- Name: boyut boyut_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boyut
    ADD CONSTRAINT boyut_pkey PRIMARY KEY (boyut_id);


--
-- TOC entry 3108 (class 2606 OID 19231)
-- Name: hamur hamur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hamur
    ADD CONSTRAINT hamur_pkey PRIMARY KEY (hamur_id);


--
-- TOC entry 3110 (class 2606 OID 19239)
-- Name: kenar kenar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenar
    ADD CONSTRAINT kenar_pkey PRIMARY KEY (kenar_id);


--
-- TOC entry 3112 (class 2606 OID 19247)
-- Name: musteri musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.musteri
    ADD CONSTRAINT musteri_pkey PRIMARY KEY (musteri_id);


--
-- TOC entry 3114 (class 2606 OID 19255)
-- Name: odeme odeme_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odeme
    ADD CONSTRAINT odeme_pkey PRIMARY KEY (odeme_id);


--
-- TOC entry 3116 (class 2606 OID 19263)
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personel_id);


--
-- TOC entry 3118 (class 2606 OID 19268)
-- Name: peynir peynir_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peynir
    ADD CONSTRAINT peynir_pkey PRIMARY KEY (peynir_id);


--
-- TOC entry 3120 (class 2606 OID 19273)
-- Name: pizza pizza_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT pizza_pkey PRIMARY KEY (pizza_id);


--
-- TOC entry 3122 (class 2606 OID 19281)
-- Name: pizza_secenekleri pizza_secenekleri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza_secenekleri
    ADD CONSTRAINT pizza_secenekleri_pkey PRIMARY KEY (pizza_secenek_id);


--
-- TOC entry 3124 (class 2606 OID 19286)
-- Name: siparis siparis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT siparis_pkey PRIMARY KEY (siparis_id);


--
-- TOC entry 3126 (class 2606 OID 19294)
-- Name: sos sos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sos
    ADD CONSTRAINT sos_pkey PRIMARY KEY (sos_id);


--
-- TOC entry 3128 (class 2606 OID 19302)
-- Name: sube sube_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sube
    ADD CONSTRAINT sube_pkey PRIMARY KEY (sube_id);


--
-- TOC entry 3130 (class 2606 OID 19310)
-- Name: teslimat teslimat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teslimat
    ADD CONSTRAINT teslimat_pkey PRIMARY KEY (teslimat_id);


--
-- TOC entry 3142 (class 2620 OID 19377)
-- Name: siparis kazancekleme; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kazancekleme AFTER INSERT ON public.siparis FOR EACH ROW EXECUTE FUNCTION public.kazanc_ekleme();


--
-- TOC entry 3143 (class 2620 OID 19379)
-- Name: siparis kazancsilme; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER kazancsilme AFTER DELETE ON public.siparis FOR EACH ROW EXECUTE FUNCTION public.kazanc_silme();


--
-- TOC entry 3144 (class 2620 OID 19381)
-- Name: siparis siparisekleme; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER siparisekleme AFTER INSERT ON public.siparis FOR EACH ROW EXECUTE FUNCTION public.siparis_ekleme();


--
-- TOC entry 3145 (class 2620 OID 19383)
-- Name: siparis siparissilme; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER siparissilme AFTER DELETE ON public.siparis FOR EACH ROW EXECUTE FUNCTION public.siparis_silme();


--
-- TOC entry 3131 (class 2606 OID 19317)
-- Name: pizza boyut_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT boyut_id FOREIGN KEY (boyut_id) REFERENCES public.boyut(boyut_id) NOT VALID;


--
-- TOC entry 3132 (class 2606 OID 19322)
-- Name: pizza hamur_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT hamur_id FOREIGN KEY (hamur_id) REFERENCES public.hamur(hamur_id) NOT VALID;


--
-- TOC entry 3133 (class 2606 OID 19327)
-- Name: pizza kenar_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT kenar_id FOREIGN KEY (kenar_id) REFERENCES public.kenar(kenar_id) NOT VALID;


--
-- TOC entry 3137 (class 2606 OID 19347)
-- Name: siparis musteri_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT musteri_id FOREIGN KEY (musteri_id) REFERENCES public.musteri(musteri_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3138 (class 2606 OID 19352)
-- Name: siparis odeme_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT odeme_id FOREIGN KEY (odeme_id) REFERENCES public.odeme(odeme_id) NOT VALID;


--
-- TOC entry 3139 (class 2606 OID 19357)
-- Name: siparis personel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT personel_id FOREIGN KEY (personel_id) REFERENCES public.personel(personel_id) NOT VALID;


--
-- TOC entry 3134 (class 2606 OID 19332)
-- Name: pizza peynir_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT peynir_id FOREIGN KEY (peynir_id) REFERENCES public.peynir(peynir_id) NOT VALID;


--
-- TOC entry 3135 (class 2606 OID 19337)
-- Name: pizza pizza_secenek_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT pizza_secenek_id FOREIGN KEY (pizza_secenek_id) REFERENCES public.pizza_secenekleri(pizza_secenek_id) NOT VALID;


--
-- TOC entry 3136 (class 2606 OID 19342)
-- Name: pizza sos_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pizza
    ADD CONSTRAINT sos_id FOREIGN KEY (sos_id) REFERENCES public.sos(sos_id) NOT VALID;


--
-- TOC entry 3140 (class 2606 OID 19362)
-- Name: siparis sube_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT sube_id FOREIGN KEY (sube_id) REFERENCES public.sube(sube_id) NOT VALID;


--
-- TOC entry 3141 (class 2606 OID 19367)
-- Name: siparis teslimat_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siparis
    ADD CONSTRAINT teslimat_id FOREIGN KEY (teslimat_id) REFERENCES public.teslimat(teslimat_id) NOT VALID;


-- Completed on 2021-12-20 14:08:37 +03

--
-- PostgreSQL database dump complete
--

