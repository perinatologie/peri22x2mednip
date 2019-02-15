<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="landen" select="doc('iso.xml')"/>
    <xsl:variable name="land-in" select="//value[@concept = 'peri22-dataelement-10307']/@value/string()"/>
    <xsl:variable name="iso2land">
        <xsl:choose>
            <!-- Bij geen land ingevuld, Nederland aannemen -->
            <xsl:when test="string-length($land-in) = 0">NL</xsl:when>
            <!-- ISO-3-letter code vertalen naar ISO-2 -->
            <xsl:when test="string-length($land-in) = 3">
                <xsl:value-of select="$landen//land[iso3 = $land-in]/iso2"/>
            </xsl:when>
            <!-- ISO-2-letter code controleren -->
            <xsl:when test="string-length($land-in) = 2">
                <xsl:value-of select="$landen//land[iso2 = $land-in]/iso2"/>
            </xsl:when>
            <!-- Anders land opzoeken -->
            <xsl:otherwise>
                <xsl:value-of select="$landen//land[naam = $land-in]/iso2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- Als ISO 2 lettercode gevonden, die nemen, anders originele land (zal dan in uitval komen) -->
    <xsl:variable name="land-uit">
        <xsl:choose>
            <xsl:when test="string-length($iso2land) = 2">
                <xsl:value-of select="$iso2land"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$land-in"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <MEDNIP_1>
            <envelope envelope.edisyntax="EDIFACT" envelope.acknowledgementrequest="No" envelope.testindicator="Yes"/>
            <header EDI-name="UNH">
                <header.messageidentifier messageidentifier.type="MEDNIP" messageidentifier.version="1"/>
            </header>
            <afzender>
                <afzender.persoonsnaam/>
            </afzender>
            <datumtijd EDI-name="DET" EDI-index="2">
                <xsl:value-of select="current-dateTime()"/>
            </datumtijd>
            <xsl:call-template name="Labaanvraag"/>
        </MEDNIP_1>
    </xsl:template>

    <xsl:template name="Labaanvraag">
        <Labaanvraag>
            <xsl:for-each select=".//section[@type = 'inzender']/values">
                <Labaanvraag.Afzender>
                    <!-- Geen idee wat "telecom" hier betekent -->
                    <telecom>
                        <xsl:value-of select="value[@concept = 'peri22x-telefoonnummerpraktijk']/@value/string()"/>
                    </telecom>
                    <name>
                        <xsl:value-of select="value[@concept = 'peri22x-gebruiker']/@value/string()"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="value[@concept = 'peri22x-praktijk']/@value/string()"/>
                    </name>
                </Labaanvraag.Afzender>
            </xsl:for-each>
            <Labaanvraag.Ontvanger>
                <name>Peridos productie</name>
            </Labaanvraag.Ontvanger>
            <Labaanvraag.Zorgaanbieder>
                <!-- XSD: GeenInformatie, Onbekend, Huisartspraktijk, Verloskundigenpraktijk, Ziekenhuis, Echocentrum, Laboratorium -->
                <!-- Is voor Peridos geen relevante informatie -->
                <ZorgaanbiederType>GeenInformatie</ZorgaanbiederType>
                <xsl:for-each select=".//section[@type = 'inzender']/values">
                    <Naam>
                        <xsl:value-of select="value[@concept = 'peri22x-praktijk']/@value/string()"/>
                    </Naam>
                </xsl:for-each>
                <Adres/>
                <xsl:for-each select=".//section[@type = 'inzender']/values">
                    <AGB>
                        <xsl:value-of select="value[@concept = 'peri22x-praktijk-agb']/@value/string()"/>
                    </AGB>
                </xsl:for-each>
            </Labaanvraag.Zorgaanbieder>
            <Labaanvraag.Zorgverlener>
                <!-- XSD: GeenInformatie, Onbekend, Huisartspraktijk, Verloskundigenpraktijk, Ziekenhuis, Echocentrum, Laboratorium -->
                <!-- Dit is voor Peridos geen relevante informatie -->
                <ZorgverlenerType>GeenInformatie</ZorgverlenerType>
                <xsl:for-each select=".//section[@type = 'inzender']/values">
                    <AGB>
                        <xsl:value-of select="value[@concept = 'peri22x-gebruiker-agb']/@value/string()"/>
                    </AGB>
                </xsl:for-each>
            </Labaanvraag.Zorgverlener>
            <xsl:for-each select=".//section[@type = 'client']/values">
                <Labaanvraag.Patient>
                    <BSN>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-10030']/@value/string()"/>
                    </BSN>
                    <Geboortedatum>
                        <Datum>
                            <xsl:value-of select="value[@concept = 'peri22-dataelement-10040']/@value/string()"/>
                        </Datum>
                        <!-- Geen idee of het voorbeeld goed is -->
                        <TimeZone>GeenInformatie</TimeZone>
                    </Geboortedatum>
                    <Voorletters>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-82359']/@value/string()"/>
                    </Voorletters>
                    <Voorvoegsel>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-82363']/@value/string()"/>
                    </Voorvoegsel>
                    <Achternaam>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-10043']/@value/string()"/>
                    </Achternaam>
                    <!-- De adresgegevens van de zwangere zijn verplichte velden op het formulier, dus het zou handig zijn om die hier ook verplicht te maken -->
                    <Adres>
                        <Straat>
                            <xsl:value-of select="value[@concept = 'peri22-dataelement-10301']/@value/string()"/>
                        </Straat>
                        <Huisnummer>
                            <Huisnummer>
                                <xsl:value-of select="value[@concept = 'peri22-dataelement-10302']/@value/string()"/>
                            </Huisnummer>
                            <Toevoeging>
                                <xsl:value-of select="value[@concept = 'peri22-dataelement-10303']/@value/string()"/>
                            </Toevoeging>
                        </Huisnummer>
                        <xsl:choose>
                            <xsl:when test="$land-uit != 'NL'">
                                <PostcodeBuitenland>
                                    <xsl:value-of select="value[@concept = 'peri22-dataelement-10304']/@value/string()"/>
                                </PostcodeBuitenland>
                            </xsl:when>
                            <xsl:otherwise>
                                <Postcode>
                                    <!-- Eventuele spatie in postcode verwijderen -->
                                    <xsl:value-of select="replace(value[@concept = 'peri22-dataelement-10304']/@value/string(), ' ', '')"/>
                                </Postcode>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Plaats>
                            <xsl:value-of select="value[@concept = 'peri22-dataelement-10305']/@value/string()"/>
                        </Plaats>
                        <Land>
                            <xsl:value-of select="$land-uit"/>
                        </Land>
                    </Adres>
                    <Verzekeringsnummer>
                        <xsl:value-of select="value[@concept = 'peri22x-verzekeringsnummer']/@value/string()"/>
                    </Verzekeringsnummer>
                    <Telefoonnummer>
                        <xsl:variable name="tel" select="value[@concept = 'peri22x-telefoonnummer']/@value/string()"/>
                        <xsl:choose>
                            <xsl:when test="string-length($tel) > 0">
                                <xsl:value-of select="$tel"/>
                            </xsl:when>
                            <xsl:otherwise>GeenInformatie</xsl:otherwise>
                        </xsl:choose>
                    </Telefoonnummer>
                </Labaanvraag.Patient>
            </xsl:for-each>

            <Labaanvraag.Zwangerschap>
                <xsl:for-each select=".//section[@type = 'intake']/values">
                    <LengteInCm>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-20212']/@value/string()"/>
                    </LengteInCm>
                    <!-- Uitgangspunt: datum staat in ieder consult, gewicht wordt gehaald uit laatste consult. -->
                    <!--
                        JF: laatsteConsult methode tbv laatsteGewicht werkt nog niet betrouwbaar
                        Laatste consult is er misch niet, of heeft geen gewicht.
                        Ik verwijder onderstaande even ten gunste van een nieuwe en eenvoudigere peri22x-laatste-gewicht
                        tot dat er een elegantere oplossing is, liefst in XSLT
                        <xsl:variable name="laatsteConsultDatum" select="max(//value[@concept='peri22-dataelement-80737']/xs:date(@value))"/>
                        <xsl:variable name="laatsteConsult" select="//value[@concept='peri22-dataelement-80737'][xs:date(@value) = $laatsteConsultDatum]/ancestor::section"/>
                    -->
                    <GewichtInKg>
                        <!-- Eventuele decimale komma vervangen door punt -->
                        <!-- JF: zie comment hierboven <xsl:value-of select="replace($laatsteConsult//value[@concept = 'peri22-dataelement-20211']/@value/string(), ',', '.')"/> -->
                        <xsl:value-of select="value[@concept = 'peri22x-laatste-gewicht']/@value/string()"/>
                    </GewichtInKg>
                    <ATermeDatum>
                        <Datum>
                            <!-- Neem definities a terme datum wanneer beschikbaar, anders gewone a terme datum -->
                            <xsl:choose>
                                <xsl:when test="//@concept = 'peri22-dataelement-82160'">
                                    <xsl:value-of select="value[@concept = 'peri22-dataelement-82160']/@value/string()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="value[@concept = 'peri22-dataelement-20030']/@value/string()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </Datum>
                        <TimeZone>GeenInformatie</TimeZone>
                    </ATermeDatum>
                    <Hoeveelling>
                        <xsl:value-of select="value[@concept = 'peri22-dataelement-20020']/@value/string()"/>
                    </Hoeveelling>
                    <!-- XSD: GeenInformatie, Monoamniotisch, Diamniotisch -->
                    <Amnioniciteit>
                        <xsl:for-each select="value[@concept = 'peri22-dataelement-20130']/@value/string()">
                            <xsl:choose>
                                <xsl:when test=". = '1'">Monoamniotisch</xsl:when>
                                <xsl:when test=". = '2'">Diamniotisch</xsl:when>
                                <xsl:otherwise>GeenInformatie</xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </Amnioniciteit>
                    <!-- XSD: GeenInformatie, Monochoriaal, Dichoriaal -->
                    <!-- Dichoriaal zou niet moeten kunnen, er kan alleen een labaanvraag worden gedaan voor eenlingen en monochoriale tweelingen -->
                    <Chorioniciteit>
                        <xsl:for-each select="value[@concept = 'peri22-dataelement-20140']/@value/string()">
                            <xsl:choose>
                                <xsl:when test=". = '1'">Monochoriaal</xsl:when>
                                <xsl:when test=". = '2'">Dichoriaal</xsl:when>
                                <xsl:otherwise>GeenInformatie</xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </Chorioniciteit>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <EerdereTrisomie>
                        <xsl:for-each select="value[@concept = 'peri22-dataelement-82307']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </EerdereTrisomie>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <CombinatietestKansGroterDan200>
                        <xsl:for-each select="value[@concept = 'peri22x-combitestgt200']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </CombinatietestKansGroterDan200>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <RobertsoniaanseTranslocatieZwangere>
                        <xsl:for-each select="value[@concept = 'peri22x-robertszwangere']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </RobertsoniaanseTranslocatieZwangere>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <RobertsoniaanseTranslocatiePartner>
                        <xsl:for-each select="value[@concept = 'peri22x-robertspartner']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </RobertsoniaanseTranslocatiePartner>
                </xsl:for-each>
            </Labaanvraag.Zwangerschap>
            <Labaanvraag.NIPT>
                <xsl:for-each select=".//section[@type = 'nipt']/values">
                    <!-- Deze wordt door Peridos uitgegeven als de labaanvraag definitief gemaakt wordt, dus in dit bericht altijd leeg. -->
                    <Peridoscode/>
                    <!-- In Peridos: EMC, MUMC, VUMC -->
                    <!-- Op basis van de regio waarin de zorginstelling ligt kan in Peridos automatisch het laboratorium worden bepaald. -->
                    <Laboratorium/>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <!-- Mag geen "Nee" zijn omdat er dan één of meer exclusiecriteria van toepassing zijn -->
                    <ExclusiecriteriaGeenVanAlleVanToepassing>
                        <xsl:for-each select="value[@concept = 'peri22x-exclcrit']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </ExclusiecriteriaGeenVanAlleVanToepassing>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <!-- Moet altijd "Ja" zijn, de NIPT bepaalt altijd T21, 18 en 13 -->
                    <KeuzeT21T18T13>
                        <xsl:for-each select="value[@concept = 'peri22x-keuzet21t18t13']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </KeuzeT21T18T13>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <KeuzeNevenbevindingen>
                        <xsl:for-each select="value[@concept = 'peri22x-nevenbevindingen']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </KeuzeNevenbevindingen>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <!-- Indien hier "Nee" staat dan kan de labaanvraag niet definitief worden gemaakt. -->
                    <ToestemmingsformulierGetekend>
                        <xsl:for-each select="value[@concept = 'peri22x-nipttoestgetekend']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </ToestemmingsformulierGetekend>
                    <!-- XSD: GeenInformatie, Ja, Nee -->
                    <ToestemmingBewarenRestmateriaalNaderGebruik>
                        <xsl:for-each select="value[@concept = 'peri22x-nipttoestbewaren']/@value/string()">
                            <xsl:call-template name="BoolToEnum"/>
                        </xsl:for-each>
                    </ToestemmingBewarenRestmateriaalNaderGebruik>
                </xsl:for-each>
            </Labaanvraag.NIPT>
        </Labaanvraag>
    </xsl:template>

    <xsl:template name="BoolToEnum">
        <xsl:choose>
            <xsl:when test="upper-case(.) = 'FALSE'">Nee</xsl:when>
            <xsl:when test="upper-case(.) = 'TRUE'">Ja</xsl:when>
            <xsl:otherwise>GeenInformatie</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
