
goog.provide("mt.ui")
goog.provide("mt.ui.BlogContainer")
goog.provide("mt.mindblog")

goog.require("goog.dom")
goog.require("goog.dom.classes")
goog.require("goog.style")
goog.require("goog.ui.Control")
goog.require("goog.ui.Container")
goog.require("goog.ui.ContainerRenderer")
goog.require('goog.net.Jsonp')
goog.require('goog.events')

goog.require('dg.MsgCompiler')

mt.mindblog.VERSION = "$VERSION$"

class mt.ui.BlogContainer

  ###
  @extends {goog.ui.Container}
  @constructor
  ###
  constructor: (@title)->

    @titleElm_ = null
    @contentElm_ = null
    @detailPlaceElm_ = null

    renderer = goog.ui.ContainerRenderer.getCustomRenderer(goog.ui.ContainerRenderer, "mind-blog")

    self = @
    renderer.getContentElement = (elm)->
      self.contentElm_

    renderer.createDom = ->
      dom = goog.dom.createDom
      baseClass = @getCssClass()
      self.titleElm_ = dom("div", {"class":goog.getCssName(baseClass, "title")})
      self.contentElm_ = dom("div", {"class":goog.getCssName(baseClass, "content")})

      self.detailPlaceElm_ = dom("div")

      self.panel1Elm_ = dom("div", goog.getCssName(baseClass, "panel-left"),
        self.titleElm_, self.contentElm_)
      self.panel2Elm_ = dom("div", goog.getCssName(baseClass, "panel-right"), self.detailPlaceElm_)

      clear = dom("div", {"class":goog.getCssName("clear")})

      elm = dom('div', {"class":goog.getCssName(baseClass, "container")},
        self.panel1Elm_, self.panel2Elm_, clear)

    goog.ui.Container.call(@, goog.ui.Container.Orientation.VERTICAL, renderer)

  goog.inherits(@, goog.ui.Container)

  render: (elm)->
    mt.ui.BlogContainer.superClass_.render.call(@, elm)
    @setTitle(@title)


  enterDocument: ->
    mt.ui.BlogContainer.superClass_.enterDocument.call(@)
    self = this
    goog.events.listen this.titleElm_, goog.events.EventType.CLICK, (e)->
      self.maximizeAllPosts()
      self.hidePost()

  exitDocument: ->
    mt.ui.BlogContainer.superClass_.exitDocument.call(@)
    goog.events.unlisten(this.titleElm_)

  setTitle: (title, safe=false)->
    if safe
      this.titleElm_.textContent = title
    else
      this.titleElm_.innerHTML = title


  minimizeAllPosts: ->
    this.forEachChild (p)->
      p.minimize()
    goog.dom.classes.add(@getElement(), goog.getCssName("min"))
    goog.style.setStyle(this.panel1Elm_, {"position":"fixed"})

  maximizeAllPosts: ->
    this.forEachChild (p)->
      p.maximize()
    goog.dom.classes.remove(@getElement(), goog.getCssName("min"))
    goog.style.setStyle(this.panel1Elm_, {"position":"initial"})

  setPostViewer: (pv, render)->
    this.postViewer_ = pv
    if render
      pv.render(this.detailPlaceElm_)

  viewPost: (p)->
    this.postViewer_.setTitle(p.post.title)
    this.postViewer_.setContent(window['dg']['MsgCompiler']['compileAll'](p.post.message, 'Article'))
    this.postViewer_.setCreator(p.post.creator)
    this.postViewer_.setVisible(true)
    this.forEachChild (cp)->cp.setSelected(false)
    p.setSelected(true)

  hidePost: ->
    this.postViewer_.setVisible(false)



class mt.ui.BlogItem

  ###
  @extends {goog.ui.Control}
  @constructor
  ###
  constructor: (class_name="blog-item")->
    renderer = new goog.ui.ControlRenderer.getCustomRenderer(goog.ui.ControlRenderer, class_name)
    goog.ui.Control.call(@, class_name, renderer)
    this.setSupportedState(goog.ui.Component.State.SELECTED, true)

  goog.inherits(@, goog.ui.Control)

class mt.ui.BlogArticle

  ###
  @extends {mt.ui.BlogItem}
  @constructor
  ###
  constructor: (@post)->
    mt.ui.BlogItem.call(@)
    #@createDom()

  goog.inherits(@, mt.ui.BlogItem)

  getBaseClass: -> this.getRenderer().getCssClass()

  createDom: ->
    gc = goog.getCssName
    dom = goog.dom.createDom
    baseClass = this.getBaseClass()
    elm = dom("div", {"class":baseClass})

    @thumbContainerElm_ = dom("div", {"class":gc(baseClass, "thumb")}, dom("img", {"src":@post['thumbnail_url']}))

    @titleElm_ = dom("div", {"class":gc(baseClass, "title")})
    @descElm_ = dom("div")

    @titleElm_.textContent = @post['title']
    @descElm_.textContent = @post.short_desc

    rightElm = dom("div", {"class":gc(baseClass, "content-outer")}, @titleElm_, @descElm_,
      dom("div", {"class":goog.getCssName("clear")}) )

    elm.appendChild(@thumbContainerElm_)
    elm.appendChild(rightElm)
    elm.appendChild(dom("div", {"class":goog.getCssName("clear")}))

    @setElementInternal(elm)

  minimize: ->
    elm = this.getElement()
    this.showDesc(false)
    this.showThumb(false)
    goog.style.setStyle(this.titleElm_, {"font-size":"14px !important"})
    goog.style.setStyle(elm, {"max-width":"300px","padding":"0px"})

    baseClass = this.getBaseClass()
    goog.dom.classes.add(elm, goog.getCssName(baseClass, "min"))


  maximize: ->
    this.showDesc(true)
    this.showThumb(true)
    goog.style.setStyle(this.titleElm_, {"font-size":'42px'})
    this.descElm_.removeAttribute("style")

    elm = this.getElement()

    elm.removeAttribute("style")

    baseClass = this.getBaseClass()
    goog.dom.classes.remove(elm, goog.getCssName(baseClass, "min"))

  showDesc: (state)->
    goog.style.setStyle(this.descElm_, {"display":if state then "block" else "none"})

  showThumb: (state)->
    goog.style.setStyle(@thumbContainerElm_, {"display":if state then "block" else "none"})


class mt.ui.PostViewer
  ###
  @extends {goog.ui.Container}
  @constructor
  ###
  constructor: ()->
    renderer = new goog.ui.ContainerRenderer.getCustomRenderer(goog.ui.ContainerRenderer, "post-viewer")
    goog.ui.Container.call(@, null, renderer)
  goog.inherits(@, goog.ui.Container)

  createDom: ->
    dom = goog.dom.createDom
    this.titleElm_ = dom("h2")
    this.creatorElm_ = dom("div", {"class":goog.getCssName("post-creator")})
    this.postContentElm_ = dom("div", {"class":goog.getCssName("message-content")})
    elm = dom("div", {"class":this.getRenderer().getCssClass()},
      this.titleElm_, this.creatorElm_, this.postContentElm_)
    @setElementInternal(elm)

  enterDocument: ->
    mt.ui.PostViewer.superClass_.enterDocument.call(@)
    ev = new goog.events.Event(goog.events.EventType.DBLCLICK)
    ev.target = @
    self = @
    goog.events.listen this.getElement(), goog.events.EventType.DBLCLICK, (e)->
      self.dispatchEvent(ev)

  exitDocument: ->
    goog.events.unlisten(this.getElement())

  ###
  set post title
  ###
  setTitle: (title)->this.titleElm_.textContent = title
  setContent: (msg)->this.postContentElm_.innerHTML = msg
  setCreator: (creator)->this.creatorElm_.innerHTML = "by: <a href=\"#{digaku.baseurl}/u/#{creator["name"]}\">#{creator["full_name"]}</a>"

digaku = {
  baseurl: 'http://www.mindtalk.com'
}

mt.mindblog.init = ()->

  console.log("Mindblog " + mt.mindblog.VERSION)

  goog.events.listen window, goog.events.EventType.LOAD, (e)->

    rootElm = document.getElementsByTagName("mt:mindblog")[0]

    theme = rootElm.getAttribute("theme")

    if theme == "default"
      # Inject css
      st = goog.dom.createDom("link", {"rel":"stylesheet", "type":"text/css", "href":"dg.mindblog-latest.min.css?#{mt.mindblog.VERSION}"})
      document.body.insertBefore(st, document.body.firstChild)

    user_name = rootElm.getAttribute("user_name")

    blog = new mt.ui.BlogContainer("#{user_name} <small>Mindtalk's blog</small>")
    blog.createDom()
    blog.render(rootElm)

    postViewer = new mt.ui.PostViewer()
    blog.setPostViewer(postViewer, true)
    postViewer.setVisible(false)

    goog.events.listen postViewer, goog.events.EventType.DBLCLICK, (e)->
      blog.maximizeAllPosts()
      blog.hidePost()

    jsonp = new goog.net.Jsonp("http://api.mindtalk.com/v1/user/stream")
    jsonp.setRequestTimeout(20000)
    jsonp.send {'name':user_name,'rf':'json','kind':'Article'}, (resp)->
      for post in resp.result['posts']
        post.short_desc = post['message'][..400]
        p = new mt.ui.BlogArticle(post)
        blog.addChild(p, true)

        goog.events.listen p, goog.ui.Component.EventType.ACTION, (e)->
          blog.minimizeAllPosts()
          blog.viewPost(e.target)


mt.mindblog.init()
