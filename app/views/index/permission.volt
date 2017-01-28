{% extends "master.volt" %}
{% block content %}
    <ol class="breadcrumb">
        <li><a href="{{ url('/index/index') }}">首页</a></li>
        <li><a href="{{ url('/index/permission') }}">权限列表</a></li>
        <li class="active">权限列表</li>
    </ol>
    <h1 class="page-header">
        权限列表
        <a href="{{ url('/index/addPermission/0') }}" class="btn btn-primary" style="float:right">新增</a>
    </h1>
    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>ID</th>
                <th>权限名名</th>
                <th>权限</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="list">
            </tbody>
        </table>
        <div id="page"></div>
    </div>
    <input type="hidden" id="postUrl" value="{{ url('/api/permission/pfnList') }}">
    <input type="hidden" id="infoUrl" value="{{ url('/index/permissionInfo') }}">
    <input type="hidden" id="addUrl" value="{{ url('/index/addPermission') }}">
    <input type="hidden" id="pid" value="{{ pid }}">
{% endblock %}
{% block js %}
    <script src="{{ static_url('/lib/jquery-2.2.4/jquery.pagination.js') }}"></script>
    <script>
        var pageSize = 10;
        var pageIndex = 0;

        $(function () {
            $.setSideBar(2);
            bindData();
        });

        //这个事件是在翻页时候用的
        function pageselectCallback(page_id) {
            pageIndex = page_id;
            bindData();
        }

        function bindData() {
            var json = {
                pageIndex: pageIndex,
                pageSize: pageSize,
                pid: $("#pid").val()
            };
            var url = $("#postUrl").val();
            $.post(url, json, function (jsonData) {
                if (jsonData.status == 1) {
                    var res = jsonData.data;
                    var html = "";
                    $.each(res.data, function (i, v) {
                        html += '<tr>';
                        html += '<td>' + v.id + '</td>';
                        html += '<td>' + v.name + '</td>';
                        html += '<td>' + (v.root == 1 ? "全权限" : v.url) + '</td>';
                        html += '<td>';
                        html += '<a onclick="toInfo(' + v.id + ')" class="btn btn-default">详情</a>';
                        html += '<a onclick="btnAdd(' + v.id + ')" class="btn btn-default">新增子权限</a>';
                        html += '</td>';
                        html += '</tr>';
                    });
                    $("#list").html(html);
                    initpagination(res.count);
                } else {
                    $.error(jsonData.message);
                }
            }, "json");
        }

        function initpagination(count) {
            //加入分页的绑定
            $("#page").pagination(count, {
                callback: pageselectCallback,
                prev_text: '上一页',
                next_text: '下一页',
                items_per_page: pageSize,
                num_display_entries: 6,
                current_page: pageIndex,
                num_edge_entries: 2
            });
        }

        function toInfo(id) {
            var url = $("#infoUrl").val();
            location = url + "/" + id;
        }

        function btnAdd(id) {
            var url = $("#addUrl").val();
            location = url + "/" + id;
        }
    </script>
{% endblock %}