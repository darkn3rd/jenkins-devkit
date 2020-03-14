pipelineJob('testjobs/hello-sinatra') {
  definition {
    cpsScm {
      scm {
        git{
          remote{
            url('https://github.com/darkn3rd/webmf-ruby-sinatra')
          }
          branch('*/master')
        }
        scriptPath('Jenkinsfile')
      }
    }
  }
}
