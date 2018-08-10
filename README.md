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
alles converteren naar het preprocessed formaat (voor .NET, zie Java commando voor andere omgevingen). 
## peri22x naar ADA
Dito preprocessed naar ADA:
```
Transform -t -s:.\peri22xpre\ -xsl:.\xsl\perihub2mednip.xsl -o:.\mednip\
```