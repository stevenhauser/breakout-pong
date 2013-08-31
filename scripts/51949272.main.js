!function(){!function(){define("vent",["require"],function(){return _.extend({},Backbone.Events)})}.call(this),function(){define("entity-cache",["require"],function(){var a;return a=function(){function a(){this.entities={}}return a.prototype.all=function(){return _.clone(this.entities)},a.prototype.get=function(a){return this.entities[a]},a.prototype.set=function(a,b,c){if(null==c&&(c=!0),!c&&null!=this.entities[a])throw"EntityCache::set - Already has entity with name `"+a+"`";return this.entities[a]=b,this.listenTo(b,"destroy",this.onDestroyEntity),this},a.prototype.remove=function(a){var b,c;return c=_.isString(a)?a:void 0,null==c&&_.find(this.entities,function(b,d){var e;return e=b===a,e&&(c=d),e}),b=this.entities[c],delete this.entities[c],this.stopListening(b),this},a.prototype.onDestroyEntity=function(a){return this.remove(a)},a}(),_.extend(a.prototype,Backbone.Events),a})}.call(this),function(){define("entities",["require","entity-cache"],function(a){var b;return b=a("entity-cache"),new b})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("models/base",["require"],function(){var a,c;return a=function(a){function d(){return c=d.__super__.constructor.apply(this,arguments)}return b(d,a),d.prototype.bindEvents=function(){return this},d}(Backbone.Model)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("models/entity",["require","models/base"],function(a){var c,d;return c=a("models/base"),d=function(a){function c(){c.__super__.constructor.apply(this,arguments),this.on("change",this.onChangeObject)}return b(c,a),c.prototype.shouldUpdate=!1,c.prototype.shorthand=["width","height","x","y","dirX","dirY","speedX","speedY","vx","vy"],c.prototype.defaults=function(){return{width:0,height:0,x:0,y:0,dirX:1,dirY:1,speedX:0,speedY:0,vx:0,vy:0}},c.prototype.constrainedCoord=function(a){var b,c,d;return d=this.calcCoord(a),c=this["v"+a]()>0,b="y"===a?c?this.bottomBound():this.topBound():c?this.rightBound():this.leftBound(),d=c?b>=d?d:b:d>=b?d:b},c.prototype.calcCoord=function(a){return this[a]()+this["v"+a]()},c.prototype.move=function(a,b){var c;return c=a.toUpperCase(),this["dir"+c](b).calculateVelocity(a),this},c.prototype.calculateVelocity=function(a){var b;return b=a.toUpperCase(),this["v"+a](this["speed"+b]()*this["dir"+b]()),this},c.prototype.stopMoving=function(){return this.stopMovingX().stopMovingY(),this},c.prototype.isMoving=function(){return 0!==this.vx()||0!==this.vy()},c.prototype.x1=function(){return this.x()},c.prototype.x2=function(){return this.x()+this.width()},c.prototype.y1=function(){return this.y()},c.prototype.y2=function(){return this.y()+this.height()},c.prototype.doUpdate=function(){return this.needsToUpdate()?(this.update(),this.shouldUpdate=!1,this):this},c.prototype.needsToUpdate=function(){return this.shouldUpdate||this.isMoving()},c.prototype.update=function(){return this.x(this.constrainedX()).y(this.constrainedY()),this},c.prototype.onChangeObject=function(){return this.shouldUpdate=!0},c}(c),d.prototype.constrainedX=_.partial(d.prototype.constrainedCoord,"x"),d.prototype.constrainedY=_.partial(d.prototype.constrainedCoord,"y"),d.prototype.moveX=_.partial(d.prototype.move,"x"),d.prototype.moveY=_.partial(d.prototype.move,"y"),d.prototype.stopMovingX=_.partial(d.prototype.moveX,0),d.prototype.stopMovingY=_.partial(d.prototype.moveY,0),d.prototype.calculateVelocityX=_.partial(d.prototype.calculateVelocity,"x"),d.prototype.calculateVelocityY=_.partial(d.prototype.calculateVelocity,"y"),d.prototype.calcX=_.partial(d.prototype.calcCoord,"x"),d.prototype.calcY=_.partial(d.prototype.calcCoord,"y"),d.shorthandify(),d})}.call(this),function(){define("utils",["require"],function(){return{uppercaseFirst:function(a){return a.charAt(0).toUpperCase()+a.slice(1)},pixelize:function(a){return a+"px"}}})}.call(this),function(){define("models/mixins/boundable",["require","utils"],function(a){var b,c,d,e,f,g,h,i,j,k;for(h=a("utils"),d="top right bottom left".split(" "),f=function(a,b){return _.result(a,b)||0},e=function(a){return"left"===a||"right"===a?"x":"y"},g=function(a){return a/2},c={getBound:function(a){return null!=this.bounds?this.bounds[a]:this[a]},topBound:function(){return this.getBound("top")},rightBound:function(){return this.getBound("right")-f(this,"width")},bottomBound:function(){return this.getBound("bottom")-f(this,"height")},leftBound:function(){return this.getBound("left")},midBoundX:function(){return g(this.rightBound()-this.leftBound())},midBoundY:function(){return g(this.bottomBound()-this.topBound())},isOutOfBoundsX:function(){return this.isOutsideLeftBound()||this.isOutsideRightBound()},isOutOfBoundsY:function(){return this.isOutsideTopBound()||this.isOutsideBottomBound()},isOutOfBounds:function(){return this.isOutOfBoundsX()||this.isOutOfBoundsY()},isOnBoundX:function(){return this.isOnLeftBound()||this.isOnRightBound()},isOnBoundY:function(){return this.isOnTopBound()||this.isOnBBound()},isOnBound:function(a){var b,c;return b=e(a),this[""+b+"1"]()<(c=this.getBound(a))&&c<this[""+b+"2"]()},isOutsideBound:function(a){var b,c;switch(c=e(a),b=this.getBound(a),a){case"top":return this.y2()<b;case"right":return this.x1()>b;case"bottom":return this.y1()>b;case"left":return this.x2()<b}}},i=function(){var a;return a=h.uppercaseFirst(b),c["isOn"+a+"Bound"]=_.partial(c.isOnBound,b),c["isOutside"+a+"Bound"]=_.partial(c.isOutsideBound,b)},j=0,k=d.length;k>j;j++)b=d[j],i();return c})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("models/paddle",["require","models/entity","models/mixins/boundable"],function(a){var c,d,e,f;return c=a("models/entity"),e=a("models/mixins/boundable"),d=function(a){function c(){return f=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.defaults=function(){return _.extend({},c.__super__.defaults.apply(this,arguments),{speedX:5})},c.prototype.initialize=function(a,b){return this.bounds=b.bounds,this},c}(c),_.extend(d.prototype,e),d})}.call(this),function(){define("models/mixins/bouncable",["require"],function(){var a;return a={reverseDirection:function(a){var b;return b="dir"+a.toUpperCase(),this[b](-1*this[b]()),this},increaseSpeed:function(a){var b,c,d;return b=a.toUpperCase(),d="speed"+b,c=this[d]()*this.acceleration,c=c<this.maxSpeed?c:this.maxSpeed,this[d](c),this},bounce:function(a){return this.increaseSpeed(a).reverseDirection(a).calculateVelocity(a),this}},a.reverseDirectionX=_.partial(a.reverseDirection,"x"),a.reverseDirectionY=_.partial(a.reverseDirection,"y"),a.increaseSpeedX=_.partial(a.increaseSpeed,"x"),a.increaseSpeedY=_.partial(a.increaseSpeed,"y"),a.bounceX=_.partial(a.bounce,"x"),a.bounceY=_.partial(a.bounce,"y"),a})}.call(this),function(){define("models/mixins/collidable",["require"],function(){var a;return a={isCollidingWithOnAxis:function(a,b){var c,d,e,f;return e=this[""+a+"1"](),f=this[""+a+"2"](),c=b[""+a+"1"](),d=b[""+a+"2"](),e>=c&&d>=e||f>=c&&d>=f},isCollidingWith:function(a){return this.isCollidingWithOnX(a)&&this.isCollidingWithOnY(a)}},a.isCollidingWithOnX=_.partial(a.isCollidingWithOnAxis,"x"),a.isCollidingWithOnY=_.partial(a.isCollidingWithOnAxis,"y"),a})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("models/ball",["require","models/entity","models/mixins/boundable","models/mixins/bouncable","models/mixins/collidable","entities"],function(a){var c,d,e,f,g,h,i;return d=a("models/entity"),f=a("models/mixins/boundable"),e=a("models/mixins/bouncable"),g=a("models/mixins/collidable"),h=a("entities"),c=function(a){function c(){return i=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.minSpeed=1,c.prototype.maxSpeed=4,c.prototype.acceleration=1.04,c.prototype.resetDelay=300,c.prototype.initialize=function(a,b){return this.bounds=b.bounds,this},c.prototype.randomDirection=function(){return Math.random()>.5?1:-1},c.prototype.randomSpeed=function(){return _.random(this.minSpeed,this.maxSpeed)},c.prototype.update=function(){return this.x(this.calcX()).y(this.calcY()),this.isOnBoundX()&&this.bounceX(),this.isOnTopBound()?this.bounceY():this.isOutsideBottomBound()&&this.delayReset(),this.isCollidingWith(h.get("player"))?this.bounceOffPlayer():this.isCollidingWithBricks()&&this.bounceY(),this},c.prototype.isCollidingWithBricks=function(){var a,b,c;c=_.filter(h.all(),function(a,b){return b.indexOf("brick")>-1});for(b in c)if(a=c[b],this.isCollidingWith(a))return a.trigger("collided",this),!0;return!1},c.prototype.bounceOffPlayer=function(){var a;return a=h.get("player"),this.bounceY(),this.vx(this.vx()+a.vx()/7),this},c.prototype.reset=function(){return this.stopMoving().set({x:this.midBoundX(),y:this.midBoundY(),dirX:this.randomDirection(),dirY:this.randomDirection(),speedX:this.randomSpeed(),speedY:this.randomSpeed()}),this.calculateVelocityX().calculateVelocityY(),this},c.prototype.delayReset=function(){var a=this;return this.stopMoving(),_.delay(function(){return a.reset()},this.resetDelay)},c}(d),_.extend(c.prototype,f,e,g),c})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/base",["require"],function(){var a,c;return a=function(a){function d(){return c=d.__super__.constructor.apply(this,arguments)}return b(d,a),d.prototype.bindEvents=function(){return this},d}(Backbone.View)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/entity",["require","views/base"],function(a){var c,d;return c=a("views/base"),d=function(a){function c(){c.__super__.constructor.apply(this,arguments),this.model&&this.listenTo(this.model,"change",this.onEntityChange),this.render()}return b(c,a),c.prototype.shouldRender=!1,c.prototype.setDimensions=function(){return this.model.width(this.el.offsetWidth).height(this.el.offsetHeight),this},c.prototype.doRender=function(){return this.shouldRender||this.needsToRender()?(this.render(),this.shouldRender=!1,this):void 0},c.prototype.needsToRender=function(){return!1},c.prototype.onEntityChange=function(){return this.shouldRender=!0},c}(c)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/ball",["require","views/entity","vent","utils"],function(a){var c,d,e,f,g;return d=a("views/entity"),f=a("vent"),e=a("utils"),c=function(a){function c(){return g=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.initialize=function(){return this.setDimensions(),this.model.reset(),this},c.prototype.render=function(){return this.el.style.left=e.pixelize(this.model.x()),this.el.style.top=e.pixelize(this.model.y()),this},c}(d)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/player",["require","views/entity","vent","utils"],function(a){var c,d,e,f,g;return c=a("views/entity"),f=a("vent"),e=a("utils"),d=function(a){function c(){return g=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.initialize=function(){return this.bindEvents().setDimensions().setPaddleInitialCoords().showPaddle(),this},c.prototype.bindEvents=function(){return this.listenTo(f,"game:resized",this.onGameResized),this.listenTo(f,"controls:keydown",this.onKeydown),this.listenTo(f,"controls:keyup",this.onKeyup),this},c.prototype.setPaddleInitialCoords=function(){return this.model.x(this.model.midBoundX()).y(this.model.bottomBound()),this},c.prototype.showPaddle=function(){return this.$el.removeClass("invisible"),this},c.prototype.render=function(){return this.el.style.left=e.pixelize(this.model.x()),this},c.prototype.isMovementKey=function(a){return"left"===a||"right"===a},c.prototype.onGameResized=function(){return this.setDimensions().setPaddleY()},c.prototype.onKeydown=function(a){return!this.model.isMoving()&&this.isMovementKey(a)?this.model.moveX("left"===a?-1:1):void 0},c.prototype.onKeyup=function(a){return this.isMovementKey(a)?this.model.stopMovingX():void 0},c}(c)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("collections/base",["require"],function(){var a,c;return a=function(a){function d(){return c=d.__super__.constructor.apply(this,arguments)}return b(d,a),d.prototype.bindEvents=function(){return this},d}(Backbone.Collection)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("models/brick",["require","models/entity","models/mixins/boundable","vent"],function(a){var c,d,e,f,g;return d=a("models/entity"),e=a("models/mixins/boundable"),f=a("vent"),c=function(a){function c(){return g=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.defaults=function(){return _.extend({},c.__super__.defaults.apply(this,arguments),{height:20})},c.prototype.initialize=function(a,b){return this.bounds=b.bounds,this.bindEvents().calculateGeometry()},c.prototype.bindEvents=function(){return this.on("collided",this.onCollided),this.listenTo(f,"game:resized",this.onGameResized),this},c.prototype.calculateGeometry=function(){return this.calculateDimensions().calculateCoords(),this},c.prototype.calculateDimensions=function(){return this.width(this.getBound("right")/this.cols()),this},c.prototype.calculateCoords=function(){return this.x(this.col()*this.width()),this.y(this.row()*this.height()),this},c.prototype.onGameResized=function(){return this.calculateGeometry()},c.prototype.onCollided=function(){return this.destroy()},c}(d),_.extend(c.prototype,e),c.shorthandify("row rows col cols".split(" ")),c})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("collections/bricks",["require","collections/base","models/brick"],function(a){var c,d,e,f;return c=a("collections/base"),d=a("models/brick"),e=function(a){function c(){return f=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.model=d,c.prototype.initialize=function(a,b){return this.bounds=b.bounds,this.buildBricks(b.rows,b.cols),this},c.prototype.buildBricks=function(a,b){var c,d,e,f,g;for(a-=1,b-=1,c=[],d=f=0;a>=0?a>=f:f>=a;d=a>=0?++f:--f)for(e=g=0;b>=0?b>=g:g>=b;e=b>=0?++g:--g)c.push({row:d,rows:a+1,col:e,cols:b+1});return this.reset(c,{bounds:this.bounds}),this},c}(c)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/brick",["require","views/entity","utils"],function(a){var c,d,e,f;return d=a("views/entity"),e=a("utils"),c=function(a){function c(){return f=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.className="block",c.prototype.render=function(){return this.el.style.left=e.pixelize(this.model.x()),this.el.style.top=e.pixelize(this.model.y()),this.el.style.width=e.pixelize(this.model.width()),this.el.style.height=e.pixelize(this.model.height()),this},c.prototype.fall=function(){return this.$el.addClass("falling"),this},c.prototype.remove=function(){var a=this;return this.fall(),_.delay(function(){return c.__super__.remove.apply(a,arguments)},1e3)},c}(d)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/bricks",["require","views/base","views/brick"],function(a){var c,d,e,f;return c=a("views/base"),d=a("views/brick"),e=function(a){function c(){return f=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.itemView=d,c.prototype.initialize=function(){return this.bindEvents().createChildViews(),this},c.prototype.bindEvents=function(){return this.listenTo(this.collection,"remove",this.onRemove),this},c.prototype.createChildViews=function(){var a=this;return this.childViews={},this.collection.each(function(b){return a.addChildView(b)}),this},c.prototype.addChildView=function(a){var b;return b=new this.itemView({model:a}),this.childViews[a.cid]=b,this.$el.append(b.el),this},c.prototype.removeChildView=function(a){var b;return b=this.childViews[a],this.childViews[a]=null,b.remove(),this},c.prototype.onRemove=function(a){return this.removeChildView(a.cid)},c}(c)})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/bounds",["require","vent","views/base","models/mixins/boundable"],function(a){var c,d,e,f,g;return f=a("vent"),c=a("views/base"),e=a("models/mixins/boundable"),d=function(a){function c(){return g=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.el=window,c.prototype.top=0,c.prototype.right=null,c.prototype.bottom=null,c.prototype.left=0,c.prototype.events={resize:"onResize"},c.prototype.initialize=function(){return this.updateBounds(),this},c.prototype.updateBounds=function(){var a;return this.right=this.el.innerWidth,this.bottom=this.el.innerHeight,a=_.pick(this,"top","right","bottom","left"),f.trigger("game:resized",a),this},c.prototype.onResize=_.debounce(function(){return this.updateBounds()},750),c}(c),_.extend(d.prototype,e),d})}.call(this),function(){var a={}.hasOwnProperty,b=function(b,c){function d(){this.constructor=b}for(var e in c)a.call(c,e)&&(b[e]=c[e]);return d.prototype=c.prototype,b.prototype=new d,b.__super__=c.prototype,b};define("views/controls",["require","views/base","vent"],function(a){var c,d,e,f,g;return c=a("views/base"),f=a("vent"),e={38:"up",39:"right",40:"down",37:"left"},d=function(a){function c(){return g=c.__super__.constructor.apply(this,arguments)}return b(c,a),c.prototype.el=window,c.prototype.events={keyup:"onKey",keydown:"onKey"},c.prototype.onKey=function(a){return a.which in e?f.trigger("controls:"+a.type,e[a.which]):void 0},c}(c)})}.call(this),function(){define("app",["require","vent","entities","models/paddle","models/ball","views/ball","views/player","collections/bricks","views/bricks","views/bounds","views/controls"],function(a){var b,c,d,e,f,g,h,i,j,k,l,m;return m=a("vent"),k=a("entities"),i=a("models/paddle"),c=a("models/ball"),d=a("views/ball"),j=a("views/player"),f=a("collections/bricks"),g=a("views/bricks"),e=a("views/bounds"),h=a("views/controls"),l=requestAnimationFrame,b=function(){function a(){}return a.prototype.start=function(){return this.entities=k,this.views=[],this.createInstances().tick(),this},a.prototype.createInstances=function(){return this.createStructures().createModels().createViews(),this},a.prototype.createStructures=function(){return this.bounds=new e,this.controls=new h,this},a.prototype.addView=function(a){return this.views.push(a),this},a.prototype.addEntity=function(){return this.entities.set.apply(this.entities,arguments),this},a.prototype.createModels=function(){return this},a.prototype.createViews=function(){var a,b,e,h,k,l;k=new j({el:"#player-1",model:new i({},{bounds:this.bounds})}),this.addView(k).addEntity("player",k.model),window.player=k,a=new d({el:"#ball",model:new c({},{bounds:this.bounds})}),this.addView(a).addEntity("ball",a.model),window.ball=a,h=new g({el:"#blocks-grid",collection:new f(null,{rows:5,cols:10,bounds:this.bounds})}),l=h.childViews;for(b in l)e=l[b],this.addView(e).addEntity("brick-"+b,e.model);return this},a.prototype.update=function(){var a,b,c;c=this.entities.all();for(b in c)a=c[b],a.doUpdate();return this},a.prototype.render=function(){var a,b,c,d;for(d=this.views,b=0,c=d.length;c>b;b++)a=d[b],a.doRender();return this},a.prototype.tick=function(){var a=this;return this.update().render(),l(function(){return a.tick()})},a}()})}.call(this),function(){require(["app"],function(a){return window.app=(new a).start()})}.call(this),define("main",function(){})}();