<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Costsheet in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />
    <!-- ======================== -->
    <!-- root element: costsheet -->
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
					<xsl:apply-templates select="costsheet"/>
                    <fo:block font-size="16pt" text-align="center" font-weight="bold" space-after="0.25in">
                        Expenses
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        User
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="costsheet/user"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                       Status
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="costsheet/status"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Type
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="costsheet/type"/></fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Code
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="costsheet/code"/></fo:block>
                    </fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Costs
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="35%"/>
							<fo:table-column column-width="25%"/>
							<fo:table-body font-weight="normal" font-size="10pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Date</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Title</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Description</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Amount</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<xsl:for-each select="costsheet/costs">
									<xsl:for-each select="cost">
										<fo:table-row line-height="12pt" font-size="10pt">
											<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="date"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="title"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="description"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="amount"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:for-each>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block> 
					<fo:block font-size="11pt" space-after="0.15in">
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-column column-width="75%"/>
							<fo:table-column column-width="25%"/>
							<fo:table-body font-weight="normal" font-size="10pt">
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="right">Balance</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center"><xsl:value-of select="costsheet/balance"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block> 
					<fo:block font-size="10pt" space-after="0.15in">
						Details
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" padding="1mm">
							<xsl:value-of select="costsheet/details"/>
						</fo:block>
					</fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Approvers
						<xsl:for-each select="costsheet/participants">
							<xsl:for-each select="participant">
								<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
									<xsl:value-of select="participantName"/>
								</fo:block>
							</xsl:for-each>
						</xsl:for-each>
					</fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>