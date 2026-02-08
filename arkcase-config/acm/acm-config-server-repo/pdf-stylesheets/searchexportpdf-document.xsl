<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Search Report in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />
    <!-- ======================== -->
    <!-- root element: search report -->
    <!-- ======================== -->

	<!-- Trying this to wrap long words   -->

	<xsl:template match="text()">
		<xsl:call-template name="intersperse-with-zero-spaces">
			<xsl:with-param name="str" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="intersperse-with-zero-spaces">
		<xsl:param name="str"/>
		<xsl:variable name="spacechars">
			&#x9;&#xA;
			&#x2000;&#x2001;&#x2002;&#x2003;&#x2004;&#x2005;
			&#x2006;&#x2007;&#x2008;&#x2009;&#x200A;&#x200B;
		</xsl:variable>

		<xsl:if test="string-length($str) &gt; 0">
			<xsl:variable name="c1" select="substring($str, 1, 1)"/>
			<xsl:variable name="c2" select="substring($str, 2, 1)"/>

			<xsl:value-of select="$c1"/>
			<xsl:if test="$c2 != '' and
                    not(contains($spacechars, $c1) or
                    contains($spacechars, $c2))">
				<xsl:text>&#x200B;</xsl:text>
			</xsl:if>

			<xsl:call-template name="intersperse-with-zero-spaces">
				<xsl:with-param name="str" select="substring($str, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- long word wrap end  -->

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master
                    master-name="letter" page-height="11.0in"
                    page-width="8.5in" margin-top="0.17in"
                    margin-bottom="0.17in" margin-left="0.5in"
                    margin-right="0.5in">
                    <fo:region-body margin-top="0.5in"
                        margin-bottom="0.5in" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="letter">
                <!-- output data goes here -->
                <fo:flow flow-name="xsl-region-body" font-family="'Lucida Grande',Tahoma,Arial,sans-serif">
					<xsl:apply-templates select="searchresult"/>
					<fo:block font-size="10pt" space-after="0.15in">
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="10%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-body font-weight="normal" font-size="10pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Name</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Type</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Title</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Parent</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Assignee</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Modified</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<xsl:for-each select="searchresult/results">
									<xsl:for-each select="result">
										<fo:table-row line-height="12pt" font-size="9pt">
											<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="name"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="type"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="title"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="parent"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="assignee"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:apply-templates select="modified"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block> 
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>