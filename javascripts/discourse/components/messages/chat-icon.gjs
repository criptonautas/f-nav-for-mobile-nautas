import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import icon from "discourse-common/helpers/d-icon";
import getURL from "discourse-common/lib/get-url";
import { optionalRequire } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

export default class ChatIcon extends Component {
  @service currentUser;
  @service site;
  @service chatStateManager;
  @service router;

  get showUnreadIndicator() {
    return !this.currentUserInDnD;
  }

  get ChatHeaderIconUnreadIndicator() {
    return optionalRequire(
      "discourse/plugins/chat/discourse/components/chat/header/icon/unread-indicator"
    );
  }

  get currentUserInDnD() {
    return this.args.currentUserInDnD || this.currentUser.isInDoNotDisturb();
  }

  // Inside the chat the button leads back to the forum, as the AI bot's does from its
  // conversations (ai-bot.gjs): same icon, same idea.
  get isInChat() {
    const route = this.router.currentRouteName || "";
    return route === "chat" || route.startsWith("chat.");
  }

  get title() {
    return i18n(
      this.isInChat ? "sidebar.back_to_forum" : "chat.title_capitalized"
    );
  }

  get icon() {
    return this.isInChat ? "shuffle" : "d-chat";
  }

  get href() {
    return this.isInChat
      ? getURL(this.chatStateManager.lastKnownAppURL || "/")
      : getURL(this.chatStateManager.lastKnownChatURL || "/chat");
  }

  <template>
    <DButton
      @href={{this.href}}
      tabindex="0"
      class="icon chat-icon btn-flat"
      title={{this.title}}
    >
      {{~icon this.icon~}}
      {{#if this.showUnreadIndicator}}
        <this.ChatHeaderIconUnreadIndicator
          @urgentCount={{@urgentCount}}
          @unreadCount={{@unreadCount}}
          @indicatorPreference={{@indicatorPreference}}
        />
      {{/if}}
    </DButton>
  </template>
}
