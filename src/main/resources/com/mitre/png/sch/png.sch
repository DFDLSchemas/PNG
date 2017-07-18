<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" 
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:f="function"
            queryBinding="xslt2">
    
    <sch:ns uri="function" prefix="f"/>
    
    <!--  
        NOTICE
        This software was produced for the U. S. Government under 
        Basic Contract No. W15P7T-13-C-A802, and is subject to the
        Rights in Noncommercial Computer Software and Noncommercial
        Computer Software Documentation Clause 252.227-7014 (FEB 2012)
        
        © 2017 The MITRE Corporation.
        
    -->
    
    <xsl:function name="f:power" as="xs:integer">
        <xsl:param name="base" as="xs:integer" />
        <xsl:param name="power" as="xs:integer" />
        
        <xsl:variable name="result" select="1" as="xs:integer" />
        
        <xsl:choose>
            <xsl:when test="$power eq 0">1</xsl:when>
            <xsl:when test="$power eq 1"><xsl:value-of select="$base"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$base * f:power($base, $power - 1)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <sch:pattern id="Section-11.3.6.1-Time-stamp-information">
        <sch:rule context="tIME">
            <sch:assert test="matches(Year, '^197[0-9]$|^19[8-9][0-9]$|^20[0-1][0-9]$|^2020$')">
                YYYY (1970 - 2020)
            </sch:assert>
            <sch:assert test="matches(Month, '^[1-9]$|^1[0-2]$')">
                1 - 12
            </sch:assert>
            <sch:assert test="matches(Day, '^[1-9]$|^[1-2][0-9]$|^3[0-1]$')">
                1 - 31
            </sch:assert>
            <sch:assert test="matches(Hour, '^[0-9]$|^1[0-9]$|^2[0-3]$')">
                0 - 23
            </sch:assert>
            <sch:assert test="matches(Minute, '^[0-9]$|^[1-4][0-9]$|^5[0-9]$')">
                0 - 59
            </sch:assert>
            <sch:assert test="matches(Second, '^[0-9]$|^[1-5][0-9]$|^60$')">
                0 - 60
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.5.4-sPLT-Suggested-palette">
        <sch:rule context="sPLT">
            <sch:assert test="matches(Palette_Name, '^[&#32;-&#126;&#161;-&#255;]+$')">
                Palette names shall contain only printable Latin-1 characters and spaces
                (only character codes 32-126 and 161-255 decimal are allowed).
            </sch:assert>
            <sch:assert test="not(matches(Palette_Name, '^&#32;+.*'))">
                Palette name … leading spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Palette_Name, '^.*&#32;+$'))">
                Palette name … trailing spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Palette_Name, '&#32;&#32;'))">
                Palette name … consecutive spaces are not permitted.
            </sch:assert>
            <sch:assert test="Sample_Depth = ('8', '16')">
                The sPLT sample depth shall be 8 or 16.
            </sch:assert>
        </sch:rule>
        <sch:rule context="PNG">
            <sch:assert test="count(distinct-values(.//sPLT)) eq count(.//sPLT)">
                Multiple sPLT chunks are permitted, but each shall have a different palette name.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.5.3-pHYs-Physical-pixel-dimensions">
        <sch:rule context="pHYs">
            <sch:assert test="Unit = ('unknown (0)', 'metre (1)')">
                pHYs ...The following values are defined for the unit specifier: 
                0 (unit is unknown), 1 unit is the metre.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.5.2-hIST-Image-histogram">
        <sch:rule context="hIST">
            <sch:assert test="/PNG/Chunk/PLTE[1]">
                A histogram chunk can appear only when a PLTE chunk appears. 
            </sch:assert>
            <sch:assert test="count(Frequency) eq count(/PNG/Chunk/PLTE[1]/Entry)">
                A histogram chunk shall have exactly one Frequency for each entry in the PLTE chunk.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.4.6-iTXt-Internation-textual-data">
        <sch:rule context="iTXt">
            <sch:assert test="Compression_Flag = ('0','1')">
                The compression flag is 0 for uncompressed text, 1 for compressed text. 
            </sch:assert>
            <sch:assert test="Compression_Method eq '0'">
                The compression method entry defines the compression method used. 
                The only compression method defined in this International Standard is 0. 
            </sch:assert>
            <sch:assert test="not(contains(Translated_Keyword, '&#13;'))">
                Line breaks should not appear in the translated keyword.
                In the text, a newline should be represented by a single 
                linefeed character (decimal 10).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.4-tEXt-and-zTXT">
        <sch:rule context="tEXt">
            <sch:assert test="matches(Text, '^[&#10;&#32;-&#127;&#160;-&#255;]+$')">
                In the tEXt chunk, the text string associated with a keyword
                is restricted to the Latin-1 character set plus the linefeed character.
            </sch:assert>
        </sch:rule>
        <sch:rule context="zTXt">
            <sch:assert test="matches(Compressed_Text_Datastream, '^[&#10;&#32;-&#127;&#160;-&#255;]+$')">
                In the zTXt chunk, the text string associated with a keyword
                is restricted to the Latin-1 character set plus the linefeed character.
            </sch:assert>
            <sch:assert test="Compression_Method eq '0'">
                The compression method entry defines the compression method used. 
                The only value defined in this International Standard is 0
                (deflate/inflate compression).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.4-Textual-Information">
        <sch:rule context="tEXt | iTXt | zTXt">
            <sch:assert test="not(matches(Keyword, '^&#32;+.*'))">
                Keyword … leading spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Keyword, '^.*&#32;+$'))">
                Keyword … trailing spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Keyword, '&#32;&#32;'))">
                Keyword … consecutive spaces are not permitted.
            </sch:assert>
            <sch:assert test="matches(Keyword, '^[&#32;-&#126;&#161;-&#255;]+$')">
                Keyword … only character codes 32-126 and 161-255 decimal are allowed.
            </sch:assert>
            <sch:assert test="string-length(Keyword) = (1 to 79)">
                Keywords are restricted to 1 to 79 bytes in length.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.3.4-Significant-Bits">
        <sch:rule context="sBIT//Significant_Greyscale_Bits">
            <sch:assert test="xs:integer(.) gt 0">
                Each depth specified in sBIT shall be greater than zero.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sBIT//Significant_Red_Bits">
            <sch:assert test="xs:integer(.) gt 0">
                Each depth specified in sBIT shall be greater than zero.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sBIT//Significant_Green_Bits">
            <sch:assert test="xs:integer(.) gt 0">
                Each depth specified in sBIT shall be greater than zero.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sBIT//Significant_Blue_Bits">
            <sch:assert test="xs:integer(.) gt 0">
                Each depth specified in sBIT shall be greater than zero.
            </sch:assert>
        </sch:rule>
        <sch:rule context="sBIT//Significant_Alpha_Bits">
            <sch:assert test="xs:integer(.) gt 0">
                Each depth specified in sBIT shall be greater than zero.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.3.3-Embedded-ICC-Profile">
        <sch:rule context="iCCP">
            <sch:assert test="not(matches(Profile_Name, '^&#32;+.*'))">
                Profile names … leading spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Profile_Name, '^.*&#32;+$'))">
                Profile names … trailing spaces are not permitted.
            </sch:assert>
            <sch:assert test="not(matches(Profile_Name, '&#32;&#32;'))">
                Profile names … consecutive spaces are not permitted.
            </sch:assert>
            <sch:assert test="xs:integer(Compression_Method) eq 0">
                The only compression method defined in this International 
                Standard is method 0.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.3.2.1-tRNS-Transparency">
        <sch:rule context="PNG">
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 3) then (count(Chunk[tRNS][1]/tRNS/Alpha) le count(Chunk[PLTE][1]/PLTE/Entry)) else true()">
                For colour type 3 … The tRNS chunk shall not contain more alpha values 
                than there are palette entries, but a tRNS chunk may contain fewer values.
            </sch:assert>
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 4) then not((Chunk/tRNS)[1]) else true()">
                A tRNS chunk shall not appear for colour type 4, since a full 
                alpha channel is already present in those cases. 
            </sch:assert>
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 6) then not((Chunk/tRNS)[1]) else true()">
                A tRNS chunk shall not appear for colour type 6, since a full 
                alpha channel is already present in those cases. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.2.4-IDAT-Image-Data">
        <sch:rule context="PNG">
            <sch:assert test="empty(Chunk[IDAT]/following-sibling::*[not(self::Chunk[IDAT])]/following-sibling::Chunk[IDAT])">
                The IDAT chunks shall appear consecutively with no other intervening chunks.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Section-11.2.3-PLTE-Palette">
        <sch:rule context="PNG">
            <sch:assert test="not((Chunk/PLTE)[2])">
                There shall not be more than one PLTE chunk.
            </sch:assert>
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 3) then Chunk/PLTE[1] else true()">
                The PLTE chunk shall appear for colour type 3.
            </sch:assert>
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 0) then not((Chunk/PLTE)[1]) else true()">
                The PLTE chunk shall not appear for colour type 0.
            </sch:assert>
            <sch:assert test="if (Chunk[1]/IHDR/xs:integer(Color_Type) eq 4) then not((Chunk/PLTE)[1]) else true()">
                The PLTE chunk shall not appear for colour type 4.
            </sch:assert>
        </sch:rule>
        <sch:rule context="PLTE">
            <sch:assert test="Entry[1]">
                The PLTE chunk must contain at least 1 palette entry.
            </sch:assert>
            <sch:assert test="not((Entry)[257])">
                The PLTE chunk must contain no more than 256 palette entries.
            </sch:assert>
            <sch:assert test="(xs:integer(Length) mod 3) eq 0">
                A PLTE chunk length not divisible by 3 is an error.
            </sch:assert>
            <sch:assert test="count(Entry) le (f:power(2, /PNG/Chunk[1]/IHDR/Bit_Depth))">
                The number of palette entries shall not exceed the range 
                that can be represented in the image bit depth (for example, 
                2**4 = 16 for a bit depth of 4). 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    

    <sch:pattern id="Section-11.2.2-IHDR-Image-Header">
        <sch:rule context="IHDR">
            <sch:assert test="xs:integer(Width) gt 0">
                Width and height give the image dimensions in pixels. Zero width is an invalid value.
            </sch:assert>
            <sch:assert test="xs:integer(Height) gt 0">
                Width and height give the image dimensions in pixels. Zero height is an invalid value.
            </sch:assert>
            <sch:assert test="Compression_Method eq '0'">
                Only compression method 0 is defined in this International Standard.
            </sch:assert>
            <sch:assert test="Filter_Method eq '0'">
                Only filter method 0 is defined in this International Standard.
            </sch:assert>
            <sch:assert test="Interlace_Method = ('0', '1')">
                Two interlace values are defined in this International Standard: 0 (no interlace) or 1 (Adam7 interlace).
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Table-11.1-IHDR-Allowed-Combinations-of-colour-type-and-bit-depth">
        <sch:rule context="IHDR[Color_Type eq '0']">
            <sch:assert test="xs:integer(Bit_Depth) = (1, 2, 4, 8, 16)">
                If color type = 0 then bit depth valid values are 1, 2, 4, 8, and 16.
            </sch:assert>
        </sch:rule>
        <sch:rule context="IHDR[Color_Type eq '2']">
            <sch:assert test="Bit_Depth = ('8', '16')">
                If color type = 2 then bit depth valid values are 8 and 16.
            </sch:assert>
        </sch:rule>
        <sch:rule context="IHDR[Color_Type eq '3']">
            <sch:assert test="Bit_Depth = ('1', '2', '4', '8')">
                If color type = 3 then bit depth valid values are 1, 2, 4, and 8.
            </sch:assert>
            <sch:assert test="following::PLTE">
                If color type = 3 then PLTE chunk must appear.
            </sch:assert>
        </sch:rule>
        <sch:rule context="IHDR[Color_Type eq '4']">
            <sch:assert test="Bit_Depth = ('8', '16')">
                If colour type = 4 then bit depth valid values are 8 and 16.
            </sch:assert>
        </sch:rule>
        <sch:rule context="IHDR[Color_Type eq '6']">
            <sch:assert test="Bit_Depth = ('8', '16')">
                If colour type = 6 then bit depth valid values are 8 and 16.
            </sch:assert>
        </sch:rule>
        <sch:rule context="IHDR[not(Color_Type = ('0', '2', '3', '4', '6'))]">
            <sch:assert test="false()">
                Color type valid values are 0, 2, 3, 4, and 6.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="Table-5.3-Chunk-Ordering-Rules">
        <sch:rule context="PNG">
            <sch:assert test="Chunk[1][IHDR]">
                IHDR shall be first.
            </sch:assert>
            <sch:assert test="Chunk[last()][IEND]">
                IEND shall be last.
            </sch:assert>
            <sch:assert test="not((Chunk/IHDR)[2])">
                One IHDR only.
            </sch:assert>
            <sch:assert test="not((Chunk/IEND)[2])">
                One IEND only.
            </sch:assert>
            <sch:assert test="not((Chunk/cHRM)[2])">
                One cHRM only.
            </sch:assert>
            <sch:assert test="not((Chunk/gAMA)[2])">
                One gAMA only.
            </sch:assert>
            <sch:assert test="not((Chunk/iCCP)[2])">
                One iCCP only.
            </sch:assert>
            <sch:assert test="not((Chunk/sBIT)[2])">
                One sBIT only.
            </sch:assert>
            <sch:assert test="not((Chunk/sRGB)[2])">
                One sRGB only.
            </sch:assert>
            <sch:assert test="not((Chunk/hIST)[2])">
                One hIST only.
            </sch:assert>
            <sch:assert test="not((Chunk/tRNS)[2])">
                One tRNS only.
            </sch:assert>
            <sch:assert test="not((Chunk/pHYs)[2])">
                One pHYs only.
            </sch:assert>
            <sch:assert test="not((Chunk/tIME)[2])">
                One tIME only.
            </sch:assert>
        </sch:rule>
        <!--
                Chunks which are horizontally aligned and appear between two other chunk types 
                (higher and lower than the horizontally aligned chunks) may appear in any order 
                between the two higher and lower chunk types to which they are connected. 
        -->
        <sch:rule context="Chunk[cHRM]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, sBIT, gAMA)]))">
                The only chunks that may follow cHRM are PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, sBIT, and gAMA.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[gAMA]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, sBIT, cHRM)]))">
                The only chunks that may follow gAMA are PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, sBIT, and cHRM.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[sBIT]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, gAMA, cHRM)]))">
                The only chunks that may follow sBIT are PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sRGB, gAMA, and cHRM.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[sRGB]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sBIT, gAMA, cHRM)]))">
                The only chunks that may follow sRGB are PLTE, tRNS, hIST, bKGD, IDAT, IEND, iCCP, sBIT, gAMA, and cHRM.
            </sch:assert>
            <sch:assert test="not(/PNG/Chunk/iCCP)">
                If the sRGB chunk is present, the iCCP chunk should not be present.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[iCCP]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(PLTE, tRNS, hIST, bKGD, IDAT, IEND, sRGB, sBIT, gAMA, cHRM)]))">
                The only chunks that may follow iCCP are PLTE, tRNS, hIST, bKGD, IDAT, IEND, sRGB, sBIT, gAMA, and cHRM.
            </sch:assert>
            <sch:assert test="not(/PNG/Chunk/sRGB)">
                If the iCCP chunk is present, the sRGB chunk should not be present.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[PLTE]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(tRNS, hIST, bKGD, IDAT, IEND)]))">
                The only chunks that may follow PLTE are tRNS, hIST, bKGD, IDAT, and IEND.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[bKGD]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND, tRNS, hIST)]))">
                The only chunks that may follow bKGD are IDAT, IEND, tRNS, and hIST.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[hIST]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND, tRNS, bKGD)]))">
                The only chunks that may follow hIST are IDAT, IEND, tRNS, and bKGD.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[tRNS]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND, hIST, bKGD)]))">
                The only chunks that may follow tRNS are IDAT, IEND, hIST, bKGD. 
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[pHYs]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND, tIME, zTXt, tEXt, iTXt, sPLT)]))">
                The only chunks that may follow pHYs are IDAT, IEND, tIME, zTXt, tEXt, iTXt, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[sPLT]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND, tIME, zTXt, tEXt, iTXt, pHYS, sPLT)]))">
                The only chunks that may follow sPLT are IDAT, IEND, tIME, zTXt, tEXt, iTXt, pHYS, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[tIME]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IEND, zTXt, tEXt, iTXt, pHYS, sPLT)]))">
                The only chunks that may follow tIME are IDAT, zTXt, tEXt, iTXt, pHYS, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[zTXt]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IEND, tIME, zTXt, tEXt, iTXt, pHYS, sPLT)]))">
                The only chunks that may follow zTXt are IDAT, tIME, zTXt, tEXt, iTXt, pHYS, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[tEXt]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IEND, tIME, zTXt, tEXt, iTXt, pHYS, sPLT)]))">
                The only chunks that may follow zTXt are IDAT, tIME, zTXt, tEXt, iTXt, pHYS, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[iTXt]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IEND, tIME, zTXt, tEXt, iTXt, pHYS, sPLT)]))">
                The only chunks that may follow iTXt are IDAT, tIME, zTXt, tEXt, iTXt, pHYS, and sPLT.
            </sch:assert>
        </sch:rule>
        <sch:rule context="Chunk[IDAT]">
            <sch:assert test="empty(following-sibling::* except(following-sibling::Chunk[(IDAT, IEND)]))">
                The only chunks that may follow IDAT are IDAT and IEND.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>