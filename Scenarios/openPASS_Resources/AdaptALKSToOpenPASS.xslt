<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:set="http://exslt.org/sets" extension-element-prefixes="set">
<xsl:strip-space elements="*"/>
<xsl:output method="xml" indent="yes"/>

<!-- Entry point for adaptions of a scenario to openPASS -->
<xsl:template match="/">
	<OpenSCENARIO>
		<xsl:copy-of select="/OpenSCENARIO/FileHeader"/>
		<ParameterDeclarations>
			<xsl:apply-templates select="/OpenSCENARIO/ParameterDeclarations/ParameterDeclaration"/>
			<ParameterDeclaration name="OP_OSC_SchemaVersion" parameterType="string" value="0.4.0"/>
		</ParameterDeclarations>
		<CatalogLocations>
			<!-- openPASS expects catalogs in the "configs" directory -->
			<VehicleCatalog>
				<Directory path="VehicleCatalog.xosc"/>
			</VehicleCatalog>
			<PedestrianCatalog>
				<Directory path="PedestrianCatalog.xosc"/>
			</PedestrianCatalog>
			<TrajectoryCatalog>
				<Directory path=""/>
			</TrajectoryCatalog>
		</CatalogLocations>
		<xsl:copy-of select="/OpenSCENARIO/RoadNetwork"/>
		<Entities>
			<xsl:apply-templates select="/OpenSCENARIO/Entities"/>
		</Entities>
		<Storyboard>
			<Init>
				<xsl:apply-templates select="/OpenSCENARIO/Storyboard/Init"/>
			</Init>
			<xsl:for-each select="/OpenSCENARIO/Storyboard/Story">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
			<xsl:copy-of select="/OpenSCENARIO/Storyboard/StopTrigger"/>
		</Storyboard>
	</OpenSCENARIO>
</xsl:template>

<!-- Direct copy of selected tags -->
<xsl:template match="Act | ManeuverGroup |  Maneuver | Event | Action | PrivateAction | TeleportAction | LongitudinalAction | Position | LanePosition | LateralAction | LaneChangeAction | LaneChangeTarget | RelativeTargetLane | StartTrigger | ConditionGroup | Condition | Actors | EntityRef">
	<xsl:copy>
		<xsl:apply-templates select="@* | node()"/>
	</xsl:copy>
</xsl:template>

<!-- Direct copy of entire tags including subtags -->
<xsl:template match="ByValueCondition">
	<xsl:copy-of select="."/>
</xsl:template>

<!-- Copy all attributes -->
<xsl:template match="@*">
	<xsl:copy/>
</xsl:template>

<!-- Copy all ParameterDeclarations and apply conversion where necessary -->
<xsl:template match="ParameterDeclaration">
	<xsl:choose>
		<xsl:when test="@name = 'Ego_InitPosition_LaneId'">
			<!--openPASS expects laneId to be of type integer-->
			<xsl:copy>
				<xsl:attribute name="name">
					<xsl:value-of select="@name"/>
				</xsl:attribute>
				<xsl:attribute name="parameterType">
					<xsl:text>integer</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="@value"/>
				</xsl:attribute>
			</xsl:copy>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Adjust entities section and create an EntitySelection for all scenario agents -->
<xsl:template match="Entities">
	<xsl:for-each select="ScenarioObject">
		<ScenarioObject>
			<xsl:attribute name="name">
				<xsl:value-of select="@name"/>
			</xsl:attribute>
			<xsl:for-each select="CatalogReference">
				<CatalogReference>
					<xsl:attribute name="catalogName">
						<xsl:text>ProfilesCatalog.xml</xsl:text>
					</xsl:attribute> <!--All entities are defined in the ProfilesCatalog.xml in openPASS-->
					<xsl:attribute name="entryName">
						<xsl:value-of select="@entryName"/>
					</xsl:attribute>
					<!--The concept of controllers is not used in openPASS. Instead these defintions are done in the ProfilesCatalog.xml-->
				</CatalogReference>
			</xsl:for-each>
		</ScenarioObject>
	</xsl:for-each>
	<EntitySelection>
		<xsl:attribute name="name">
			<xsl:text>ScenarioAgents</xsl:text>
		</xsl:attribute>
		<Members>
			<xsl:for-each select="ScenarioObject">
				<xsl:if test="@name!='Ego'">
					<EntityRef>
						<xsl:attribute name="entityRef">
							<xsl:value-of select="@name"/>
						</xsl:attribute>
					</EntityRef>
				</xsl:if>
			</xsl:for-each>
		</Members>			
	</EntitySelection>
</xsl:template>

<!-- Copy and convert Init section -->
<xsl:template match="Init">
	<Actions>
		<xsl:for-each select="Actions/Private">
			<Private>
				<xsl:attribute name="entityRef">
					<xsl:value-of select="@entityRef"/>
				</xsl:attribute>
				<xsl:apply-templates select="*"/>
				<!-- Add a default LongitudinalAction with target speed 0 if non is existing -->				
				<xsl:if test="not(PrivateAction/LongitudinalAction)">						
					<PrivateAction>
						<LongitudinalAction>
							<SpeedAction>
								<SpeedActionDynamics dynamicsShape="linear" value="0.0" dynamicsDimension="rate"/>
								<SpeedActionTarget>
									<AbsoluteTargetSpeed value="0.0"/>
								</SpeedActionTarget>
							  </SpeedAction>
						</LongitudinalAction>
					</PrivateAction>
				</xsl:if>		
			</Private>
		</xsl:for-each>
	</Actions>
</xsl:template>

<!-- Copy and adapt SpeedAction -->
<xsl:template match="SpeedAction">
	<SpeedAction>
		<SpeedActionDynamics>
			<!-- openPASS specifics. Shape and dimension do not have an influence during the init step -->
			<xsl:attribute name="dynamicsShape">
				<xsl:text>linear</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="dynamicsDimension">
				<xsl:text>rate</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="value">
				<xsl:value-of select="SpeedActionDynamics/@value"/>
			</xsl:attribute>
		</SpeedActionDynamics>
		<xsl:choose>
			<xsl:when test="SpeedActionTarget/AbsoluteTargetSpeed">
				<xsl:copy-of select="SpeedActionTarget"/>
			</xsl:when>
			<xsl:when test="SpeedActionTarget/RelativeTargetSpeed">
				<!--Relative Target speed is transformed to absolute. Always assumes type delta -->
				<xsl:variable name="entityRef" select="SpeedActionTarget/RelativeTargetSpeed/@entityRef"/>
				<xsl:variable name="value" select="SpeedActionTarget/RelativeTargetSpeed/@value"/>
				<xsl:variable name="entityRefSpeedParameter" select="/OpenSCENARIO/Storyboard/Init/Actions/Private[@entityRef = 'Ego']/PrivateAction/LongitudinalAction/SpeedAction/SpeedActionTarget/AbsoluteTargetSpeed/@value"/>
				<xsl:variable name="entityRefSpeed">
					<xsl:choose>
						<!-- Read value from ParameterDeclarations -->
						<xsl:when test="string(number( $entityRefSpeedParameter )) = 'NaN'">
							<xsl:variable name="entityRefSpeedParamName">
								<xsl:value-of select="substring($entityRefSpeedParameter,2)"/>
							</xsl:variable>
							<xsl:value-of select="/OpenSCENARIO/ParameterDeclarations/ParameterDeclaration[@name = $entityRefSpeedParamName]/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value + $entityRefSpeedParameter"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<SpeedActionTarget>
					<AbsoluteTargetSpeed>
						<xsl:attribute name="value">
							<xsl:value-of select="$entityRefSpeed"/>
						</xsl:attribute>
					</AbsoluteTargetSpeed>
				</SpeedActionTarget>
			</xsl:when>
		</xsl:choose>
	</SpeedAction>
</xsl:template> 

<!-- Add type relative to the orientation tag. Warning: value remains unchanged! -->
<xsl:template match="Orientation">
	<xsl:copy>
		<xsl:attribute name="type">
			<xsl:text>relative</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="h">
			<xsl:value-of select="@h"/>
		</xsl:attribute>
	</xsl:copy>	
</xsl:template>

<!-- Copy all stories and drop the story for controller activation -->
<xsl:template match="Story">
	<xsl:choose>
		<xsl:when test="Act/ManeuverGroup/Maneuver/Event/Action/PrivateAction/ActivateControllerAction">
			<!--Drop the Controller activation story, as there is no controller in openPASS-->
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy>
				<xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Copy LaneChangeActionDynamics and convert dynamicsDimension to time -->
<xsl:template match="LaneChangeActionDynamics">
	<xsl:variable name="lateralSpeedParameter">
		<xsl:value-of select="@value"/>
	</xsl:variable>
	<xsl:variable name="lateralSpeed">
		<xsl:choose>
			<!-- Read value from ParameterDeclarations -->
			<xsl:when test="string(number( $lateralSpeedParameter )) = 'NaN'">
				<xsl:variable name="lateralSpeedParameterName">
					<xsl:value-of select="substring($lateralSpeedParameter,2)"/>
				</xsl:variable>
				<xsl:value-of select="/OpenSCENARIO/ParameterDeclarations/ParameterDeclaration[@name = $lateralSpeedParameterName]/@value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$lateralSpeedParameter"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:copy>
		<xsl:attribute name="value">
			<!-- Lane width is hardcoded to 3.5 meters -->
			<!-- Annaeherung der Sinusoidal lane change duration unter Annahme konstanter Querbeschleunigung -->
			<xsl:value-of select="2 * 2 * 3.5 div 2 div $lateralSpeed"/>
		</xsl:attribute>
		<xsl:attribute name="dynamicsDimension">
			<xsl:text>time</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="dynamicsShape">
			<xsl:value-of select="@dynamicsShape"/>
		</xsl:attribute>
	</xsl:copy>	
</xsl:template>

<!-- Copy ByEntityCondition and convert RelativeDistanceCondition to TimeHeadwayCondition -->
<xsl:template match="ByEntityCondition">
	<xsl:choose>
		<xsl:when test="EntityCondition/RelativeDistanceCondition">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:copy-of select="TriggeringEntities"/>
				<EntityCondition>
					<xsl:choose>
						<xsl:when test="EntityCondition/RelativeDistanceCondition">
							<!--Convert to TimeHeadway Condition-->
							<TimeHeadwayCondition>
								<xsl:attribute name="freespace">
									<xsl:value-of select="EntityCondition/RelativeDistanceCondition/@freespace"/>
								</xsl:attribute>
								<xsl:attribute name="entityRef">
									<xsl:value-of select="EntityCondition/RelativeDistanceCondition/@entityRef"/>
								</xsl:attribute>
								<xsl:attribute name="rule">
									<xsl:value-of select="EntityCondition/RelativeDistanceCondition/@rule"/>
								</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:variable name="relativeDistanceParameter">
										<xsl:value-of select="EntityCondition/RelativeDistanceCondition/@value"/>
									</xsl:variable>
									<xsl:variable name="relativeDistance">
										<xsl:choose>
											<!-- Read value from ParameterDeclarations -->
											<xsl:when test="string(number( $relativeDistanceParameter )) = 'NaN'">
												<xsl:variable name="relativeDistanceParameterName">
													<xsl:value-of select="substring($relativeDistanceParameter,2)"/>
												</xsl:variable>
												<xsl:value-of select="/OpenSCENARIO/ParameterDeclarations/ParameterDeclaration[@name = $relativeDistanceParameterName]/@value"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$relativeDistanceParameter"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- Velocity difference is hardcoded to Ego velocity, as the scenarios only use the condition towards standing objects -->
									<xsl:value-of select="$relativeDistance div 16.66667"/>
								</xsl:attribute>
								<xsl:attribute name="alongRoute">
									<xsl:text>true</xsl:text>
								</xsl:attribute>
							</TimeHeadwayCondition>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="EntityCondition/."/>
						</xsl:otherwise>
					</xsl:choose>
				</EntityCondition>
			</xsl:copy>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
