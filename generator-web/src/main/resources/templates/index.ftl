<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>代码生成平台</title>
    <meta name="keywords" content="代码生成平台">
    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />

    <@netCommon.commonScript />
    <#--<script src="${request.contextPath}/static/js/index-new.js"></script>-->
<script>
    $(function () {

        /**
         * 初始化 table sql 3
         */
        var ddlSqlArea = CodeMirror.fromTextArea(document.getElementById("ddlSqlArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-sql",
            lineWrapping:false,
            readOnly:false,
            foldGutter: true,
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        ddlSqlArea.setSize('auto','auto');
        // controller_ide
        var genCodeArea = CodeMirror.fromTextArea(document.getElementById("genCodeArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-java",
            lineWrapping:true,
            readOnly:true,
            foldGutter: true,
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        genCodeArea.setSize('auto','auto');

        var codeData;

        /**
         * 生成代码
         */
        $('#btnGenCode').click(function ()  {

            var tableSql = ddlSqlArea.getValue();
            $.ajax({
                type: 'POST',
                url: base_url + "/genCode",
                data: {
                    "tableSql": tableSql,
                    "packageName":$("#packageName").val(),
                    "returnUtil":$("#returnUtil").val(),
                    "authorName":$("#authorName").val()
                },
                dataType: "json",
                success: function (data) {
                    if (data.code == 200) {
                        layer.open({
                            icon: '1',
                            content: "代码生成成功",
                            end: function () {
                                codeData = data.data;
                                genCodeArea.setValue(codeData.model);
                                genCodeArea.setSize('auto', 'auto');
                            }
                        });
                    } else {
                        layer.open({
                            icon: '2',
                            content: (data.msg || '代码生成失败')
                        });
                    }
                }
            });
        });
        /**
         * 按钮事件组
         */
        $('.generator').bind('click', function () {
            if (!$.isEmptyObject(codeData)) {
                var id = this.id;
                genCodeArea.setValue(codeData[id]);
                genCodeArea.setSize('auto', 'auto');
            }
        });
        function donate(){
            layer.open({
                type: 1,
                area : ['712px' , '480px'],
                shadeClose: true, //点击遮罩关闭
                content: '<img src="http://upyun.bejson.com/img/zhengkai.png"></img>'
            });
        }
        $('#donate1').on('click', function(){
            donate();
        });
        $('#donate2').on('click', function(){
            donate();
        });
    });
</script>
</head>
<body style="background-color: #e9ecef">
<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron">
    <div class="container">
        <div class="input-group mb-3">
            <div class="input-group-prepend">
                <span class="input-group-text">作者名称</span>
            </div>
            <input type="text" class="form-control" id="authorName" name="authorName" placeholder="三维">
            <div class="input-group-prepend">
                <span class="input-group-text">包名路径</span>
            </div>
            <input type="text" class="form-control" id="packageName" name="packageName" placeholder="com.sunwayworld.lims4">
        </div>
        <textarea id="ddlSqlArea" placeholder="请输入表结构信息..." class="form-control btn-lg" style="height: 250px;">
CREATE TABLE `userinfo` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(255) NOT NULL COMMENT '用户名',
  `addtime` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息'
        </textarea><br>
        <p><button class="btn btn-primary btn-lg disabled" id="btnGenCode" role="button">开始生成 »</button></p>
        <hr>
        <!-- Example row of columns -->
        <div class="row" style="margin-top: 10px;">
            <!-- 后端 -->
            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled" id="btnGroupAddon">后端</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="model">entity(set/get)</button>
                    <button type="button" class="btn btn-default generator" id="mybatis">mybatis</button>
                    <button type="button" class="btn btn-default generator" id="service">service</button>
                    <button type="button" class="btn btn-default generator" id="service_impl">service_impl</button>
                    <button type="button" class="btn btn-default generator" id="controller">controller</button>
                </div>
            </div>
            <!--前端-->
            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled" id="btnGroupAddon">前端</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="model">form</button>
                    <button type="button" class="btn btn-default generator" id="mybatis">form.js</button>
                    <button type="button" class="btn btn-default generator" id="service">grid</button>
                    <button type="button" class="btn btn-default generator" id="service_impl">grid.js</button>
                </div>
            </div>
        </div>
        <hr>
        <textarea id="genCodeArea" class="form-control btn-lg" ></textarea>
    </div>
</div>
</body>
</html>
