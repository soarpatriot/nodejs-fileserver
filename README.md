nodejs-fileserver
=================
a simple static file server, upload file to this server and access file via api
        http://yourdomain/files/:id


### prerequisites

1.node.js<br />
2.expressjs<br />
3.coffeescript (optional for only use this project)<br />
4.upload client using [jQuery-File-Upload](https://github.com/blueimp/jQuery-File-Upload) (optional)<br />

### run this server
1.nmp install<br />
2.node app or supervisor app<br />


### using
1. upload url , example:<br />

        http://localhost:8080/uplad

2. return json data after uploaded, example:<br />

        {"name":"flamingo (13).js",
         "originalName":"flamingo.js",
         "size":79998,"type":"application/javascript",
         "delete_type":"DELETE",
         "url":"http://localhost:3000/upload/flamingo%20(13).js",
         "delete_url":"http://localhost:3000/upload/flamingo%20(13).js"}

3. access file api<br />

        http://localhost:8080/files/:id         //:id is json data name like flamingo (13).js



4. client side upload program fragment:<br/>

        require(["require","jquery","jquery.iframe-transport","jquery.fileupload"],function(require,$) {

            $('#fileupload').fileupload({
                // Uncomment the following to send cross-domain cookies:
                //xhrFields: {withCredentials: true},
                url:'http://192.168.1.102:8080/upload'
            });
            $('#fileupload').fileupload('option', {

                maxFileSize: 5000000,
                acceptFileTypes: /(\.|\/)(gif|jpe?g|png|js)$/i,
                process: [
                    {
                        action: 'load',
                        fileTypes: /^image\/(gif|jpeg|png|js)$/,
                        maxFileSize: 20000000 // 20MB
                    },
                    {
                        action: 'resize',
                        maxWidth: 1440,
                        maxHeight: 900
                    },
                    {
                        action: 'save'
                    }
                ]
            });

            // Enable iframe cross-domain access via redirect option:
            $('#fileupload').fileupload(
                'option',
                'redirect',
                window.location.href.replace(
                    /\/[^\/]*$/,
                    '/cors/result.html?%s'
                )
            );

            $('#fileupload').fileupload({

                dataType: 'json',
                add: function (e, data) {
                    $.each(data.files, function (index, file) {
                        $('<p/>').text(file.name).appendTo($("#upload-result"));
                    });

                    var jqXHR = data.submit()
                        .success(function (result, textStatus, jqXHR) {
                            console.log("result: "+JSON.stringify(result[0]));

                            $("#file-name").val(result[0].name);
                            $("#file-original").val(result[0].originalName);
                            $("#file-size").val(result[0].size);
                            $("#file-delete_type").val(result[0].delete_type);
                            $("#file-url").val(result[0].url);
                            $("#file-delete_url").val(result[0].delete_url);

                            $("#post-form").submit();


                        })
                        .error(function (jqXHR, textStatus, errorThrown) {

                        })
                        .complete(function (result, textStatus, jqXHR) {
                            console.log("result complete: "+JSON.stringify(result));
                        });
                },
                change: function (e, data) {
                    $.each(data.files, function (index, file) {

                    });
                },
                drop: function (e, data) {
                    $.each(data.files, function (index, file) {

                    });
                },

                done: function (e, data) {

                },

                progressall: function (e, data) {
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('#percent').text(progress+'%')
                    $('#progress .bar').css(
                        'width',
                        progress + '%'
                    );
                }
            });


        });
