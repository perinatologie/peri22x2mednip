# peri22x2mednip
Conversie van peri22x format naar MEDNIP.

Directory layout (dit is alleen een voorbeeld, er kan een andere layout gekozen worden):

- peri2xx: Bestanden in input formaat
- mednip: MEDNIP uitvoer

In deze directories zitten voorbeelden.

- xslt: De gebruikte stylesheets
- xsd: Schema's van Peridos

## SAXON

Conversies gebeuren met Saxon HE. Zie:
https://www.art-decor.org/mediawiki/index.php?title=Schematron-validation
voor een beschrijving.

## Conversie

Voer perihub2mednip.xsl uit op een peri22x bestand. In de standaard directory layout zal:

```
Transform -t -s:.\peri22x -xsl:.\xsl\preprocess-perihub.xsl -o:.\peri22xpre\
```
Linux/OS X:
```
saxon -t -s:peri22x/voorbeeld-nipt-aanvraag-1.xml -xsl:../peri22x2hl7/xsl/preprocess-perihub.xsl  -o:peri22xpre/voorbeeld-nipt-aanvraag-1.xml
```
alles converteren naar het preprocessed formaat (voor .NET, zie Java commando voor andere omgevingen). 

## peri22x naar mednip
Dito preprocessed naar mednip:
```
Transform -t -s:.\peri22xpre\ -xsl:.\xsl\perihub2mednip.xsl -o:.\mednip\
```
Linux/OS X:
```
saxon -t -s:peri22xpre/voorbeeld-nipt-aanvraag-1.xml -xsl:./xsl/perihub2mednip.xsl  -o:mednip/voorbeeld-nipt-aanvraag-1.xml
```