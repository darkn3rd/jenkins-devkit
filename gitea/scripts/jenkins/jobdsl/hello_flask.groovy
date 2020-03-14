pipelineJob('testjobs/hello-flask') {
  definition {
    cpsScm {
      scm {
        git{
          remote{
            url('https://github.com/darkn3rd/webmf-python-flask')
          }
          branch('*/master')
        }
        scriptPath('Jenkinsfile')
      }
    }
  }
}
