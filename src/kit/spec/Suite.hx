package kit.spec;

import kit.spec.Outcome;
import kit.spec.Spec;

using Type;
using kit.Sugar;

abstract class Suite {
	final events:Events;
	final suites:Array<SuiteSection> = [];
	var currentSuite:Maybe<SuiteSection> = None;

	final public function new(events) {
		this.events = events;
	}

	abstract function execute():Void;

	public function run() {
		execute();
		return Task.sequence(...suites.map(s -> s.run())).next(outcomes -> new SuiteOutcome(this.getClass().getClassName(), [], outcomes));
	}

	function describe(description:String, specs:() -> Void) {
		var previous = currentSuite;
		var suite = new SuiteSection(description, events);
		currentSuite = Some(suite);

		switch previous {
			case Some(parent):
				parent.addChild(suite);
			case None:
				suites.push(suite);
		}

		specs();
		currentSuite = previous;
	}

	function it(description:String, ?body:SpecBody) {
		switch currentSuite {
			case Some(suite):
				suite.addSpec(new Spec(events, description, body));
			case None:
				throw 'Cannot use `it` outside of a suite';
		}
	}
}

class SuiteSection {
	final description:String;
	final events:Events;
	final children:Array<SuiteSection> = [];
	final specs:Array<Spec> = [];

	public function new(description, events) {
		this.description = description;
		this.events = events;
	}

	public function addSpec(spec:Spec) {
		specs.push(spec);
	}

	public function addChild(child:SuiteSection) {
		children.push(child);
	}

	public function run():Task<SuiteOutcome> {
		return Task.sequence(...specs.map(spec -> spec.run())).next(specOutcomes -> Task.sequence(...children.map(s -> s.run())).next(childrenOutcomes -> {
			var outcome = new SuiteOutcome(description, specOutcomes, childrenOutcomes);
			events.onSuiteComplete.dispatch(outcome);
			outcome;
		}));
	}
}
