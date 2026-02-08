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
					<xsl:apply-templates select="closeComplaint"/>
                    <fo:block font-size="16pt" text-align="center" font-weight="bold" space-after="0.25in">
                        Close Complaint
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Complaint Close Date
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="closeComplaint/closeDate"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Complaint Number
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="closeComplaint/complaintNumber"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Complaint Disposition
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="closeComplaint/complaintDisposition"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Refer External
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-body font-weight="normal" font-size="12pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Name of Agency</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Referral Date</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Contact Name</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/referExternalNameOfAgency"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/referExternalDate"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/referExternalContactName"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
						    </fo:table-body>
						</fo:table>
						Contact
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-body font-weight="normal" font-size="12pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Type</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Value</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/referExternalContactType"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/referExternalContactValue"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
						    </fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						Add Existing Case
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-body font-weight="normal" font-size="12pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Enter case number</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center"></fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/existingCaseNumber"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/existingCaseSearchBtn"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
						    </fo:table-body>
						</fo:table>
						<fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							<fo:table-body font-weight="normal" font-size="12pt">
								<fo:table-row line-height="12pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Case Title</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Case Creation Date</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
											<fo:block text-align="center">Case Priority</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row line-height="12pt" font-size="10pt">
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/existingCaseTitle"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/existingCaseCreated"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
										<fo:block text-align="center">
											<xsl:value-of select="closeComplaint/existingCasePriority"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
						    </fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
						  <fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							  <fo:table-body font-weight="normal" font-size="12pt">
								  <fo:table-row line-height="12pt">
									   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
			                                <fo:block text-align="center">Select Approver</fo:block>
		                               </fo:table-cell>
								   </fo:table-row>
								  <xsl:for-each select="closeComplaint/participants">
									  <xsl:for-each select="participant">
										   <fo:table-row line-height="12pt" font-size="10pt">
											   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
					                               <fo:block text-align="center"><xsl:value-of select="participantName"/></fo:block>
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
