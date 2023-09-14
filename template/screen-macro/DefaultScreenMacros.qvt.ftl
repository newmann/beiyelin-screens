<#--
This software is in the public domain under CC0 1.0 Universal plus a
Grant of Patent License.

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide. This software is distributed without any
warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software (see the LICENSE.md file). If not, see
<http://creativecommons.org/publicdomain/zero/1.0/>.
-->
<#-- NOTE: no empty lines before the first #macro otherwise FTL outputs empty lines -->
<#include "runtime://template/screen-macro/DefaultScreenMacros.qvt.ftl"/>

<#--暂时不需要了
    <#macro fieldTitlePlus fieldSubNode><#t>

        <#t><#if (fieldSubNode?node_name == 'header-field')>
            <#local fieldNode = fieldSubNode?parent>
            <#local headerFieldNode = fieldNode["header-field"][0]!>
            <#local defaultFieldNode = fieldNode["default-field"][0]!>
            <#t><#if headerFieldNode["@title"]?has_content>
                    <#local fieldSubNode = headerFieldNode>
                <#elseif defaultFieldNode["@title"]?has_content>
                    <#local fieldSubNode = defaultFieldNode>
                </#if>
        </#if>
        <#t><#assign titleValue><#if fieldSubNode["@title"]?has_content>${ec.getResource().expand(fieldSubNode["@title"], "")}
                                <#else><#list fieldSubNode?parent["@name"]?split("(?=[A-Z])", "r") as nameWord>${nameWord?cap_first?replace("Id", "ID")}<#if nameWord_has_next> </#if></#list>
                                </#if>
            </#assign>

        <#assign validationClasses = formInstance.getFieldValidationClasses(fieldSubNode)>
        <#if validationClasses?contains("required")>(*)</#if>${ec.getL10n().localize(titleValue)}

    </#macro>
-->
<#--
1、去掉outlined
-->
<#macro linkFormLink linkNode linkFormId linkText urlInstance>
    <#assign iconClass = linkNode["@icon"]!>
    <#if !iconClass?has_content && linkNode["@text"]?has_content><#assign iconClass = sri.getThemeIconClass(linkNode["@text"])!></#if>
    <#assign iconClass = ec.getResource().expandNoL10n(iconClass!, "")/>
    <#assign badgeMessage = ec.getResource().expand(linkNode["@badge"]!, "")/>

    <#assign labelWrapper = linkNode["@link-type"]! == "anchor" && linkNode?ancestors("form-single")?has_content>
    <#if labelWrapper>
        <#assign fieldLabel><@fieldTitle linkNode?parent/></#assign>
        <q-field dense readonly<#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if>><template v-slot:control>
    </#if>

    <#if urlInstance.disableLink>
        <span>
            <q-btn dense no-caps disabled <#if linkNode["@link-type"]! != "anchor" && linkNode["@link-type"]! != "hidden-form-link">outline<#else>flat</#if><#rt>
                    <#t> class="m-link<#if .node["@style"]?has_content> ${ec.getResource().expandNoL10n(.node["@style"], "")}</#if>"
                    <#t><#if linkFormId?has_content> id="${linkFormId}"</#if><#if linkText?has_content> label="${linkText}"</#if>>
                <#if iconClass?has_content><i class="${iconClass}"></i></#if><#if linkNode["image"]?has_content><#visit linkNode["image"][0]></#if>
            </q-btn>
            <#t><#if linkNode["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(linkNode["@tooltip"], "")}</q-tooltip></#if>
        </span>
    <#else>
        <#assign confirmationMessage = ec.getResource().expand(linkNode["@confirmation"]!, "")/>
        <#if sri.isAnchorLink(linkNode, urlInstance)>
            <#assign linkNoParam = linkNode["@url-noparam"]! == "true">
            <#if urlInstance.isScreenUrl()><#assign linkElement = "m-link">
                <#if linkNoParam><#assign urlText = urlInstance.path/><#else><#assign urlText = urlInstance.pathWithParams/></#if>
            <#else><#assign linkElement = "a">
                <#if linkNoParam><#assign urlText = urlInstance.url/><#else><#assign urlText = urlInstance.urlWithParams/></#if>
            </#if>
            <#-- TODO: consider simplifying to use q-btn with 'to' attribute instead of m-link or for anchor type="a" + href, where we want a button (not @link-type=anchor) -->
            <${linkElement} href="${urlText}"<#if linkFormId?has_content> id="${linkFormId}"</#if><#rt>
                <#t><#if linkNode["@target-window"]?has_content> target="${linkNode["@target-window"]}"</#if>
                <#t><#if linkNode["@dynamic-load-id"]?has_content> load-id="${linkNode["@dynamic-load-id"]}"</#if>
                <#t><#if confirmationMessage?has_content><#if linkElement == "m-link"> :confirmation="'${confirmationMessage?js_string}'"<#else> onclick="return confirm('${confirmationMessage?js_string}')"</#if></#if>
                <#-- TODO non q-btn approach might simulate styles like old stuff, initial attempt failed though: <#if linkNode["@link-type"]! != "anchor">btn btn-${linkNode["@btn-type"]!"primary"} btn-sm</#if> -->
                <#if linkNode["@link-type"]! != "anchor">
                    <#t>>
                    <q-btn dense outline no-caps color="<@getQuasarColor linkNode["@btn-type"]!"primary"/>"<#rt>
                        <#t> class="m-link<#if linkNode["@style"]?has_content> ${ec.getResource().expandNoL10n(linkNode["@style"], "")}</#if>">
                <#else>
                    <#t> class="<#if linkNode["@style"]?has_content> ${ec.getResource().expandNoL10n(linkNode["@style"], "")}</#if>">
                </#if>
                <#t><#if linkNode["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(linkNode["@tooltip"], "")}</q-tooltip></#if>
                <#t><#if iconClass?has_content><i class="${iconClass} q-icon<#if linkText?? && linkText?trim?has_content> on-left</#if>"></i> </#if><#rt>
                <#t><#if linkNode["image"]?has_content><#visit linkNode["image"][0]><#else>${linkText}</#if>
                <#t><#if badgeMessage?has_content> <q-badge class="on-right" transparent>${badgeMessage}</q-badge></#if>
                <#if linkNode["@link-type"]! != "anchor"></q-btn></#if>
            <#t></${linkElement}>
        <#else>
            <#if linkFormId?has_content>
            <#rt><q-btn dense outline no-caps type="submit" form="${linkFormId}" id="${linkFormId}_button" color="<@getQuasarColor linkNode["@btn-type"]!"primary"/>"
                    <#t> class="<#if linkNode["@style"]?has_content>${ec.getResource().expandNoL10n(linkNode["@style"], "")}</#if>"
                    <#t><#if confirmationMessage?has_content> onclick="return confirm('${confirmationMessage?js_string}')"</#if>>
                    <#t><#if linkNode["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(linkNode["@tooltip"], "")}</q-tooltip></#if>
                <#t><#if iconClass?has_content><i class="${iconClass} q-icon<#if linkText?? && linkText?trim?has_content> on-left</#if>"></i> </#if>
                <#if linkNode["image"]?has_content>
                    <#t><img src="${sri.makeUrlByType(imageNode["@url"],imageNode["@url-type"]!"content",null,"true")}"<#if imageNode["@alt"]?has_content> alt="${imageNode["@alt"]}"</#if>/>
                <#else>
                    <#t>${linkText}
                </#if>
                <#t><#if badgeMessage?has_content> <q-badge class="on-right" transparent>${badgeMessage}</q-badge></#if>
            <#t></q-btn>
            </#if>
        </#if>
    </#if>

    <#if labelWrapper>
        </template></q-field>
    </#if>
</#macro>



<#-- =========================================================== -->
<#-- ======================= Form List ========================= -->
<#-- =========================================================== -->
<#--
1、去掉outlined
-->
<#macro paginationHeader formListInfo formId isHeaderDialog>
    <#assign formNode = formListInfo.getFormNode()>
    <#assign listName = formNode["@list"]>
    <#assign allColInfoList = formListInfo.getAllColInfo()>
    <#assign mainColInfoList = formListInfo.getMainColInfo()>
    <#assign numColumns = (mainColInfoList?size)!100>
    <#if numColumns == 0><#assign numColumns = 100></#if>
    <#if isRowSelection!false><#assign numColumns = numColumns + 1></#if>
    <#assign isSavedFinds = formNode["@saved-finds"]! == "true">
    <#assign isSelectColumns = formNode["@select-columns"]! == "true">
    <#assign isPaginated = (!(formNode["@paginate"]! == "false") && context[listName + "Count"]?? && (context[listName + "Count"]! > 0) &&
            (!formNode["@paginate-always-show"]?has_content || formNode["@paginate-always-show"]! == "true" || (context[listName + "PageMaxIndex"] > 0)))>
    <#assign currentFindUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageIndex").removeParameter("moquiFormName").removeParameter("moquiSessionToken").removeParameter("lastStandalone").removeParameter("formListFindId")>
    <#assign currentFindUrlParms = currentFindUrl.getParameterMap()>
    <#assign hiddenParameterMap = sri.getFormHiddenParameters(formNode)>
    <#assign hiddenParameterKeys = hiddenParameterMap.keySet()>
    <#assign userDefaultFormListFindId = formListInfo.getUserDefaultFormListFindId(ec)!"">
    <#assign origFormDisabled = formDisabled!false>
    <#assign formDisabled = false>
    <#if isHeaderDialog>
        <#assign haveFilters = false>
        <#assign curFindSummary>
            <#list formNode["field"] as fieldNode><#if fieldNode["header-field"]?has_content && fieldNode["header-field"][0]?children?has_content>
                <#assign headerFieldNode = fieldNode["header-field"][0]>
                <#assign allHidden = true>
                <#list fieldNode?children as fieldSubNode>
                    <#if !(fieldSubNode["hidden"]?has_content || fieldSubNode["ignored"]?has_content)><#assign allHidden = false></#if>
                </#list>
                <#if !(ec.getResource().condition(fieldNode["@hide"]!, "") || allHidden ||
                        ((!fieldNode["@hide"]?has_content) && fieldNode?children?size == 1 &&
                         (headerFieldNode["hidden"]?has_content || headerFieldNode["ignored"]?has_content)))>
                    <#t>${sri.pushContext()}
                    <#list headerFieldNode?children as widgetNode><#if widgetNode?node_name == "set">${sri.setInContext(widgetNode)}</#if></#list>
                    <#list headerFieldNode?children as widgetNode><#if widgetNode?node_name != "set">
                        <#assign fieldValue><@widgetTextValue widgetNode/></#assign>
                        <#if fieldValue?has_content>
                            <span style="white-space:nowrap;"><strong><@fieldTitle headerFieldNode/>:</strong> <span class="text-success">${fieldValue}</span></span>
                            <#assign haveFilters = true>
                        </#if>
                    </#if></#list>
                    <#t>${sri.popContext()}
                </#if>
            </#if></#list>
        </#assign>
    </#if>
    <#if (isHeaderDialog || isSavedFinds || isSelectColumns || isPaginated) && hideNav! != "true">
        <tr class="form-list-nav-row"><th colspan="${numColumns}"><div class="row">
            <div class="col-xs-12 col-sm-6"><div class="row">
            <#if isSavedFinds>
                <#assign userFindInfoList = formListInfo.getUserFormListFinds(ec)>
                <#if userFindInfoList?has_content>
                    <#assign activeUserFindName = ""/>
                    <#if ec.getContext().formListFindId?has_content>
                        <#list userFindInfoList as userFindInfo>
                            <#if userFindInfo.formListFind.formListFindId == ec.getContext().formListFindId>
                                <#assign activeUserFindName = userFindInfo.description/></#if></#list>
                    </#if>
                    <q-btn-dropdown dense outline no-caps label="<#if activeUserFindName?has_content>${activeUserFindName?html}<#else>${ec.getL10n().localize("Select Find")}</#if>" color="<#if activeUserFindName?has_content>info</#if>"><q-list dense>
                        <q-item clickable v-close-popup><q-item-section>
                            <m-link href="${sri.buildUrl(sri.getScreenUrlInstance().path).addParameter("formListFindId", "_clear").pathWithParams}">${ec.getL10n().localize("Clear Current Find")}</m-link>
                        </q-item-section></q-item>
                        <#list userFindInfoList as userFindInfo>
                            <#assign formListFind = userFindInfo.formListFind>
                            <#assign findParameters = userFindInfo.findParameters>
                            <#-- use only formListFindId now that ScreenRenderImpl picks it up and auto adds configured parameters:
                            <#assign doFindUrl = sri.buildUrl(sri.getScreenUrlInstance().path).addParameters(findParameters)> -->
                            <#assign doFindUrl = sri.buildUrl(sri.getScreenUrlInstance().path).addParameter("formListFindId", formListFind.formListFindId)>
                            <q-item clickable v-close-popup><q-item-section>
                                <m-link href="${doFindUrl.pathWithParams}">${userFindInfo.description?html}</m-link>
                            </q-item-section></q-item>
                        </#list>
                    </q-list></q-btn-dropdown>
                </#if>
            </#if>
            <#if isHeaderDialog>
                <#assign headerFormId = formId + "_header">
                <#assign headerFormButtonText = ec.getL10n().localize("Find Options")>
                <m-container-dialog id="${formId + "_hdialog"}" title="${headerFormButtonText}">
                    <template v-slot:button><q-btn dense outline no-caps label="${headerFormButtonText}" icon="search"></q-btn></template>
                    <#-- Find Parameters Form -->
                    <#assign curUrlInstance = sri.getCurrentScreenUrl()>
                    <#assign skipFormSave = skipForm!false>
                    <#assign skipForm = false>
                    <#assign fieldsJsName = "formProps.fields">
                    <#assign orderByOptions>
                        <#list formNode["field"] as fieldNode><#if fieldNode["header-field"]?has_content>
                            <#assign headerFieldNode = fieldNode["header-field"][0]>
                            <#assign showOrderBy = (headerFieldNode["@show-order-by"])!>
                            <#if showOrderBy?has_content && showOrderBy != "false">
                                <#assign caseInsensitive = showOrderBy == "case-insensitive">
                                <#assign orderFieldName = fieldNode["@name"]>
                                <#assign orderFieldTitle><@fieldTitle headerFieldNode/></#assign>
                                <#t>{value:'${caseInsensitive?string("^", "") + orderFieldName}',label:'${orderFieldTitle} ${ec.getL10n().localize("(Asc)")}'},
                                <#t>{value:'${"-" + caseInsensitive?string("^", "") + orderFieldName}',label:'${orderFieldTitle} ${ec.getL10n().localize("(Desc)")}'},
                            </#if>
                        </#if></#list>
                    </#assign>
                    <m-form-link name="${headerFormId}" id="${headerFormId}" action="${curUrlInstance.path}" v-slot:default="formProps"<#rt>
                            <#t> :fields-initial="${Static["org.moqui.util.WebUtilities"].fieldValuesEncodeHtmlJsSafe(sri.getFormListHeaderValues(formNode))}">
                        <div class="q-mx-sm">
                            <q-btn dense outline no-caps name="clearParameters" @click.prevent="formProps.clearForm" label="${ec.getL10n().localize("Clear Parameters")}"></q-btn>

                            <#-- Always add an orderByField to select one or more columns to order by -->
                            <q-select dense  options-dense multiple clearable emit-value map-options v-model="formProps.fields.orderByField"
                                    name="orderByField" id="${headerFormId}_orderByField" stack-label label="${ec.getL10n().localize("Order By")}"
                                    :options="[${orderByOptions}]"></q-select>
                        </div>

                        <#t>${sri.pushSingleFormMapContext("")}
                        <#list formNode["field"] as fieldNode><#if fieldNode["header-field"]?has_content && fieldNode["header-field"][0]?children?has_content>
                            <#assign headerFieldNode = fieldNode["header-field"][0]>
                            <#assign allHidden = true>
                            <#list fieldNode?children as fieldSubNode>
                                <#if !(fieldSubNode["hidden"]?has_content || fieldSubNode["ignored"]?has_content)><#assign allHidden = false></#if>
                            </#list>

                            <#if !(ec.getResource().condition(fieldNode["@hide"]!, "") || allHidden ||
                                    ((!fieldNode["@hide"]?has_content) && fieldNode?children?size == 1 &&
                                    (headerFieldNode["hidden"]?has_content || headerFieldNode["ignored"]?has_content)))>
                                <@formSingleWidget headerFieldNode headerFormId "col-sm" false false/>
                            <#elseif (headerFieldNode["hidden"])?has_content>
                                <#recurse headerFieldNode/>
                            </#if>
                        </#if></#list>
                        <#t>${sri.popContext()}<#-- context was pushed so pop here at the end -->
                    </m-form-link>
                    <#assign skipForm = skipFormSave>
                    <#-- TODO: anything needed for per-row or multi forms? -->
                    <#assign fieldsJsName = "">
                </m-container-dialog>
            </#if>

            <#if isSelectColumns>
                <#assign selectColumnsDialogId = formId + "_SelColsDialog">
                <#assign selectColumnsSortableId = formId + "_SelColsSortable">
                <#assign fieldsNotInColumns = formListInfo.getFieldsNotReferencedInFormListColumn()>
                <#assign hiddenChildren>
                    <#list fieldsNotInColumns as fieldNode>
                        <#assign fieldSubNode = (fieldNode["header-field"][0])!(fieldNode["default-field"][0])!>
                        <#assign curFieldTitle><@fieldTitle fieldSubNode/></#assign>
                        <#t>{id:'${fieldNode["@name"]}',label:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(curFieldTitle)}'}
                    <#sep>,</#list>
                </#assign>
                <#assign columnFieldInfo>
                    <#list allColInfoList as columnFieldList>
                        <#t>{id:'column_${columnFieldList_index}',label:'${ec.l10n.localize("Column")} ${columnFieldList_index + 1}',children:[
                        <#list columnFieldList as fieldNode>
                            <#assign fieldSubNode = (fieldNode["header-field"][0])!(fieldNode["default-field"][0])!>
                            <#assign curFieldTitle><@fieldTitle fieldSubNode/></#assign>
                            <#t>{id:'${fieldNode["@name"]}',label:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(curFieldTitle)}'}
                        <#sep>,</#list>
                        <#t>]}
                    <#sep>,</#list>
                </#assign>
                <m-container-dialog id="${selectColumnsDialogId}" title="${ec.l10n.localize("Column Fields")}">
                    <template v-slot:button><q-btn dense outline no-caps label="${ec.getL10n().localize("Columns")}" icon="table_chart"></q-btn></template>
                    <m-form-column-config id="${formId}_SelColsForm" action="${sri.buildUrl("formSelectColumns").path}"
                        <#if currentFindUrlParms?has_content> :find-parameters="{<#list currentFindUrlParms.keySet() as parmName>'${parmName}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentFindUrlParms.get(parmName)!)}'<#sep>,</#list>}"</#if>
                        :columns-initial="[{id:'hidden', label:'${ec.l10n.localize("Do Not Display")}', children:[${hiddenChildren}]},${columnFieldInfo}]"
                        form-location="${formListInfo.getFormLocation()}">
                    </m-form-column-config>
                </m-container-dialog>
            </#if>

            <#if isSavedFinds>
                <#assign savedFormButtonText = ec.getL10n().localize("Saved Finds")>
                <m-container-dialog id="${formId + "_sfdialog"}" title="${savedFormButtonText}">
                    <template v-slot:button><q-btn dense outline no-caps label="${savedFormButtonText}" icon="find_in_page"></q-btn></template>
                    <#assign activeFormListFind = formListInfo.getFormInstance().getActiveFormListFind(ec)!>
                    <#assign formSaveFindUrl = sri.buildUrl("formSaveFind").path>
                    <#assign descLabel = ec.getL10n().localize("Description")>

                    <#if activeFormListFind?has_content>
                        <#assign screenScheduled = formListInfo.getScreenForm().getFormListFindScreenScheduled(activeFormListFind.formListFindId, ec)!>
                        <div><strong>${ec.getL10n().localize("Active Saved Find:")}</strong> ${activeFormListFind.description?html}
                            <#if userDefaultFormListFindId == activeFormListFind.formListFindId><span class="text-info">(${ec.getL10n().localize("My Default")})</span></#if></div>
                        <#if screenScheduled?has_content>
                            <p>(Scheduled for <#if screenScheduled.renderMode! == 'xsl-fo'>PDF<#else>${screenScheduled.renderMode!?upper_case}</#if><#rt>
                                <#t> ${Static["org.moqui.impl.service.ScheduledJobRunner"].getCronDescription(screenScheduled.cronExpression, ec.user.getLocale(), true)!})</p>
                        <#else>
                            <m-form class="form-inline" id="${formId}_SCHED" action="${formSaveFindUrl}" v-slot:default="formProps"
                                    :fields-initial="{formListFindId:'${activeFormListFind.formListFindId}', screenPath:'${sri.getScreenUrlInstance().path}', renderMode:'', cronSelected:''}">
                                <m-drop-down v-model="formProps.fields.renderMode" name="renderMode" label="${ec.getL10n().localize("Mode")}" id="${formId}_SCHED_renderMode"
                                             :options="[{value:'xlsx',label:'XLSX'},{value:'csv',label:'CSV'},{value:'xsl-fo',label:'PDF'}]"></m-drop-down>
                                <m-drop-down v-model="formProps.fields.cronSelected" name="cronSelected" label="${ec.getL10n().localize("Schedule")}" id="${formId}_SCHED_cronSelected"
                                             :options="[{value:'0 0 6 ? * MON-FRI',label:'Monday-Friday'},{value:'0 0 6 ? * *',label:'Every Day'},{value:'0 0 6 ? * MON',label:'Monday Only'},{value:'0 0 6 1 * ?',label:'Monthly'}]"></m-drop-down>
                                <q-btn dense outline no-caps type="submit" name="ScheduleFind" onclick="return confirm('${ec.getL10n().localize("Setup a schedule to send this saved find to you by email?")}');" label="${ec.getL10n().localize("Schedule")}"></q-btn>
                            </m-form>
                        </#if>
                    </#if>
                    <#if currentFindUrlParms?has_content>
                        <#if activeFormListFind?has_content><hr></#if>
                        <p>${curFindSummary!""}</p>

                        <m-form class="form-inline" id="${formId}_NewFind" action="${formSaveFindUrl}" v-slot:default="formProps"
                                :fields-initial="{formLocation:'${formListInfo.getSavedFindFullLocation()}',_findDescription:'',<#rt>
                        <#t><#list currentFindUrlParms.keySet() as parmName>'${parmName}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentFindUrlParms.get(parmName)!)}',</#list>}">
                            <div class="big-row">
                                <div class="q-my-auto big-row-item"><q-input v-model="formProps.fields._findDescription" dense  stack-label label="${descLabel}" size="30" name="_findDescription" id="${formId}_NewFind_description" required="required"></q-input></div>
                                <div class="on-right q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" label="${ec.getL10n().localize("Save New Find")}"></q-btn></div>
                            </div>
                        </m-form>
                    <#else>
                        <div style="margin:12px 0;"><strong>${ec.getL10n().localize("No find parameters (or default), choose some in Find Options to save a new find or update existing")}</strong></div>
                    </#if>
                    <#assign userFindInfoList = formListInfo.getUserFormListFinds(ec)>
                    <#list userFindInfoList as userFindInfo>
                        <#assign formListFind = userFindInfo.formListFind>
                        <#assign findParameters = userFindInfo.findParameters>
                        <#-- use only formListFindId now that ScreenRenderImpl picks it up and auto adds configured parameters:
                        <#assign doFindUrl = sri.buildUrl(sri.getScreenUrlInstance().path).addParameters(findParameters)> -->
                        <#assign doFindUrl = sri.buildUrl(sri.getScreenUrlInstance().path).addParameter("formListFindId", formListFind.formListFindId)>
                        <#assign saveFindFormId = formId + "_SaveFind" + userFindInfo_index>
                        <#if currentFindUrlParms?has_content>
                            <div class="big-row">
                                <m-form id="${saveFindFormId}" name="${saveFindFormId}" action="${formSaveFindUrl}" v-slot:default="formProps"
                                        :fields-initial="{formLocation:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(formListInfo.getSavedFindFullLocation())}', formListFindId:'${formListFind.formListFindId}',<#rt>
                                            <#t>_findDescription:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(formListFind.description?html)}',
                                            <#t><#list currentFindUrlParms.keySet() as parmName>'${parmName}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentFindUrlParms.get(parmName)!)}',</#list>}">
                                    <div class="q-my-auto big-row-item"><q-input v-model="formProps.fields._findDescription" dense  stack-label label="${descLabel}" size="30" name="_findDescription" id="${saveFindFormId}_description" required="required"></q-input></div>
                                    <div class="on-right q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" name="UpdateFind" label="${ec.getL10n().localize("Update")}">
                                            <q-tooltip>Update saved find using description and current find parameters</q-tooltip>
                                        </q-btn></div>
                                    <#if userFindInfo.isByUserId == "true">
                                        <div class="q-my-auto big-row-item"><q-btn dense flat no-caps type="submit" name="DeleteFind" color="negative" icon="delete_forever" onclick="return confirm('${ec.getL10n().localize("Delete")} ${formListFind.description?js_string}?');"></q-btn></div>
                                    </#if>
                                    <div class="q-my-auto big-row-item"><q-btn dense outline no-caps to="${doFindUrl.pathWithParams}" label="${ec.getL10n().localize("Do Find")}"></q-btn></div>
                                    <#if userDefaultFormListFindId == formListFind.formListFindId>
                                        <div class="q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" name="ClearDefault" color="info" label="${ec.getL10n().localize("Clear Default")}"></q-btn></div>
                                    <#else>
                                        <div class="q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" name="MakeDefault" label="${ec.getL10n().localize("Make Default")}"></q-btn></div>
                                    </#if>
                                </m-form>
                            </div>
                        <#else>
                            <div class="big-row">
                                <div class="q-my-auto big-row-item on-left"><q-input dense  readonly value="${formListFind.description?html}"></q-input></div>
                                <div class="q-my-auto big-row-item"><q-btn dense outline no-caps to="${doFindUrl.pathWithParams}" label="${ec.getL10n().localize("Do Find")}"></q-btn></div>
                                <m-form id="${saveFindFormId}" action="${formSaveFindUrl}" :no-validate="true"
                                        :fields-initial="{formListFindId:'${formListFind.formListFindId}', formLocation:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(formListInfo.getSavedFindFullLocation())}'}">
                                    <#if userFindInfo.isByUserId == "true">
                                        <div class="q-my-auto big-row-item"><q-btn dense flat no-caps type="submit" name="DeleteFind" color="negative" icon="delete_forever"
                                                onclick="return confirm('${ec.getL10n().localize("Delete")} ${formListFind.description?js_string}?');"></q-btn></div>
                                    </#if>
                                    <#if userDefaultFormListFindId == formListFind.formListFindId>
                                        <div class="q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" name="ClearDefault" color="info" label="${ec.getL10n().localize("Clear Default")}"></q-btn></div>
                                    <#else>
                                        <div class="q-my-auto big-row-item"><q-btn dense outline no-caps type="submit" name="MakeDefault" label="${ec.getL10n().localize("Make Default")}"></q-btn></div>
                                    </#if>
                                </m-form>
                            </div>
                        </#if>
                    </#list>
                </m-container-dialog>
            </#if>

            <#if formNode["@show-csv-button"]! == "true">
                <#assign csvLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("renderMode", "csv")
                        .addParameter("pageNoLimit", "true").addParameter("lastStandalone", "true").addParameter("saveFilename", formNode["@name"] + ".csv")>
                <q-btn dense outline type="a" href="${csvLinkUrl.getUrlWithParams()}" label="${ec.getL10n().localize("CSV")}"></q-btn>
            </#if>
            <#if formNode["@show-xlsx-button"]! == "true" && ec.screen.isRenderModeValid("xlsx")>
                <#assign xlsxLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("renderMode", "xlsx")
                        .addParameter("pageNoLimit", "true").addParameter("lastStandalone", "true").addParameter("saveFilename", formNode["@name"] + ".xlsx")>
                <q-btn dense outline type="a" href="${xlsxLinkUrl.getUrlWithParams()}" label="${ec.getL10n().localize("XLS")}"></q-btn>
            </#if>
            <#if formNode["@show-text-button"]! == "true">
                <#assign showTextDialogId = formId + "_TextDialog">
                <#assign textLinkUrl = sri.getScreenUrlInstance()>
                <#assign textLinkUrlParms = textLinkUrl.getParameterMap()>
                <m-container-dialog id="${showTextDialogId}" button-text="${ec.getL10n().localize("Text")}" title="${ec.getL10n().localize("Export Fixed-Width Plain Text")}">
                    <#-- NOTE: don't use m-form, most commonly results in download and if not won't be html -->
                    <form id="${formId}_Text" method="post" action="${textLinkUrl.getUrl()}">
                        <input type="hidden" name="renderMode" value="text">
                        <input type="hidden" name="pageNoLimit" value="true">
                        <input type="hidden" name="lastStandalone" value="true">
                        <#list textLinkUrlParms.keySet() as parmName>
                            <input type="hidden" name="${parmName}" value="${textLinkUrlParms.get(parmName)!?html}"></#list>
                        <#-- TODO quasar components and layout, lower priority (not commonly used) -->
                        <fieldset class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Text_lineCharacters">${ec.getL10n().localize("Line Characters")}</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" size="4" name="lineCharacters" id="${formId}_Text_lineCharacters" value="132">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Text_pageLines">${ec.getL10n().localize("Page Lines")}</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" size="4" name="pageLines" id="${formId}_Text_pageLines" value="88">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Text_lineWrap">${ec.getL10n().localize("Line Wrap?")}</label>
                                <div class="col-sm-9">
                                    <input type="checkbox" class="form-control" name="lineWrap" id="${formId}_Text_lineWrap" value="true">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Text_saveFilename">${ec.getL10n().localize("Save to Filename")}</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" size="40" name="saveFilename" id="${formId}_Text_saveFilename" value="${formNode["@name"] + ".txt"}">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-default">${ec.getL10n().localize("Export Text")}</button>
                        </fieldset>
                    </form>
                </m-container-dialog>
            </#if>
            <#if formNode["@show-pdf-button"]! == "true">
                <#assign showPdfDialogId = formId + "_PdfDialog">
                <#assign pdfLinkUrl = sri.getScreenUrlInstance()>
                <#assign pdfLinkUrlParms = pdfLinkUrl.getParameterMap()>
                <m-container-dialog id="${showPdfDialogId}" button-text="${ec.getL10n().localize("PDF")}" title="${ec.getL10n().localize("Generate PDF")}">
                    <#-- NOTE: don't use m-form, most commonly results in download and if not won't be html -->
                    <form id="${formId}_Pdf" method="post" action="${ec.web.getWebappRootUrl(false, null)}/fop${pdfLinkUrl.getPath()}">
                        <input type="hidden" name="pageNoLimit" value="true">
                        <#list pdfLinkUrlParms.keySet() as parmName>
                            <input type="hidden" name="${parmName}" value="${pdfLinkUrlParms.get(parmName)!?html}"></#list>
                        <#-- TODO quasar components and layout, lower priority (not commonly used) -->
                        <fieldset class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Pdf_layoutMaster">${ec.getL10n().localize("Page Layout")}</label>
                                <div class="col-sm-9">
                                    <select name="layoutMaster"  id="${formId}_Pdf_layoutMaster" class="form-control">
                                        <option value="letter-landscape">US Letter - Landscape (11x8.5)</option>
                                        <option value="letter-portrait">US Letter - Portrait (8.5x11)</option>
                                        <option value="legal-landscape">US Legal - Landscape (14x8.5)</option>
                                        <option value="legal-portrait">US Legal - Portrait (8.5x14)</option>
                                        <option value="tabloid-landscape">US Tabloid - Landscape (17x11)</option>
                                        <option value="tabloid-portrait">US Tabloid - Portrait (11x17)</option>
                                        <option value="a4-landscape">A4 - Landscape (297x210)</option>
                                        <option value="a4-portrait">A4 - Portrait (210x297)</option>
                                        <option value="a3-landscape">A3 - Landscape (420x297)</option>
                                        <option value="a3-portrait">A3 - Portrait (297x420)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3" for="${formId}_Pdf_saveFilename">${ec.getL10n().localize("Save to Filename")}</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" size="40" name="saveFilename" id="${formId}_Pdf_saveFilename" value="${formNode["@name"] + ".pdf"}">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-default">${ec.getL10n().localize("Generate PDF")}</button>
                        </fieldset>
                    </form>
                </m-container-dialog>
            </#if>

            <#if (context[listName + "Count"]!(context[listName].size())!0) == 0>
                <#if context.getSharedMap().get("_entityListNoSearchParms")!false == true>
                    <strong class="text-warning on-right q-my-auto">${ec.getL10n().localize("Find Options required to view results")}</strong>
                <#else>
                    <strong class="text-warning on-right q-my-auto">${ec.getL10n().localize("No results found")}</strong>
                </#if>
            </#if>
            </div></div>

            <#if isPaginated>
            <div class="col-xs-12 col-sm-6"><div class="row">
                <q-space></q-space>
                <#-- no more paginate/show-all button, use page size drop-down with 500 instead:
                <#if formNode["@show-all-button"]! == "true" && (context[listName + 'Count'] < 500)>
                    <#if context["pageNoLimit"]?has_content>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageNoLimit")>
                        <m-link href="${allLinkUrl.pathWithParams}" class="btn btn-default">${ec.getL10n().localize("Paginate")}</m-link>
                    <#else>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageNoLimit", "true")>
                        <m-link href="${allLinkUrl.pathWithParams}" class="btn btn-default">${ec.getL10n().localize("Show All")}</m-link>
                    </#if>
                </#if>
                -->
                <#if formNode["@show-all-button"]! == "true" || formNode["@show-page-size"]! == "true">
                    <span class="on-left q-my-auto"><q-btn-dropdown dense outline no-caps label="${context[listName + "PageSize"]?c}"><q-list dense>
                        <#list [10,20,50,100,200,500] as curPageSize>
                            <#assign pageSizeUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageSize", curPageSize?c)>
                            <q-item clickable v-close-popup><q-item-section>
                                <m-link href="${pageSizeUrl.pathWithParams}">${curPageSize?c}</m-link>
                            </q-item-section></q-item>
                        </#list>
                    </q-list></q-btn-dropdown></span>
                </#if>

                <#assign curPageMaxIndex = context[listName + "PageMaxIndex"]>
                <#if (curPageMaxIndex > 4)><m-form-go-page id-val="${formId}" :max-index="${curPageMaxIndex?c}"></m-form-go-page></#if>
                <m-form-paginate :paginate="{ count:${context[listName + "Count"]?c}, pageIndex:${context[listName + "PageIndex"]?c},<#rt>
                    <#t> pageSize:${context[listName + "PageSize"]?c}, pageMaxIndex:${context[listName + "PageMaxIndex"]?c},
                    <#lt> pageRangeLow:${context[listName + "PageRangeLow"]?c}, pageRangeHigh:${context[listName + "PageRangeHigh"]?c} }"></m-form-paginate>
            </div></div>
            </#if>
        </div></th></tr>

        <#if isHeaderDialog>
        <tr><th colspan="${numColumns}" style="font-weight: normal">
            ${curFindSummary!""}
            <#if haveFilters>
                <#assign hiddenParameterMap = sri.getFormHiddenParameters(formNode)>
                <#assign hiddenParameterKeys = hiddenParameterMap.keySet()>
                <#assign curUrlInstance = sri.getCurrentScreenUrl()>
                <m-form-link name="${headerFormId}_clr" id="${headerFormId}_clr" action="${curUrlInstance.path}"
                         :fields-initial="{<#list hiddenParameterKeys as hiddenParameterKey>'${hiddenParameterKey}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(hiddenParameterMap.get(hiddenParameterKey)!)}'<#sep>,</#list>}">
                    <q-btn dense flat type="submit" icon="clear" color="negative">
                        <q-tooltip>Reset to Default</q-tooltip></q-btn>
                </m-form-link>
            </#if>
        </th></tr>
        </#if>
    </#if>
    <#assign formDisabled = origFormDisabled>
</#macro>

<#-- ========================================================== -->
<#-- ================== Form Field Widgets ==================== -->
<#-- ========================================================== -->
<#--
1、在label上增加必填提示
2、去掉outlined
    <#if useWrapper>
    <q-field dense  stack-label label-slot <#if containerStyle?has_content> class="${containerStyle}"</#if><#if formDisabled!false> disable</#if>>
        <#if .node?parent["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node?parent["@tooltip"], "")}</q-tooltip></#if>
        <template v-slot:control>
    </#if>
            <#list (options.keySet())! as key>
                <q-checkbox size="xs" val="${key?html}" label="${(options.get(key)!"")?html}" name="${curName}" id="${tlId}<#if (key_index > 0)>_${key_index}</#if>"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#lt><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curName}"<#else> value="${key?html}"<#if allChecked! == "true"> checked="checked"<#elseif currentValue?has_content && (currentValue==key || currentValue.contains(key))> checked="checked"</#if></#if>></q-checkbox>
            </#list>
    <#if useWrapper>
        </template>
        <template v-slot:label>
            <div> <#if fieldLabel?has_content>${fieldLabel}</#if>
                <#if validationClasses?contains("required")><em class="text-red"> * </em></#if>
            </div>
        </template>
    </q-field>
    </#if>

-->

<#macro check>
    <#assign tlSubFieldNode = .node?parent>
    <#assign tlFieldNode = tlSubFieldNode?parent>
    <#assign options = sri.getFieldOptions(.node)>
    <#assign currentValue = sri.getFieldValueString(.node)>
    <#if !currentValue?has_content><#assign currentValue = ec.getResource().expandNoL10n(.node["@no-current-selected-key"]!, "")/></#if>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign containerStyle = ec.getResource().expandNoL10n(.node["@container-style"]!, "")>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <#assign useWrapper = (.node["@no-wrapper"]!"false") != "true">
    <#assign validationClasses = formInstance.getFieldValidationClasses(tlSubFieldNode)>

        <m-option-group dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> id="${tlId}" type="checkbox"<#rt>
                <#t>  <#if containerStyle?has_content> class="${containerStyle}"</#if>
                <#t> name="${name}"
                <#t> <#if fieldsJsName?has_content>v-model="${fieldsJsName}.${name}" :fields="${fieldsJsName}"<#else>
                    <#t> <#if currentValue?html == currentValue>value="${currentValue}"<#else>:value="'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentValue)}'"</#if>
                <#t> </#if>
                <#t><#if formDisabled! || ec.getResource().condition(.node.@disabled!"false", "")> disable</#if>
                <#t><#if validationClasses?contains("required")> required</#if>
                <#t>:options="[<#list (options.keySet())! as key>{value:'<#if key?has_content>${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(key)}</#if>',label:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(options.get(key)!)}'}<#sep>,</#list>]"
                <#lt><#if ownerForm?has_content> form="${ownerForm}"</#if>
                <#t> <#if tlSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(tlSubFieldNode["@tooltip"], "")?html}"</#if>>
        </m-option-group>
</#macro>

<#--
1、增加q-chip显示类型
-->
<#macro display>
    <#assign dispFieldId><@fieldId .node/></#assign>
    <#assign dispFieldName><@fieldName .node/></#assign>
    <#assign dispSubFieldNode = .node?parent>
    <#assign dispFieldNode = dispSubFieldNode?parent>
    <#assign dispFormNode = dispFieldNode?parent>
    <#assign dispAlign = dispFieldNode["@align"]!"left">
    <#assign dispHidden = (!.node["@also-hidden"]?has_content || .node["@also-hidden"] == "true") && !(skipForm!false)>
    <#assign dispDynamic = .node["@dynamic-transition"]?has_content>
    <#assign labelWrapper = dispFormNode?node_name == "form-single">
    <#assign fieldLabel><@fieldTitle dispSubFieldNode/></#assign>
    <#assign fieldValue = "">
    <#if fieldsJsName?has_content>
        <#assign format = .node["@format"]!>
        <#assign dispFieldNameDisplay><@fieldName .node "_display"/></#assign>
        <#-- TODO: format is a Vue filter, applied with {{ ... | format }}, how to format only ${fieldsJsName}.${dispFieldName} and not ${fieldsJsName}.${dispFieldNameDisplay} ??? for now no format -->
        <#assign fieldValue>{{${fieldsJsName}.${dispFieldNameDisplay} || ${fieldsJsName}.${dispFieldName}}}</#assign>
    <#else>
        <#if .node["@text"]?has_content>
            <#assign textMap = "">
            <#if .node["@text-map"]?has_content><#assign textMap = ec.getResource().expression(.node["@text-map"], "")!></#if>
            <#if textMap?has_content><#assign fieldValue = ec.getResource().expand(.node["@text"], "", textMap)>
                <#else><#assign fieldValue = ec.getResource().expand(.node["@text"], "")></#if>
            <#if .node["@currency-unit-field"]?has_content>
                <#assign fieldValue = ec.getL10n().formatCurrency(fieldValue, ec.getResource().expression(.node["@currency-unit-field"], ""))></#if>
        <#elseif .node["@currency-unit-field"]?has_content>
            <#assign fieldValue = ec.getL10n().formatCurrency(sri.getFieldValue(dispFieldNode, ""), ec.getResource().expression(.node["@currency-unit-field"], ""))>
        <#else>
            <#assign fieldValue = sri.getFieldValueString(.node)>
        </#if>
        <#if dispDynamic && !fieldValue?has_content><#assign fieldValue><@widgetTextValue .node true/></#assign></#if>
    </#if>

    <#if dispDynamic>
        <#assign defUrlInfo = sri.makeUrlByType(.node["@dynamic-transition"], "transition", .node, "false")>
        <#assign defUrlParameterMap = defUrlInfo.getParameterMap()>
        <#assign depNodeList = .node["depends-on"]>
    </#if>

    <m-display name="${dispFieldName}" id="${dispFieldId}_display"<#if fieldLabel?has_content> label="${fieldLabel}"</#if><#if labelWrapper> label-wrapper</#if><#rt>
            <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${dispFieldName}" :display="${fieldsJsName}.${dispFieldNameDisplay}" :fields="${fieldsJsName}"
                <#t><#elseif labelWrapper && fieldValue?has_content> display="<#if .node["@encode"]! == "false">${fieldValue}<#else>${fieldValue?html}</#if>"</#if>
            <#t><#if dispSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(dispSubFieldNode["@tooltip"], "")}"</#if>
            <#if dispDynamic> value-url="${defUrlInfo.url}" <#if .node["@depends-optional"]! == "true"> :depends-optional="true"</#if>
                <#t> :depends-on="{<#list depNodeList as depNode><#local depNodeField = depNode["@field"]>'${depNode["@parameter"]!depNodeField}':'${depNodeField}'<#sep>, </#list>}"
                <#t> :value-parameters="{<#list defUrlParameterMap.keySet() as parameterKey><#if defUrlParameterMap.get(parameterKey)?has_content>'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(parameterKey)}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(defUrlParameterMap.get(parameterKey))}', </#if></#list>}"
            <#t></#if>
            <#t><#if .node["@display-type"]?has_content> displayType = "${ec.getResource().expand(.node["@display-type"], "")}"</#if>
            class="${sri.getFieldValueClass(dispFieldNode)}<#if .node["@currency-unit-field"]?has_content> currency</#if><#if dispAlign == "center"> text-center<#elseif dispAlign == "right"> text-right</#if><#if .node["@style"]?has_content> ${ec.getResource().expandNoL10n(.node["@style"], "")}</#if>">
        <#if !labelWrapper && fieldValue?has_content && (!fieldsJsName?has_content)>
            <template v-slot:default><#if .node["@encode"]! == "false">${fieldValue}<#else>${fieldValue?html?replace("\n", "<br>")}</#if></template>
        </#if>
    </m-display>

    <#if dispHidden && !fieldsJsName?has_content>
        <#if dispDynamic>
            <#assign hiddenValue><@widgetTextValue .node true "value"/></#assign>
            <input type="hidden" id="${dispFieldId}" name="${dispFieldName}" value="${hiddenValue}"<#if ownerForm?has_content> form="${ownerForm}"</#if>>
        <#else>
            <#-- use getFieldValuePlainString() and not getFieldValueString() so we don't do timezone conversions, etc -->
            <#-- don't default to fieldValue for the hidden input value, will only be different from the entry value if @text is used, and we don't want that in the hidden value -->
            <input type="hidden" id="${dispFieldId}" name="${dispFieldName}" <#if fieldsJsName?has_content>:value="${fieldsJsName}.${dispFieldName}"<#else>value="${sri.getFieldValuePlainString(dispFieldNode, "")?html}"</#if><#if ownerForm?has_content> form="${ownerForm}"</#if>>
        </#if>
    </#if>
</#macro>

<#--
1、去掉outlined
2、直接换上m-display
-->
<#macro "display-entity">
    <#assign dispFieldId><@fieldId .node/></#assign>
    <#assign dispFieldName><@fieldName .node/></#assign>
    <#assign dispSubFieldNode = .node?parent>
    <#assign dispFieldNode = dispSubFieldNode?parent>
    <#assign dispFormNode = dispFieldNode?parent>
    <#assign dispAlign = dispFieldNode["@align"]!"left">
    <#assign dispHidden = (!.node["@also-hidden"]?has_content || .node["@also-hidden"] == "true") && !(skipForm!false)>
    <#assign labelWrapper = dispFormNode?node_name == "form-single">
    <#assign fieldLabel><@fieldTitle dispSubFieldNode/></#assign>
    <#if fieldsJsName?has_content>
        <#assign dispFieldNameDisplay><@fieldName .node "_display"/></#assign>
        <#assign fieldValue>{{(${fieldsJsName}.${dispFieldNameDisplay} || ${fieldsJsName}.${dispFieldName})}}</#assign>
    <#else>
        <#assign fieldValue = sri.getFieldEntityValue(.node)!/>
    </#if>

    <m-display name="${dispFieldName}" id="${dispFieldId}_display"<#if fieldLabel?has_content> label="${fieldLabel}"</#if><#if labelWrapper> label-wrapper</#if><#rt>
            <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${dispFieldName}" :display="${fieldsJsName}.${dispFieldNameDisplay}" :fields="${fieldsJsName}" </#if>
            <#t><#if !fieldsJsName?has_content && fieldValue?has_content> display="<#if .node["@encode"]! == "false">${fieldValue}<#else>${fieldValue?html?replace("\n", "<br>")}</#if>"</#if>
            <#t><#if dispSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(dispSubFieldNode["@tooltip"], "")}"</#if>
            <#t><#if .node["@display-type"]?has_content> displayType = "${ec.getResource().expand(.node["@display-type"], "")}"</#if>
            class="${sri.getFieldValueClass(dispFieldNode)}<#if .node["@currency-unit-field"]?has_content> currency</#if><#if dispAlign == "center"> text-center<#elseif dispAlign == "right"> text-right</#if><#if .node["@style"]?has_content> ${ec.getResource().expandNoL10n(.node["@style"], "")}</#if>">
    </m-display>


    <#-- don't default to fieldValue for the hidden input value, will only be different from the entry value if @text is used, and we don't want that in the hidden value -->
    <#t><#if dispHidden && !fieldsJsName?has_content><input type="hidden" id="<@fieldId .node/>" name="<@fieldName .node/>" value="${sri.getFieldValuePlainString(.node?parent?parent, "")?html}"<#if ownerForm?has_content> form="${ownerForm}"</#if>></#if>
</#macro>
<#--
1、增加moquiKey
-->
<#macro "drop-down">
    <#assign ddSubFieldNode = .node?parent>
    <#assign ddFieldNode = ddSubFieldNode?parent>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign allowMultiple = ec.getResource().expandNoL10n(.node["@allow-multiple"]!, "") == "true">
    <#assign allowEmpty = ec.getResource().expandNoL10n(.node["@allow-empty"]!, "") == "true">
    <#assign isDynamicOptions = .node["dynamic-options"]?has_content>
    <#assign name><@fieldName .node/></#assign>
    <#assign namePlain = ddFieldNode["@name"]>
    <#assign options = sri.getFieldOptions(.node)>
    <#assign currentValue = sri.getFieldValuePlainString(ddFieldNode, "")>
    <#if !currentValue?has_content && .node["@no-current-selected-key"]?has_content>
        <#assign currentValue = ec.getResource().expandNoL10n(.node["@no-current-selected-key"], "")></#if>
    <#if currentValue?starts_with("[")><#assign currentValue = currentValue?substring(1, currentValue?length - 1)?replace(" ", "")></#if>
    <#assign currentValueList = (currentValue?split(","))!>
    <#if currentValueList?has_content><#if allowMultiple><#assign currentValue=""><#else><#assign currentValue = currentValueList[0]></#if></#if>
    <#if !allowMultiple && !allowEmpty && !currentValue?has_content && options?has_content><#assign currentValue = options.keySet()?first></#if>
    <#-- for server-side dynamic options/etc if no currentValue get first in options and set in context so fields rendering after this have it available -->
    <#if currentValue?has_content && !ec.context.get(namePlain)?has_content && _formMap?exists && !_formMap.get(namePlain)?has_content>
        <#assign _void = _formMap.put(ddFieldNode["@name"], currentValue)!></#if>
    <#assign currentDescription = (options.get(currentValue))!>
    <#assign validationClasses = formInstance.getFieldValidationClasses(ddSubFieldNode)>
    <#assign optionsHasCurrent = currentDescription?has_content>
    <#if !optionsHasCurrent && .node["@current-description"]?has_content>
        <#assign currentDescription = ec.getResource().expand(.node["@current-description"], "")></#if>
    <#if isDynamicOptions>
        <#assign doNode = .node["dynamic-options"][0]>
        <#assign depNodeList = doNode["depends-on"]>
        <#assign doUrlInfo = sri.makeUrlByType(doNode["@transition"], "transition", doNode, "false")>
        <#assign doUrlParameterMap = doUrlInfo.getParameterMap()>
        <#if currentValue?has_content && !currentDescription?has_content><#assign currentDescription><@widgetTextValue .node true/></#assign></#if>
    </#if>
    <#assign fieldLabel><@fieldTitle ddSubFieldNode/></#assign>
    <#assign moquiKey = ddSubFieldNode["@moqui-key"]!>

    <m-drop-down name="${name}" id="${tlId}"<#if fieldLabel?has_content> label="${fieldLabel}"</#if><#if formDisabled!> disable</#if><#rt>
            <#t> class="<#if isDynamicOptions>dynamic-options</#if><#if .node["@style"]?has_content> ${ec.getResource().expandNoL10n(.node["@style"], "")}</#if><#if validationClasses?has_content> ${validationClasses}</#if>"<#rt>
            <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${name}" :fields="${fieldsJsName}"<#else><#if allowMultiple> :value="[<#list currentValueList as curVal><#if curVal?has_content>'${curVal}',</#if></#list>]"<#else> value="${currentValue!}"</#if></#if>
            <#t><#if allowMultiple> :multiple="true"</#if><#if allowEmpty> :allow-empty="true"</#if><#if .node["@combo-box"]! == "true"> :combo="true"</#if>
            <#t><#if .node["@required-manual-select"]! == "true"> :required-manual-select="true"</#if>
            <#t><#if .node["@submit-on-select"]! == "true"> :submit-on-select="true"</#if>
            <#t><#if .node?parent["@tooltip"]?has_content> tooltip="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>
            <#t><#if ownerForm?has_content> form="${ownerForm}"</#if><#if .node["@size"]?has_content> size="${.node["@size"]}"</#if>
            <#if isDynamicOptions> options-url="${doUrlInfo.url}" value-field="${doNode["@value-field"]!"value"}" label-field="${doNode["@label-field"]!"label"}"<#if doNode["@depends-optional"]! == "true"> :depends-optional="true"</#if>
                <#t> :depends-on="{<#list depNodeList as depNode><#local depNodeField = depNode["@field"]>'${depNode["@parameter"]!depNodeField}':'${depNodeField}'<#sep>, </#list>}"
                <#t> :options-parameters="{<#list doUrlParameterMap.keySet() as parameterKey><#if doUrlParameterMap.get(parameterKey)?has_content>'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(parameterKey)}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(doUrlParameterMap.get(parameterKey))}', </#if></#list>}"
                <#t><#if doNode["@server-search"]! == "true"> :server-search="true"</#if><#if doNode["@delay"]?has_content> :server-delay="${doNode["@delay"]}"</#if>
                <#t><#if doNode["@min-length"]?has_content> :server-min-length="${doNode["@min-length"]}"</#if>
                <#t><#if (.node?children?size > 1)> :options-load-init="true"</#if>
            </#if>
                :options="[<#if currentValue?has_content && !allowMultiple && !optionsHasCurrent>{value:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentValue)}',label:'<#if currentDescription?has_content>${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentDescription!)}<#else>${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentValue)}</#if>'},</#if><#rt>
                    <#t><#list (options.keySet())! as key>{value:'<#if key?has_content>${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(key)}</#if>',label:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(options.get(key)!)}'}<#sep>,</#list>]"
            <#lt>
            <#lt><#if moquiKey?has_content>moquiKey = "${moquiKey}"</#if>
            >
            <#-- support <#if .node["@current"]! == "first-in-list"> again? -->
            <#if ec.getResource().expandNoL10n(.node["@show-not"]!, "") == "true">
            <template v-slot:after>
                <q-checkbox size="xs" name="${name}_not" label="${ec.getL10n().localize("Not")}"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#t><#if fieldsJsName?has_content> true-value="Y" false-value="N" v-model="${fieldsJsName}.${name}_not"<#else> value="Y"<#if ec.getWeb().parameters.get(name + "_not")! == "Y"> checked="checked"</#if></#if>></q-checkbox>
            </template>
            </#if>
    </m-drop-down>
</#macro>

<#--
1、去掉outlined
-->
<#macro file>
    <#assign curFieldName><@fieldName .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <#assign acceptText = ec.getResource().expand(.node.@accept, "")>
    <q-file dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}"</#if><#if formDisabled!> disable</#if>
            name="<@fieldName .node/>" size="${.node.@size!"30"}"<#if .node.@multiple! == "true"> multiple</#if><#if .node.@accept?has_content> accept="${acceptText}"</#if><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if><#if ownerForm?has_content> form="${ownerForm}"</#if>>
        <#if .node?parent["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node?parent["@tooltip"], "")}</q-tooltip></#if>
    </q-file>
</#macro>

<#--
1、去掉outlined
-->
<#macro password>
    <#assign validationClasses = formInstance.getFieldValidationClasses(.node?parent)>
    <#assign curFieldName><@fieldName .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <q-input dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> type="password" name="${curFieldName}" id="<@fieldId .node/>"<#if formDisabled!> disable</#if><#rt>
            <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}"</#if>
            <#t> class="form-control<#if validationClasses?has_content> ${validationClasses}</#if>" size="${.node.@size!"25"}"
            <#t><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
            <#t><#if validationClasses?contains("required")> required</#if><#if ownerForm?has_content> form="${ownerForm}"</#if>>
        <#if .node?parent["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node?parent["@tooltip"], "")}</q-tooltip></#if>
    </q-input>
</#macro>

<#--
1、在label上增加必填提示
2、去掉outlined
    <q-field dense  stack-label label-slot <#if formDisabled!> disable</#if>>
        <#if .node?parent["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node?parent["@tooltip"], "")}</q-tooltip></#if>
        <template v-slot:control>
        <#list (options.keySet())! as key>
            <q-radio size="xs" val="${key?html}" label="${(options.get(key)!"")?html}" name="${curName}" id="${tlId}<#if (key_index > 0)>_${key_index}</#if>"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                <#lt><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curName}"<#else> value="${key?html}"<#if currentValue?has_content && currentValue==key> checked="checked"</#if></#if>></q-radio>
        </#list>
        </template>
        <template v-slot:label>
            <div> <#if fieldLabel?has_content>${fieldLabel}</#if>
                <#if validationClasses?contains("required")><em class="text-red"> * </em></#if>
            </div>
        </template>
    </q-field>

-->
<#macro radio>
    <#assign tlSubFieldNode = .node?parent>
    <#assign tlFieldNode = tlSubFieldNode?parent>
    <#assign options = sri.getFieldOptions(.node)/>
    <#assign currentValue = sri.getFieldValueString(.node)/>
    <#if !currentValue?has_content><#assign currentValue = ec.getResource().expandNoL10n(.node["@no-current-selected-key"]!, "")/></#if>
    <#assign containerStyle = ec.getResource().expandNoL10n(.node["@container-style"]!, "")>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>

    <#assign validationClasses = formInstance.getFieldValidationClasses(tlSubFieldNode)>

    <m-option-group dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> id="${tlId}" type="radio"<#rt>
            <#t>  <#if containerStyle?has_content> class="${containerStyle}"</#if>
            <#t> name="${name}"
            <#t> <#if fieldsJsName?has_content>v-model="${fieldsJsName}.${name}" :fields="${fieldsJsName}"<#else>
                <#t> <#if currentValue?html == currentValue>value="${currentValue}"<#else>:value="'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(currentValue)}'"</#if>
            <#t> </#if>
            <#t><#if formDisabled! || ec.getResource().condition(.node.@disabled!"false", "")> disable</#if>
            <#t><#if validationClasses?contains("required")> required</#if>
            <#t><#if validationRules?has_content || .node.@rules?has_content>
                <#t> :rules="[<#if .node.@rules?has_content>${.node.@rules},</#if><#list validationRules! as valRule>value => ${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.expr)}||'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.message)}'<#sep>,</#list>]"
            <#t></#if>
            <#t>:options="[<#list (options.keySet())! as key>{value:'<#if key?has_content>${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(key)}</#if>',label:'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(options.get(key)!)}'}<#sep>,</#list>]"
            <#lt><#if ownerForm?has_content> form="${ownerForm}"</#if>
            <#t> <#if tlSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(tlSubFieldNode["@tooltip"], "")?html}"</#if>>
    </m-option-group>
</#macro>

<#--
1、去掉outlined
-->
<#macro "range-find">
    <#assign curFieldName><@fieldName .node/></#assign>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <#assign curTooltip = ec.getResource().expand(.node?parent["@tooltip"]!, "")>
    <div class="row">
        <q-input dense  stack-label label="${fieldLabel} ${ec.getL10n().localize('From')}" name="${curFieldName}_from" id="${tlId}_from"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                <#t> size="${.node.@size!"10"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
                <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}_from"<#else> value="${ec.getContext().get(curFieldName + "_from")!?default(.node["@default-value-from"]!"")?html}"</#if>>
            <#if curTooltip?has_content><q-tooltip>${curTooltip}</q-tooltip></#if>
        </q-input>
        <q-input class="q-pl-xs" dense  stack-label label="${fieldLabel} ${ec.getL10n().localize('Thru')}" name="${curFieldName}_thru" id="${tlId}_thru"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                <#t> size="${.node.@size!"10"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
                <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}_thru"<#else> value="${ec.getContext().get(curFieldName + "_thru")!?default(.node["@default-value-thru"]!"")?html}"</#if>>
            <#if curTooltip?has_content><q-tooltip>${curTooltip}</q-tooltip></#if>
        </q-input>
    </div>
</#macro>

<#--
    1、用q-editor替代q-input
    2、但在import.xml中存在问题，所以还是用q-input
        <q-field dense  stack-label label-slot <#if containerStyle?has_content> class="${containerStyle}"</#if><#if formDisabled!false> disable</#if>>
            <#if .node?parent["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node?parent["@tooltip"], "")}</q-tooltip></#if>
            <template v-slot:control>
                <q-editor flat dense  <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${name}"</#if>
                    <#t><#if formDisabled! || ec.getResource().condition(.node.@disabled!"false", "")> disable</#if>
                    <#t>style="width:100%;"
                    <#t> min-height="${.node["@rows"]!"3"}rem"<#if .node["@read-only"]! == "true"> readonly="readonly"</#if>
                          :toolbar="[
                            [          {
                                         icon: $q.iconSet.editor.formatting,
                                         fixedLabel: true,
                                         options: ['bold', 'italic', 'strike', 'underline', 'subscript', 'superscript']
                                       }
                            ],
                            [          {
                                         icon: $q.iconSet.editor.fontSize,
                                         fixedLabel: true,
                                         options: ['quote', 'unordered', 'ordered', 'outdent', 'indent']
                                       }
                            ],
                            ['undo', 'redo'],
                            ['fullscreen']
                          ]"
                ></q-editor>
            </template>
            <template v-slot:label>
                <div> <#if fieldLabel?has_content>${fieldLabel}</#if>
                    <#if validationClasses?contains("required")><em class="text-red"> * </em></#if>
                </div>
            </template>
        </q-field>
    3、去掉outlined
-->
<#macro "text-area">
    <#assign tlSubFieldNode = .node?parent>
    <#assign tlFieldNode = tlSubFieldNode?parent>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <#assign fieldValue = sri.getFieldValueString(.node)>
    <#assign editorType = ec.getResource().expand(.node["@editor-type"]!"", "")>
    <#assign validationClasses = formInstance.getFieldValidationClasses(tlSubFieldNode)>
    <#assign validationRules = formInstance.getFieldValidationJsRules(tlSubFieldNode)!>

    <#if editorType == "html">
        <#-- support CSS from editorScreenThemeId with resourceTypeEnumId=STRT_STYLESHEET, like: contentsCss:['/css/mysitestyles.css','/css/anotherfile.css']; -->
        <#-- see: https://ckeditor.com/docs/ckeditor4/latest/api/CKEDITOR_config.html#cfg-contentsCss -->
        <#assign editorScreenThemeId = ec.getResource().expand(.node["@editor-theme"]!"", "")>
        <#assign editorThemeCssList = sri.getThemeValues("STRT_STYLESHEET", editorScreenThemeId)>
        <m-ck-editor<#if fieldsJsName?has_content> v-model="${fieldsJsName}.${name}"</#if>
                :config="{ customConfig:'',<#if editorThemeCssList?has_content>contentsCss:[<#list editorThemeCssList as themeCss>'${themeCss}'<#sep>,</#list>],</#if>
                    allowedContent:true, linkJavaScriptLinksAllowed:true, fillEmptyBlocks:false,
                    extraAllowedContent:'p(*)[*]{*};div(*)[*]{*};li(*)[*]{*};ul(*)[*]{*};i(*)[*]{*};span(*)[*]{*}',
                    width:'100%', height:'600px', removeButtons:'Image,Save,NewPage,Preview',autoParagraph:false}"></m-ck-editor>
    <#elseif editorType == "md">
        <m-simple-mde<#if fieldsJsName?has_content> v-model="${fieldsJsName}.${name}"</#if>
                :config="{ indentWithTabs:false, autoDownloadFontAwesome:false, autofocus:true, spellChecker:false }"></m-simple-mde>
    <#else>
        <#assign tlAlign = tlFieldNode["@align"]!"left">
        <m-text-line dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> id="${tlId}" type="textarea"<#rt>
                <#t> name="${name}"<#if .node.@prefix?has_content> prefix="${ec.resource.expand(.node.@prefix, "")}"</#if>
                <#t> <#if fieldsJsName?has_content>v-model="${fieldsJsName}.${name}" :fields="${fieldsJsName}"<#else><#if fieldValue?html == fieldValue>value="${fieldValue}"<#else>:value="'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(fieldValue)}'"</#if></#if>
                <#t><#if .node.@size?has_content> size="${.node.@size}"<#else> style="width:100%;"</#if><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>

                <#t><#if .node["@cols"]?has_content> cols="${.node["@cols"]}"</#if>
                <#t> rows="${.node["@rows"]!"3"}"
                <#t><#if .node["@autogrow"]! == "true"> autogrow</#if>
                <#t><#if .node["@read-only"]! == "true"> readonly="readonly"</#if>

                <#t><#if formDisabled! || ec.getResource().condition(.node.@disabled!"false", "")> disable</#if>
                <#t> class="<#if validationClasses?has_content>${validationClasses}</#if><#if tlAlign == "center"> text-center<#elseif tlAlign == "right"> text-right</#if>"
                <#t><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
                <#t><#if expandedMask?has_content> mask="${expandedMask}" fill-mask="_"<#if validationClasses?contains("number")> :reverse-fill-mask="true"</#if></#if>

                <#t><#if validationRules?has_content || .node.@rules?has_content>
                    <#t> :rules="[<#if .node.@rules?has_content>${.node.@rules},</#if><#list validationRules! as valRule>value => ${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.expr)}||'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.message)}'<#sep>,</#list>]"
                <#t></#if>
                <#lt><#if ownerForm?has_content> form="${ownerForm}"</#if><#if tlSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(tlSubFieldNode["@tooltip"], "")?html}"</#if>>
        </m-text-line>


    </#if>
</#macro>
<#--
1、去掉outlined
2、增加moquiKey
-->
<#macro "text-line">
    <#assign tlSubFieldNode = .node?parent>
    <#assign tlFieldNode = tlSubFieldNode?parent>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign fieldValue = sri.getFieldValueString(.node)>
    <#assign validationClasses = formInstance.getFieldValidationClasses(tlSubFieldNode)>
    <#assign validationRules = formInstance.getFieldValidationJsRules(tlSubFieldNode)!>
    <#assign moquiKey = tlSubFieldNode["@moqui-key"]!>
    <#-- NOTE: removed number type (<#elseif validationClasses?contains("number")>number) because on Safari, maybe others, ignores size and behaves funny for decimal values -->
    <#if .node["@ac-transition"]?has_content>
        <#assign acUrlInfo = sri.makeUrlByType(.node["@ac-transition"], "transition", .node, "false")>
        <#assign acUrlParameterMap = acUrlInfo.getParameterMap()>
        <#assign acShowValue = .node["@ac-show-value"]! == "true">
        <#assign acUseActual = .node["@ac-use-actual"]! == "true">
        <#if .node["@ac-initial-text"]?has_content><#assign valueText = ec.getResource().expand(.node["@ac-initial-text"]!, "")>
            <#else><#assign valueText = fieldValue></#if>
        <#assign depNodeList = .node["depends-on"]>
        <strong class="text-negative">text-line with @ac-transition is not supported, use drop-down with dynamic-options.@server-search</strong>
        <#--
        <text-autocomplete id="${tlId}" name="${name}" url="${acUrlInfo.url}" value="${fieldValue?html}" value-text="${valueText?html}"<#rt>
                <#t> type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if>" size="${.node.@size!"30"}"
                <#t><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
                <#t><#if ec.getResource().condition(.node.@disabled!"false", "")> :disabled="true"</#if>
                <#t><#if validationClasses?has_content> validation-classes="${validationClasses}"</#if>
                <#t><#if validationClasses?contains("required")> :required="true"</#if>
                <#t><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
                <#t><#if .node?parent["@tooltip"]?has_content> tooltip="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>
                <#t><#if ownerForm?has_content> form="${ownerForm}"</#if>
                <#t><#if .node["@ac-min-length"]?has_content> :min-length="${.node["@ac-min-length"]}"</#if>
                <#t> :depends-on="{<#list depNodeList as depNode><#local depNodeField = depNode["@field"]>'${depNode["@parameter"]!depNodeField}':'<@fieldIdByName depNodeField/>'<#sep>, </#list>}"
                <#t> :ac-parameters="{<#list acUrlParameterMap.keySet() as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>'${parameterKey}':'${acUrlParameterMap.get(parameterKey)}', </#if></#list>}"
                <#t><#if .node["@ac-delay"]?has_content> :delay="${.node["@ac-delay"]}"</#if>
                <#t><#if .node["@ac-initial-text"]?has_content> :skip-initial="true"</#if>/>
        -->
    <#else>
        <#assign tlAlign = tlFieldNode["@align"]!"left">
        <#assign fieldLabel><@fieldTitle tlSubFieldNode/></#assign>
        <#if .node["@default-transition"]?has_content>
            <#assign defUrlInfo = sri.makeUrlByType(.node["@default-transition"], "transition", .node, "false")>
            <#assign defUrlParameterMap = defUrlInfo.getParameterMap()>
            <#assign depNodeList = .node["depends-on"]>
        </#if>
        <#assign inputType><#if .node["@input-type"]?has_content>${.node["@input-type"]}<#else><#rt>
            <#lt><#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if></#if></#assign>
        <#-- TODO: possibly transform old mask values (for RobinHerbots/Inputmask used in vapps/vuet) -->
        <#assign expandedMask = ec.getResource().expandNoL10n(.node["@mask"]!"", "")!>
        <m-text-line dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> id="${tlId}" type="${inputType}"<#rt>
                <#t> name="${name}"<#if .node.@prefix?has_content> prefix="${ec.resource.expand(.node.@prefix, "")}"</#if>
                <#t> <#if fieldsJsName?has_content>v-model="${fieldsJsName}.${name}" :fields="${fieldsJsName}"<#else><#if fieldValue?html == fieldValue>value="${fieldValue}"<#else>:value="'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(fieldValue)}'"</#if></#if>
                <#t><#if .node.@size?has_content> size="${.node.@size}"<#else> style="width:100%;"</#if><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
                <#t><#if formDisabled! || ec.getResource().condition(.node.@disabled!"false", "")> disable</#if>
                <#t> class="<#if validationClasses?has_content>${validationClasses}</#if><#if tlAlign == "center"> text-center<#elseif tlAlign == "right"> text-right</#if>"
                <#t><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
                <#t><#if expandedMask?has_content> mask="${expandedMask}" fill-mask="_"<#if validationClasses?contains("number")> :reverse-fill-mask="true"</#if></#if>
                <#t><#if .node["@default-transition"]?has_content>
                    <#t> default-url="${defUrlInfo.path}" :default-load-init="true"<#if .node["@depends-optional"]! == "true"> :depends-optional="true"</#if>
                    <#t> :depends-on="{<#list depNodeList as depNode><#local depNodeField = depNode["@field"]>'${depNode["@parameter"]!depNodeField}':'${depNodeField}'<#sep>, </#list>}"
                    <#t> :default-parameters="{<#list defUrlParameterMap.keySet() as parameterKey><#if defUrlParameterMap.get(parameterKey)?has_content>'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(parameterKey)}':'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(defUrlParameterMap.get(parameterKey))}', </#if></#list>}"
                <#t></#if>
                <#t><#if validationRules?has_content || .node.@rules?has_content>
                    <#t> :rules="[<#if .node.@rules?has_content>${.node.@rules},</#if><#list validationRules! as valRule>value => ${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.expr)}||'${Static["org.moqui.util.WebUtilities"].encodeHtmlJsSafe(valRule.message)}'<#sep>,</#list>]"
                <#t></#if>
                <#lt><#if ownerForm?has_content> form="${ownerForm}"</#if><#if tlSubFieldNode["@tooltip"]?has_content> tooltip="${ec.getResource().expand(tlSubFieldNode["@tooltip"], "")?html}"</#if>
                <#lt><#if moquiKey?has_content>moquiKey = "${moquiKey}"</#if>
        ></m-text-line>

    </#if>
</#macro>
<#--
1、去掉outlined
-->
<#macro "text-find">
<div class="row">
    <#assign curFieldName><@fieldName .node/></#assign>
    <#assign fieldLabel><@fieldTitle .node?parent/></#assign>
    <#assign hideOptions = .node["@hide-options"]!"false">
    <q-input dense <#if fieldLabel?has_content> stack-label label="${fieldLabel}"</#if> name="${curFieldName}"<#rt>
            <#t> size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if> id="<@fieldId .node/>"
            <#t><#if ownerForm?has_content> form="${ownerForm}"</#if>
            <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}"<#else> value="${sri.getFieldValueString(.node)?html}"</#if>>
        <#if .node["@tooltip"]?has_content><q-tooltip>${ec.getResource().expand(.node["@tooltip"], "")}</q-tooltip></#if>
        <#if hideOptions != "true" && (hideOptions != "ignore-case" || hideOptions != "operator")>
        <template v-slot:after>
            <#if hideOptions != "operator">
                <#assign defaultOperator = .node["@default-operator"]!"contains">
                <q-checkbox class="on-left" size="xs" name="${curFieldName}_not" label="${ec.getL10n().localize("Not")}"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#t><#if fieldsJsName?has_content> true-value="Y" false-value="N" v-model="${fieldsJsName}.${curFieldName}_not"<#else>
                    <#t> value="Y"<#if ec.getWeb().parameters.get(curFieldName + "_not")! == "Y"> checked="checked"</#if></#if>></q-checkbox>
                <q-select class="on-left" dense  options-dense emit-value map-options name="${curFieldName}_op"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#t><#if fieldsJsName?has_content> v-model="${fieldsJsName}.${curFieldName}_op"<#else> value="${ec.web.parameters.get(curFieldName + "_op")!defaultOperator!""}"</#if>
                    <#t> :options="[{value:'equals',label:'${ec.getL10n().localize("Equals")}'},{value:'like',label:'${ec.getL10n().localize("Like")}'},{value:'contains',label:'${ec.getL10n().localize("Contains")}'},{value:'begins',label:'${ec.getL10n().localize("Begins With")}'},{value:'empty',label:'${ec.getL10n().localize("Empty")}'}]"></q-select>
            </#if>
            <#if hideOptions != "ignore-case">
                <#assign ignoreCase = (ec.getWeb().parameters.get(curFieldName + "_ic")! == "Y") || !(.node["@ignore-case"]?has_content) || (.node["@ignore-case"] == "true")>
                <q-checkbox size="xs" name="${curFieldName}_ic" label="${ec.getL10n().localize("Ignore Case")}"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#t><#if fieldsJsName?has_content> true-value="Y" false-value="N" v-model="${fieldsJsName}.${curFieldName}_ic"<#else> value="Y"<#if ignoreCase> checked="checked"</#if></#if>></q-checkbox>
            </#if>
        </template>
        </#if>
    </q-input>
</div>
</#macro>
