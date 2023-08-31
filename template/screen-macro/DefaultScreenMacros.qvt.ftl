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
    <m-drop-down name="${name}" id="${tlId}"
            <#if fieldLabel?has_content> label="${fieldLabel}"</#if><#if validationClasses?contains("required")> label-color="primary"</#if>
            <#if formDisabled!> disable</#if><#rt>
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
            <#lt>>
            <#-- support <#if .node["@current"]! == "first-in-list"> again? -->
            <#if ec.getResource().expandNoL10n(.node["@show-not"]!, "") == "true">
            <template v-slot:after>
                <q-checkbox size="xs" name="${name}_not" label="${ec.getL10n().localize("Not")}"<#if ownerForm?has_content> form="${ownerForm}"</#if><#rt>
                    <#t><#if fieldsJsName?has_content> true-value="Y" false-value="N" v-model="${fieldsJsName}.${name}_not"<#else> value="Y"<#if ec.getWeb().parameters.get(name + "_not")! == "Y"> checked="checked"</#if></#if>></q-checkbox>
            </template>
            </#if>
    </m-drop-down>
</#macro>
