<#-- @ftlvariable name="pageVar" type="randomnaja.orgfeed.action.AdminManageAction.PageVar" -->
<!DOCTYPE html PUBLIC
        "-//W3C//DTD XHTML 1.1 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Admin SignIn</title>

    <script type="text/javascript">
        APP.namespace('actions', {
            generateDeviceCode: '${packageURI}/generateDeviceCode.html',
            signIn: '${packageURI}/signIn.html',
            fetchPage: '${packageURI}/fetchPage.html',
            retrieveFetchStatus: '${packageURI}/retrieveFetchStatus.html',
            indexingPage: '${packageURI}/indexingPage.html',
            deleteIndex: '${packageURI}/deleteIndex.html',
            deletePage: '${packageURI}/deletePage.html'
        });
    </script>
    <script type="text/javascript">
        (function() {
            APP.namespace('request.parameters', {});
            document.on('layout:init', function(event) {

            });// end layout:init

            document.on('dom:loaded', function(evt){
                //
                $$('#genDeviceCode')[0].on('click', function(){
                    document.fire('state:busy');
                    new Ajax.Request(APP.actions.generateDeviceCode, {
                        method : 'POST',
                        asynchronous : true,
                        encoding : 'UTF-8',
                        evalJSON : true,
                        onSuccess : (function(transport) {
                            APP.response.handlers.success(transport, function(json){

                                $$('#deviceCode')[0].innerHTML = '';
                                $$('#deviceCode')[0].appendChild(
                                        new Element('div').update(json.data));

                                $$('#deviceCode')[0].appendChild(
                                        new Element('div')
                                                .insert(new Element('a', {href:'https://www.facebook.com/device', target:'_blank'})
                                                        .update('Goto Facebook'))
                                );
                            });
                        }),
                        onFailure : (function(tra){
                            alert('Fail, ' + tra);
                        })
                    });
                });

                $$('#checkDeviceAuth')[0].on('click', function(){
                    document.fire('state:busy');
                    new Ajax.Request(APP.actions.signIn, {
                        method : 'POST',
                        asynchronous : true,
                        encoding : 'UTF-8',
                        evalJSON : true,
                        onSuccess : (function(transport) {
                            APP.response.handlers.success(transport, function(json){
                            });
                        }),
                        onFailure : (function(tra){
                            alert('Fail, ' + tra);
                        })
                    });
                });

                $$('#fetchNewPage')[0].on('click', function(){
                    document.fire('state:busy');
                    new Ajax.Request(APP.actions.fetchPage, {
                        method : 'POST',
                        asynchronous : true,
                        encoding : 'UTF-8',
                        evalJSON : true,
                        parameters : {'param.pageId' : $$('#new-page-id')[0].value },
                        onSuccess : (function(transport) {
                            APP.response.handlers.success(transport, function(json){

                            });
                        }),
                        onFailure : (function(tra){
                            alert('Fail, ' + tra);
                        })
                    });
                });

                $$('#fetchNewPageStatus')[0].on('click', function(){
                    document.fire('state:busy');
                    new Ajax.Request(APP.actions.retrieveFetchStatus, {
                        method : 'POST',
                        asynchronous : true,
                        encoding : 'UTF-8',
                        evalJSON : true,
                        parameters : {'param.pageId' : $$('#new-page-id')[0].value },
                        onSuccess : (function(transport) {
                            APP.response.handlers.success(transport, function(json){
                                alert("state : " + json.data.state);

                                if (json.data.error) {
                                    alert('Error message : ' + json.data.error.message);
                                }
                            });
                        }),
                        onFailure : (function(tra){
                            alert('Fail, ' + tra);
                        })
                    });
                });

                $$('.indexing').each(function(ele){

                    ele.on('click', function(){
                        document.fire('state:busy');
                        var pageId = ele.getAttribute('data-pageid');

                        new Ajax.Request(APP.actions.indexingPage, {
                            method : 'POST',
                            asynchronous : true,
                            encoding : 'UTF-8',
                            evalJSON : true,
                            parameters : {'param.pageId' : pageId },
                            onSuccess : (function(transport) {
                                //console.log('It is done');
                                APP.response.handlers.success(transport, function(json){
                                    //alert('Indexing done');
                                });
                            }),
                            onFailure : (function(tra){
                                alert('Fail, ' + tra);
                            })
                        });
                    });
                });

                $$('.deleteIndex').each(function(ele){

                    ele.on('click', function(){
                        var pageId = ele.getAttribute('data-pageid');
                        document.fire('state:busy');

                        new Ajax.Request(APP.actions.deleteIndex, {
                            method : 'POST',
                            asynchronous : true,
                            encoding : 'UTF-8',
                            evalJSON : true,
                            parameters : {'param.pageId' : pageId },
                            onSuccess : (function(transport) {
                                APP.response.handlers.success(transport, function(json){
                                    alert('index is deleted');
                                });
                            }),
                            onFailure : (function(tra){
                                alert('Fail, ' + tra);
                            })
                        });
                    });
                });

                $$('.deletePage').each(function(ele){

                    ele.on('click', function(){
                        var pageId = ele.getAttribute('data-pageid');

                        if(confirm("Delete Page ? ")) {
                            new Ajax.Request(APP.actions.deletePage, {
                                method : 'POST',
                                asynchronous : true,
                                encoding : 'UTF-8',
                                evalJSON : true,
                                parameters : {'param.pageId' : pageId },
                                onSuccess : (function(transport) {
                                    APP.response.handlers.success(transport, function(json){
                                        alert('page is deleted');
                                    });
                                }),
                                onFailure : (function(tra){
                                    alert('Fail, ' + tra);
                                })
                            });
                        }
                    });
                });
            });
        })();
    </script>
</head>

<body>
<div id="signInContainer">
    <button id="genDeviceCode">Generate Device Code</button>
    <div id="deviceCode">

    </div>
    <button id="checkDeviceAuth">Check Device Auth</button>
    <div id="authResult">
    </div>
</div>
<div id="authenContainer">
    <p id="authInfo">

    </p>
</div>
<div>
    <!-- for each PageId -->
    <#list pageVar.pages as page>
        <div class="each-page-id">
            <label>Facebook Page Id : </label><span>${page.facebookId}</span>
            <#--<input type="text" value="${page.facebookId}"/>-->
            <span class="page-desc">${page.name!?html}</span>
            <div class="command-button">
                <#--<button class="fetchPage" data-pageid="${page.facebookId}">Fetch</button>-->
                <#--<button class="fetchPageStatus" data-pageid="${page.facebookId}">Check Fetch Status</button>-->
                <button class="deletePage" data-pageid="${page.facebookId}">Delete Page</button>
                <button class="indexing" data-pageid="${page.facebookId}">Indexing</button>
                <button class="deleteIndex" data-pageid="${page.facebookId}">Delete Index</button>
            </div>
        </div>
    </#list>

    <div class="create-new-page">
        <p>
            Fetch new Facebook Page
        </p>
        <label>Facebook Page Id</label><input id="new-page-id" type="text" value="121311591302809"/>
        <button id="fetchNewPage">Fetch</button>
        <button id="fetchNewPageStatus">Check Fetch Status</button>
    </div>

</div>
</body>

</html>

