<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Timesheet in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />
    <!-- ======================== -->
    <!-- root element: timesheet -->
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
					<xsl:apply-templates select="timesheet"/>
                    <fo:block font-size="16pt" text-align="center" font-weight="bold" space-after="0.25in">
                        Time Tracking
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        User
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="timesheet/user"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                       Status
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="timesheet/status"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                       Bureau
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="timesheet/bureau"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in" width="100%">
						<fo:inline font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="timesheet/periodWeek"/>
						</fo:inline>
						<fo:inline font-weight="bold"  border-color="#badeff" background-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							Prev Week
						</fo:inline>
						<fo:inline font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="timesheet/dateCreated"/>
						</fo:inline>
						<fo:inline font-weight="bold"  border-color="#badeff" background-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							Next Week
						</fo:inline>
                    </fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Times
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="10%"/>
							<fo:table-column column-width="15%"/>
							<fo:table-body font-weight="normal" font-size="10pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Type</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">AG#</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Billing Code</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Date</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Total</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="center">Total Cost</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<xsl:for-each select="timesheet/times">
									<xsl:for-each select="time">
										<fo:table-row line-height="12pt" font-size="10pt">
											<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="type"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="chargeCode"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="chargeRole"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="date"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="hours"/></fo:block>
											</fo:table-cell>
											<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
												<fo:block text-align="center"><xsl:value-of select="cost"/></fo:block>
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
							<fo:table-column column-width="10%"/>
							<fo:table-column column-width="15%"/>
							<fo:table-body font-weight="normal" font-size="10pt">
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block font-weight="bold" text-align="right">Total</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center"><xsl:value-of select="timesheet/totalHours"/></fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center"><xsl:value-of select="timesheet/totalCost"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block> 
					<fo:block font-size="10pt" space-after="0.15in">
						Details
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" padding="1mm">
							<xsl:value-of select="timesheet/details"/>
						</fo:block>
					</fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Approvers
						<xsl:for-each select="timesheet/participants">
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