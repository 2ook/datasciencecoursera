shinyUI(pageWithSidebar(
  headerPanel('Shear Matrices and Their Effects'),
  
  sidebarPanel(
    h3('How to Use the App:'),
    helpText('There are two areas of user input in the app, 
             selecting the axis to shear and the b value for the shear matrix.'),
    helpText('Selecting the axis in the drop down menu (from options "X" and "Y") will change the way shear transformation affects the barn image on the right.'),
    helpText('Selecting a b value will change the magnitude of the shear transformation. 
             Note how changing this value affects the transformation of the barn.'),
    helpText('Hit the "Submit" button to see the image change'),
    a('For more information on shear matrices', href= 'http://en.wikipedia.org/wiki/Shear_matrix'),
    br(),
    br(),
    br(),
    
    selectInput('shearType', 'Along which axis would you like to shear?', choices = c('X' = 'X', 'Y' = 'Y')),
    sliderInput('b', 'b Value for Shearing the Barn', min = -2, max = 2, value = 0, step = .2), 
    submitButton('Submit'),
    
    h4('You decided to shear along...'), 
    verbatimTextOutput('shearType'),
    h4('The value for b was...'), 
    verbatimTextOutput('b')
    ),
  
  mainPanel(h3('Results of the Shear Matrix'),
            h4('The original barn...'),
            plotOutput('barnPlot'),
            h4('After being transformed by the shear matrix...'),
            plotOutput('shearPlot')
  )
)
)
  
