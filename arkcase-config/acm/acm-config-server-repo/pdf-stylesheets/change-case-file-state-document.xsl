<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Request in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />

   
    <!-- ======================== -->
    <!-- root element: complaint -->
    <!-- ======================== -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master
                    master-name="letter" page-height="11.0in"
                    page-width="8.5in" margin-top="0.17in"
                    margin-bottom="0.17in" margin-left="1.0in"
                    margin-right="1.0in">
                    <fo:region-body margin-top="0.5in"
                        margin-bottom="0.5in" />
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="letter">
                <!-- output data goes here -->
                <fo:flow flow-name="xsl-region-body" font-family="'Lucida Grande',Tahoma,Arial,sans-serif">
					<xsl:apply-templates select="changeCaseFileState"/>
					<fo:block text-align="center" font-weight="bold" font-size="12pt" space-after="0.15in">
                        Change Case Status Information
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Change Date
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/changeDate"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Case Number
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/caseNumber"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Status
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/status"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Case Resolution
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/caseResolution"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Approver						
					<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="changeCaseFileState/participant"/>
						</fo:block>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>
