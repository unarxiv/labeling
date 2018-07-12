<template>
    <div>
        <div class="expand-row">
            <span class="expand-key">上传成员: </span>
            <span class="expand-value"><i v-for="(item,key) in row.uploadMemberList" :key="key">{{item.userName}}({{item.email}})</i></span>
        </div>
        <div class="expand-row">
            <span class="expand-key">标注成员: </span>
            <span class="expand-value"><i v-for="(item,key) in row.labelMemberList" :key="key">{{item.userName}}({{item.email}})</i></span>
        </div>
        <div class="expand-row">
            <span class="expand-key">审核人: </span>
            <span class="expand-value"><i v-for="(item,key) in row.auditMemberList" :key="key">{{item.userName}}({{item.email}})</i></span>
        </div>
        <div class="expand-row">
            <span class="expand-key">创建人: </span>
            <span class="expand-value"><i>{{ row.createdName }}({{row.email}})</i></span>
        </div>
    </div>
</template>
<script>
export default {
  props: {
    row: Object
  }
}
</script>
<style lang="less">
    .expand-row{
        border-bottom: 1px solid #FFFFFF;
        padding: .5em 0;
    }
    .expand-key{
        display: inline-block;
        width: 5em;
        text-align: right;
        margin-right: .5em;
    }
    .expand-value{

        &>i{
            display: inline-block;
            border: 1px solid #E5E5E5;
            border-radius: 2em;
            padding: .1em .5em;
        }
    }
    td.ivu-table-expanded-cell{
        padding: 0;
    }
</style>
